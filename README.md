# swift-ast-parser

A fast and lightweight command-line tool for parsing Swift source code and extracting Abstract Syntax Tree (AST) information. Built on [SwiftSyntax](https://github.com/swiftlang/swift-syntax), it outputs structured JSON data about classes, structs, functions, and other Swift symbols.

Perfect for CI/CD pipelines, code analysis tools, documentation generators, and automated code review systems.

## Installation

### Build from Source

```bash
git clone https://github.com/austin2408/swift-ast-parser.git
cd swift-ast-parser
swift build -c release
```

The compiled binary will be at `.build/release/swift-ast-parser`.

### Install Locally

```bash
swift build -c release --static-swift-stdlib
cp .build/release/swift-ast-parser /usr/local/bin/
```

### Build Standalone Executable

To build a standalone executable with statically linked Swift libraries (recommended for distribution):

```bash
swift build -c release --static-swift-stdlib
```

The standalone binary will be at `.build/release/swift-ast-parser` and can be distributed without Swift runtime dependencies.

## Usage

### Basic Usage

Parse a single Swift file:

```bash
swift-ast-parser MyFile.swift
```

### Deep Scan Mode

Enable detection of nested symbols within function bodies:

```bash
swift-ast-parser MyFile.swift --deep
```

### Process Multiple Files

Analyze all Swift files in a directory:

```bash
swift-ast-parser Sources/
```

### Recursive Directory Processing

Process all Swift files recursively in a directory tree:

```bash
swift-ast-parser . --recursive
swift-ast-parser Sources/ --recursive --deep
```

### Help

```bash
swift-ast-parser --help
```

## Output Format

### Single File Output

When processing a single file, the output is an array of symbols:

```json
[
  {
    "kind": "class",
    "name": "MyClass",
    "startLine": 10,
    "endLine": 50,
    "members": [
      {
        "kind": "var",
        "name": "property",
        "startLine": 11,
        "endLine": 11,
        "members": []
      },
      {
        "kind": "func",
        "name": "myMethod",
        "startLine": 13,
        "endLine": 20,
        "members": []
      }
    ]
  }
]
```

### Multiple Files Output

When processing multiple files (directory or recursive), the output includes file paths:

```json
[
  {
    "file": "/path/to/File1.swift",
    "symbols": [
      {
        "kind": "class",
        "name": "MyClass",
        "startLine": 10,
        "endLine": 50,
        "members": []
      }
    ]
  },
  {
    "file": "/path/to/File2.swift",
    "symbols": [
      {
        "kind": "struct",
        "name": "MyStruct",
        "startLine": 5,
        "endLine": 20,
        "members": []
      }
    ]
  }
]
```

### Symbol Types

Currently supported common Swift symbol types:

- `class` - Class declarations
- `struct` - Struct declarations
- `enum` - Enum declarations
- `protocol` - Protocol declarations
- `extension` - Extension declarations
- `func` - Function declarations
- `var` - Variable/property declarations
- `init` - Initializer declarations
- `deinit` - Deinitializer declarations

## Requirements

- Swift 5.9+

### Changing Swift Version

To build with a specific Swift version, modify `Package.swift`:
Check available [SwiftSyntax](https://github.com/swiftlang/swift-syntax) versions at [Swift Package Index](https://swiftpackageindex.com/swiftlang/swift-syntax)

## License

MIT License - See [LICENSE](LICENSE) file for details.