import Foundation
import ArgumentParser

struct Pizzabot: ParsableCommand {
    @Argument(help: "The grid and addresses for pizza delivery. e.g: \"5x5 (1, 3) (4, 4)\"")
    var input: String

    mutating func run() throws {
        let result = PizzabotEngine.parseInput(input)

        switch result {
        case .success(let deliveryInstruction):
            print(PizzabotEngine.calculateDeliveryRoute(deliveryInstruction: deliveryInstruction))
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

Pizzabot.main()
