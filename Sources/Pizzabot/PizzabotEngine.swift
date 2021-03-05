//
//  PizzabotEngine.swift
//  Pizzabot
//
//  Created by Spencer Müller Diniz on 05/03/21.
//

import Foundation

class PizzabotEngine {
    static func parseInput(_ input: String) -> Result<DeliveryInstruction, PizzabotError> {
        let inputComponents = input
            .replacingOccurrences(of: ", ", with: ",")
            .components(separatedBy: " ")

        if let gridComponent = inputComponents.first {
            let dimensions = gridComponent
                .lowercased()
                .components(separatedBy: "x")

            if dimensions.count == 2, let width = Int(dimensions[0]), let height = Int(dimensions[1]) {
                let grid = Grid(width: width, height: height)

                let addressComponents = inputComponents.dropFirst()
                var addresses = [Address]()

                for addressComponent in addressComponents {
                    let addressString = addressComponent
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: " ", with: "")

                    let coordinates = addressString.components(separatedBy: ",")

                    if coordinates.count == 2, let x = Int(coordinates[0]), let y = Int(coordinates[1]) {
                        if x < 0 || x > grid.width - 1 || y < 0 || y > grid.height - 1 {
                            let error = PizzabotError(localizedDescription: "Invalid input. Address out of bounds (\(x), \(y)).")
                            return .failure(error)
                        }

                        let address = Address(x: x, y: y)
                        addresses.append(address)
                    }
                    else {
                        let error = PizzabotError(localizedDescription: "Invalid input. Enable to parse address coordinates. (\(addressString))")
                        return .failure(error)
                    }
                }

                return .success(DeliveryInstruction(grid: grid, addresses: addresses))
            }
            else {
                let error = PizzabotError(localizedDescription: "Invalid input. Enable to parse grid. (\(gridComponent))")
                return .failure(error)
            }
        }
        else {
            let error = PizzabotError(localizedDescription: "Invalid input. Enable to parse delivery instructions.")
            return .failure(error)
        }
    }

    static func calculateDeliveryRoute(deliveryInstruction: DeliveryInstruction) -> String {
        var currentAddress = Address(x: 0, y: 0)
        var route = ""

        for address in deliveryInstruction.addresses {
            let deltaX = address.x - currentAddress.x
            let deltaY = address.y - currentAddress.y

            if deltaX > 0 {
                route += String(repeating: "E", count: deltaX)
            }
            else if deltaX < 0 {
                route += String(repeating: "W", count: abs(deltaX))
            }

            if deltaY > 0 {
                route += String(repeating: "N", count: deltaY)
            }
            else if deltaY < 0 {
                route += String(repeating: "S", count: abs(deltaY))
            }

            route += "D"
            currentAddress = Address(x: address.x, y: address.y)
        }

        return route
    }
}
