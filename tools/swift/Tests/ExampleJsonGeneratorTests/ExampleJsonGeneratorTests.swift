import XCTest
@testable import ExampleJsonGenerator

final class ExampleJsonGeneratorTests: XCTestCase {
    func testValidate() throws {
        try AssertExecuteCommand(command: "ExampleJsonGenerator validate", expected: "Validation successful!")
    }
}
