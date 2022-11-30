import ArgumentParser
import Foundation

extension ExampleJsonGenerator {
    struct Build: ParsableCommand {
        @Option(
            help: "Build only for the provided environemnt.",
            completion: .list(Environment.allCases.map { $0.rawValue })
        )
        var buildOnly: Environment?

        mutating func run() throws {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            switch buildOnly {
            case .none:
                try write(config: .int, using: encoder)
                try write(config: .intNft, using: encoder)
                try write(config: .prod, using: encoder)
            case .int:
                try write(config: .int, using: encoder)
            case .intNft:
                try write(config: .intNft, using: encoder)
            case .prod:
                try write(config: .prod, using: encoder)
            }

            print("Build successful!")
        }

        private func write(config environment: Environment, using encoder: JSONEncoder) throws {
            let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent(environment.configPath)
            try encoder.encode(environment.config).write(to: url)
        }
    }
}
