import ArgumentParser

@main
struct ExampleJsonGenerator: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "json-generate",
        abstract: "A helper for generating JSON output from Swift defined models.",
        subcommands: [Build.self, Validate.self]
    )
}

extension ExampleJsonGenerator {
    enum Environment: String, ExpressibleByArgument, CaseIterable {
        case int = "int"
        case intNft = "int-nft"
        case prod = "prod"

        var configPath: String {
            switch self {
            case .int: return "modules/example-config/configs/int/ios/config.json"
            case .intNft: return "modules/example-config/configs/int-nft/ios/config.json"
            case .prod: return "modules/example-config/configs/prod/ios/config.json"
            }
        }

        var config: ConfigurationModel {
            switch self {
            case .int: return Configuration.intConfig
            case .intNft: return Configuration.intNftConfig
            case .prod: return Configuration.prodConfig
            }
        }

        init?(argument: String) {
            switch argument {
            case "int": self = .int
            case "int-nft": self = .intNft
            case "prod": self = .prod
            default: return nil
            }
        }
    }
}
