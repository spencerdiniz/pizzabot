import XCTest
import class Foundation.Bundle

final class PizzabotTests: XCTestCase {
    var process: Process!
    var pipe: Pipe!

    override func setUp() {
        let binary = productsDirectory.appendingPathComponent("Pizzabot")

        process = Process()
        process.executableURL = binary

        pipe = Pipe()
        process.standardOutput = pipe

    }

    func testSuccess1() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        process.arguments = ["5x5 (0, 0) (1, 3) (4,4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "DENNNDEEENDSSDDWWWWSDEEENDWNDEESSD\n")
    }

    func testSuccess2() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        process.arguments = ["5x5 (1, 3) (4, 4)"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "ENNNDEEEND\n")
    }

    func testBadGrid() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        process.arguments = ["5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Invalid input. Enable to parse grid. (5)\n")
    }

    func testBadAddress() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        process.arguments = ["5x5 (0, asa) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Invalid input. Enable to parse address coordinates. (0,asa)\n")
    }

    func testOutOfBounds() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        process.arguments = ["5x5 (0, 0) (1, 3) (-4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Invalid input. Address out of bounds (-4, 4).\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testSuccess1", testSuccess1),
        ("testSuccess2", testSuccess1),
        ("testBadGrid", testBadGrid),
        ("testBadAddress", testBadAddress),
        ("testOutOfBounds", testBadGrid)
    ]

}
