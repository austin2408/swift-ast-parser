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
### Install Locally

```bash
cp .build/release/swift-ast-parser /usr/local/bin/
```
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

### Type Detection

Include type information for variables using the `--show-type` flag:

```bash
swift-ast-parser MyFile.swift --show-type
```

This detects variable types from:
- Explicit type annotations: `let foo: UICollectionView`
- Constructor calls: `let foo = UICollectionView()`
- Custom classes: `let foo = CustomCollectionView()`
- Literals: `let x = 42` (Int), `let y = 1.5` (Double), `let s = "hello"` (String)
- Property access: `let color = UIColor.red`

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

### With Type Detection

When using the `--show-type` flag, variable declarations include type information:

```json
[
  {
    "kind": "class",
    "name": "ViewController",
    "startLine": 3,
    "endLine": 20,
    "members": [
      {
        "kind": "var",
        "name": "collectionView",
        "startLine": 5,
        "endLine": 5,
        "members": [],
        "type": "UICollectionView"
      },
      {
        "kind": "var",
        "name": "count",
        "startLine": 6,
        "endLine": 6,
        "members": [],
        "type": "Int"
      },
      {
        "kind": "var",
        "name": "title",
        "startLine": 7,
        "endLine": 7,
        "members": [],
        "type": "String"
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
- `var` - Variable/property declarations (includes optional `type` field with `--show-type`)
- `init` - Initializer declarations
- `deinit` - Deinitializer declarations

## Type Detection

The `--show-type` flag enables automatic type detection for variables. The parser analyzes the Swift syntax to determine types in multiple ways:

### Detection Methods

1. **Explicit Type Annotations**
   ```swift
   let collectionView: UICollectionView
   ```
   Detected type: `UICollectionView`

2. **Constructor Calls**
   ```swift
   let tableView = UITableView()
   let number = UInt64(100)
   ```
   Detected types: `UITableView`, `UInt64`

3. **Custom Classes**
   ```swift
   class CustomView: UIView { }
   let view = CustomView()
   ```
   Detected type: `CustomView`

4. **Literal Values**
   - Integers: `let x = 42` → `Int`
   - Floating-point: `let y = 1.5` → `Double`
   - Strings: `let s = "hello"` → `String`
   - Booleans: `let b = true` → `Bool`
   - Arrays: `let arr = [1, 2, 3]` → `Array`

5. **Property Access**
   ```swift
   let color = UIColor.red
   ```
   Detected type: `UIColor`

### Example Usage

```bash
# Parse with type detection
swift-ast-parser MyViewController.swift --show-type

# Combine with other flags
swift-ast-parser Sources/ --recursive --show-type
swift-ast-parser MyFile.swift --deep --show-type
```

## Requirements

- Swift 5.9 or later

### Changing Swift Version

To build with a specific Swift version, modify `Package.swift`:
Check available [SwiftSyntax](https://github.com/swiftlang/swift-syntax) versions at [Swift Package Index](https://swiftpackageindex.com/swiftlang/swift-syntax)

## License

MIT License - See [LICENSE](LICENSE) file for details.