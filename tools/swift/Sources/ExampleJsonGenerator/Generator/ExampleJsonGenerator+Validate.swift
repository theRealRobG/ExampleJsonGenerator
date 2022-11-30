import ArgumentParser
import Foundation

extension ExampleJsonGenerator {
    struct Validate: ParsableCommand {
        mutating func run() throws {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            try validate(config: .int, using: encoder)
            try validate(config: .intNft, using: encoder)
            try validate(config: .prod, using: encoder)

            print("Validation successful!")
        }

        private func validate(config environment: Environment, using encoder: JSONEncoder) throws {
            guard FileManager.default.fileExists(atPath: environment.configPath) else {
                throw ValidationError.configDoesNotExist(environment)
            }
            guard let configData = FileManager.default.contents(atPath: environment.configPath) else {
                throw ValidationError.emptyFileContents(environment)
            }
            let expectedConfigData = try encoder.encode(environment.config)
            guard configData == expectedConfigData else {
                throw ValidationError.misMatchFileContents(environment)
            }
        }
    }

    enum ValidationError: CustomNSError, CustomStringConvertible {
        case configDoesNotExist(Environment)
        case emptyFileContents(Environment)
        case misMatchFileContents(Environment)

        static var errorDomain: String { "JsonGeneratorErrorDomain" }

        var errorCode: Int {
            switch self {
            case .configDoesNotExist: return 1
            case .emptyFileContents: return 2
            case .misMatchFileContents: return 3
            }
        }

        var errorUserInfo: [String: Any] {
            return [NSLocalizedDescriptionKey: description]
        }

        var description: String {
            switch self {
            case .configDoesNotExist(let environment):
                return "Config file for \(environment.rawValue) environment does not exist."
            case .emptyFileContents(let environment):
                return "Config file is empty for \(environment.rawValue) environment."
            case .misMatchFileContents(let environment):
                return "Config file for \(environment.rawValue) environment contains unexpected data."
            }
        }
    }
}
