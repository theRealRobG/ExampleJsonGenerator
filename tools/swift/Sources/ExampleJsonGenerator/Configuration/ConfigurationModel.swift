import Foundation

struct ConfigurationModel: Encodable {
    var exampleSimpleProperty: String
    var exampleComplicatedProperty: ExampleChildObject
    var exampleArrayOfEnums: [PlaybackType]
}

struct ExampleChildObject: Encodable {
    var exampleChildObject: ExampleGrandChildObject
}

struct ExampleGrandChildObject: Encodable {
    var exampleNumber: Double
}

enum PlaybackType: String, Encodable {
    case vod = "VOD"
    case live = "LIVE"
    case event = "EVENT"
}
