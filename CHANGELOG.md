# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of swift-ast-parser
- Support for parsing Swift AST and extracting symbol information
- JSON output format with symbol hierarchy
- Deep scan mode for nested function symbols
- Support for multiple files and directories
- Recursive directory processing
- Documentation with CI/CD integration examples
- Comprehensive error handling and validation
- Symbol types: class, struct, enum, protocol, extension, func, var, init, deinit

### Features
- Command-line interface with `--deep` and `--recursive` flags
- Line range tracking for all symbols
- Backward-compatible single-file output
- Multi-file batch processing with file paths

## [0.1.0] - 2025-11-15

### Added
- Initial development version
