@main
public struct ExampleJsonGenerator {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(ExampleJsonGenerator().text)
    }
}
