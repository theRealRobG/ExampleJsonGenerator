struct Configuration {
    // MARK: - DEFAULT

    static let `default` = ConfigurationModel(
        exampleSimpleProperty: "Default",
        exampleComplicatedProperty: ExampleChildObject(
            exampleChildObject: ExampleGrandChildObject(exampleNumber: 100)
        ),
        exampleArrayOfEnums: [.vod]
    )

    // MARK: - PROD

    static var prodConfig: ConfigurationModel {
        var config = Self.default

        config.exampleSimpleProperty = "PROD"

        return config
    }

    // MARK: - INT

    static var intConfig: ConfigurationModel {
        var config = Self.default

        config.exampleSimpleProperty = "INT"
        config.exampleComplicatedProperty.exampleChildObject.exampleNumber = 42
        config.exampleArrayOfEnums.append(.live)

        return config
    }

    // MARK: - INT-NFT

    static var intNftConfig: ConfigurationModel {
        var config = Self.intConfig

        config.exampleSimpleProperty = "INT-NFT"

        return config
    }
}
