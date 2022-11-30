import XCTest
import ArgumentParser

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension CollectionDifference.Change {
    var offset: Int {
        switch self {
        case .insert(let offset, _, _):
            return offset
        case .remove(let offset, _, _):
            return offset
        }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension CollectionDifference.Change: Comparable where ChangeElement: Equatable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.offset == rhs.offset else {
            return lhs.offset < rhs.offset
        }
        switch (lhs, rhs) {
        case (.remove, .insert):
            return true
        case (.insert, .remove):
            return false
        default:
            return true
        }
    }
}

extension XCTest {
    public var debugURL: URL {
        let bundleURL = Bundle(for: type(of: self)).bundleURL
        return bundleURL.lastPathComponent.hasSuffix("xctest")
        ? bundleURL.deletingLastPathComponent()
        : bundleURL
    }

    public func AssertExecuteCommand(
        command: String,
        expected: String? = nil,
        exitCode: ExitCode = .success,
        file: StaticString = #file, line: UInt = #line) throws
    {
        try AssertExecuteCommand(
            command: command.split(separator: " ").map(String.init),
            expected: expected,
            exitCode: exitCode,
            file: file,
            line: line)
    }

    public func AssertExecuteCommand(
        command: [String],
        expected: String? = nil,
        exitCode: ExitCode = .success,
        file: StaticString = #file, line: UInt = #line) throws
    {
#if os(Windows)
        throw XCTSkip("Unsupported on this platform")
#endif

        let arguments = Array(command.dropFirst())
        let commandName = String(command.first!)
        let commandURL = debugURL.appendingPathComponent(commandName)
        guard (try? commandURL.checkResourceIsReachable()) ?? false else {
            XCTFail("No executable at '\(commandURL.standardizedFileURL.path)'.",
                    file: file, line: line)
            return
        }

#if !canImport(Darwin) || os(macOS)
        let process = Process()
        if #available(macOS 10.13, *) {
            process.executableURL = commandURL
        } else {
            process.launchPath = commandURL.path
        }
        process.arguments = arguments

        let output = Pipe()
        process.standardOutput = output
        let error = Pipe()
        process.standardError = error

        if #available(macOS 10.13, *) {
            guard (try? process.run()) != nil else {
                XCTFail("Couldn't run command process.", file: file, line: line)
                return
            }
        } else {
            process.launch()
        }
        process.waitUntilExit()

        let outputData = output.fileHandleForReading.readDataToEndOfFile()
        let outputActual = String(data: outputData, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

        let errorData = error.fileHandleForReading.readDataToEndOfFile()
        let errorActual = String(data: errorData, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

        if let expected = expected {
            AssertEqualStrings(
                actual: errorActual + outputActual,
                expected: expected,
                file: file,
                line: line)
        }

        XCTAssertEqual(process.terminationStatus, exitCode.rawValue, file: file, line: line)
#else
        throw XCTSkip("Not supported on this platform")
#endif
    }
}

public func AssertEqualStrings(actual: String, expected: String, file: StaticString = #file, line: UInt = #line) {
    // If the input strings are not equal, create a simple diff for debugging...
    guard actual != expected else {
        // Otherwise they are equal, early exit.
        return
    }

    // Split in the inputs into lines.
    let actualLines = actual.split(separator: "\n", omittingEmptySubsequences: false)
    let expectedLines = expected.split(separator: "\n", omittingEmptySubsequences: false)

    // If collectionDifference is available, use it to make a nicer error message.
    if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
        // Compute the changes between the two strings.
        let changes = actualLines.difference(from: expectedLines).sorted()

        // Render the changes into a diff style string.
        var diff = ""
        var expectedLines = expectedLines[...]
        for change in changes {
            if expectedLines.startIndex < change.offset {
                for line in expectedLines[..<change.offset] {
                    diff += "  \(line)\n"
                }
                expectedLines = expectedLines[change.offset...].dropFirst()
            }

            switch change {
            case .insert(_, let line, _):
                diff += "- \(line)\n"
            case .remove(_, let line, _):
                diff += "+ \(line)\n"
            }
        }
        for line in expectedLines {
            diff += "  \(line)\n"
        }
        XCTFail("Strings are not equal.\n\(diff)", file: file, line: line)
    } else {
        XCTAssertEqual(
            actualLines.count,
            expectedLines.count,
            "Strings have different numbers of lines.",
            file: file,
            line: line)
        for (actualLine, expectedLine) in zip(actualLines, expectedLines) {
            XCTAssertEqual(actualLine, expectedLine, file: file, line: line)
        }
    }
}

