// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSyntax
import SwiftParser

let version = "0.1.0"

func printUsage() {
    print("""
    swift-ast-parser v\(version)
    
    Usage: swift-ast-parser <path> [options]
    
    Arguments:
      <path>        Path to a Swift file or directory
    
    Options:
      --deep        Enable detection of nested functions and symbols
      --recursive   Process directories recursively
      --version     Show version information
      --help        Show this help message
    
    Examples:
      swift-ast-parser MyFile.swift
      swift-ast-parser MyFile.swift --deep
      swift-ast-parser Sources/ --recursive
      swift-ast-parser . --recursive --deep
    """)
}

func printError(_ message: String, exitCode: Int32 = 1) {
    fputs("Error: \(message)\n", stderr)
    exit(exitCode)
}

struct FileResult: Codable {
    let file: String
    let symbols: [SymbolInfo]
}

func parseSwiftFile(at url: URL, deepScan: Bool) -> [SymbolInfo]? {
    // Read and parse file
    guard let source = try? String(contentsOf: url, encoding: .utf8) else {
        fputs("Warning: Failed to read file: \(url.path)\n", stderr)
        return nil
    }
    
    // Parse Swift syntax
    let sourceFile = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: url.path, tree: sourceFile)
    
    // Collect symbols
    let collector = SwiftASTCollector(sourceFile: sourceFile, locationConverter: converter, deepScan: deepScan)
    return collector.topLevelSymbols
}

func findSwiftFiles(at path: String, recursive: Bool) -> [URL] {
    let fileManager = FileManager.default
    let url = URL(fileURLWithPath: path)
    
    var isDirectory: ObjCBool = false
    guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
        return []
    }
    
    if !isDirectory.boolValue {
        // Single file
        return url.pathExtension == "swift" ? [url] : []
    }
    
    // Directory - find all Swift files
    var swiftFiles: [URL] = []
    
    if recursive {
        if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles]) {
            for case let fileURL as URL in enumerator {
                if fileURL.pathExtension == "swift" {
                    swiftFiles.append(fileURL)
                }
            }
        }
    } else {
        if let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles]) {
            swiftFiles = contents.filter { $0.pathExtension == "swift" }
        }
    }
    
    return swiftFiles
}

// Parse arguments
let arguments = CommandLine.arguments.dropFirst()
guard !arguments.isEmpty else {
    printUsage()
    exit(1)
}

if arguments.contains("--help") {
    printUsage()
    exit(0)
}

if arguments.contains("--version") {
    print("swift-ast-parser version \(version)")
    exit(0)
}

let path = arguments.first { !$0.hasPrefix("--") }
guard let path = path else {
    printError("No input path specified")
    exit(1)
}

let deepScan = arguments.contains("--deep")
let recursive = arguments.contains("--recursive")

// Find Swift files
let swiftFiles = findSwiftFiles(at: path, recursive: recursive)
guard !swiftFiles.isEmpty else {
    printError("No Swift files found at: \(path)")
    exit(1)
}

// Parse all files
var results: [FileResult] = []
for fileURL in swiftFiles {
    if let symbols = parseSwiftFile(at: fileURL, deepScan: deepScan) {
        results.append(FileResult(file: fileURL.path, symbols: symbols))
    }
}

// Output as JSON
do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    
    // If only one file, output symbols directly for backward compatibility
    if results.count == 1 {
        let data = try encoder.encode(results[0].symbols)
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
    } else {
        // Multiple files - output array of file results
        let data = try encoder.encode(results)
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
    }
} catch {
    printError("Failed to encode output: \(error.localizedDescription)")
}
