//
//  Models.swift
//  Pizzabot
//
//  Created by Spencer Müller Diniz on 05/03/21.
//

import Foundation

struct PizzabotError: Error {
    let localizedDescription: String
}

struct Grid {
    let width: Int
    let height: Int
}

struct Address {
    let x: Int
    let y: Int
}

struct DeliveryInstruction {
    let grid: Grid
    let addresses: [Address]
}
