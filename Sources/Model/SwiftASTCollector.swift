//
//  SwiftASTCollector.swift
//  swift-ast-parser
//
//  Created by Austin Huang on 2025/11/15.
//
import Foundation
import SwiftSyntax
import SwiftParser

/// Collects Swift AST symbols by walking through a parsed Swift syntax tree.
///
/// This visitor traverses the Abstract Syntax Tree (AST) of Swift source code and extracts
/// information about various symbol types including classes, structs, enums, protocols,
/// extensions, functions, variables, and initializers.
///
/// The collector supports two modes:
/// - **Normal mode**: Collects top-level symbols and members of types, but treats functions as leaf nodes
/// - **Deep scan mode**: Additionally captures nested symbols within function bodies
class SwiftASTCollector: SyntaxVisitor {
    /// Converts syntax positions to source locations (line and column numbers)
    private let locationConverter: SourceLocationConverter
    
    /// When true, enables detection of nested symbols within function bodies
    private let deepScan: Bool
    
    /// Stack tracking the current nesting hierarchy during AST traversal
    private var stack: [SymbolInfo] = []
    
    /// The collected top-level symbols and their nested members
    private(set) var topLevelSymbols: [SymbolInfo] = []
    
    /// Tracks nesting depth within functions during deep scan mode
    private var insideFunctionDepth: Int = 0

    /// Initializes a new AST collector and immediately walks the provided syntax tree.
    ///
    /// - Parameters:
    ///   - sourceFile: The parsed Swift source file syntax tree to analyze
    ///   - locationConverter: Converter for translating syntax positions to source locations
    ///   - deepScan: Whether to scan inside function bodies for nested symbols (default: false)
    init(sourceFile: SourceFileSyntax, locationConverter: SourceLocationConverter, deepScan: Bool = false) {
        self.locationConverter = locationConverter
        self.deepScan = deepScan
        super.init(viewMode: .sourceAccurate)
        walk(sourceFile)
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        enterContainer(node, kind: "class", name: node.name.text)
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        exitContainer()
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        enterContainer(node, kind: "struct", name: node.name.text)
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        exitContainer()
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        enterContainer(node, kind: "enum", name: node.name.text)
        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        exitContainer()
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        enterContainer(node, kind: "protocol", name: node.name.text)
        return .visitChildren
    }

    override func visitPost(_ node: ProtocolDeclSyntax) {
        exitContainer()
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.extendedType.description.trimmingCharacters(in: .whitespacesAndNewlines)
        enterContainer(node, kind: "extension", name: name)
        return .visitChildren
    }

    override func visitPost(_ node: ExtensionDeclSyntax) {
        exitContainer()
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if deepScan {
            insideFunctionDepth += 1
            enterContainer(node, kind: "func", name: node.name.text)
            return .visitChildren
        } else {
            handleLeaf(node, kind: "func", name: node.name.text)
            return .skipChildren
        }
    }

    override func visitPost(_ node: FunctionDeclSyntax) {
        if deepScan {
            insideFunctionDepth -= 1
            exitContainer()
        }
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        // Skip variables inside functions when in deep scan mode
        if deepScan && insideFunctionDepth > 0 {
            return .skipChildren
        }

        let name = node.bindings.first?.pattern.description.trimmingCharacters(in: .whitespacesAndNewlines) ?? "(unknown)"
        handleLeaf(node, kind: "var", name: name)
        return .skipChildren
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        if deepScan {
            insideFunctionDepth += 1
            let name = "init" + node.signature.parameterClause.description.trimmingCharacters(in: .whitespacesAndNewlines)
            enterContainer(node, kind: "init", name: name)
            return .visitChildren
        } else {
            let name = "init" + node.signature.parameterClause.description.trimmingCharacters(in: .whitespacesAndNewlines)
            handleLeaf(node, kind: "init", name: name)
            return .skipChildren
        }
    }

    override func visitPost(_ node: InitializerDeclSyntax) {
        if deepScan {
            insideFunctionDepth -= 1
            exitContainer()
        }
    }

    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        if deepScan {
            insideFunctionDepth += 1
            enterContainer(node, kind: "deinit", name: "deinit")
            return .visitChildren
        } else {
            handleLeaf(node, kind: "deinit", name: "deinit")
            return .skipChildren
        }
    }

    override func visitPost(_ node: DeinitializerDeclSyntax) {
        if deepScan {
            insideFunctionDepth -= 1
            exitContainer()
        }
    }

    private func enterContainer<T: SyntaxProtocol>(_ node: T, kind: String, name: String) {
        let start = node.startLocation(converter: locationConverter).line
        let end = node.endLocation(converter: locationConverter).line
        let symbol = SymbolInfo(kind: kind, name: name, startLine: start, endLine: end)
        stack.append(symbol)
    }

    private func exitContainer() {
        guard let finished = stack.popLast() else { return }
        if var parent = stack.last {
            parent.members.append(finished)
            stack[stack.count - 1] = parent
        } else {
            topLevelSymbols.append(finished)
        }
    }

    private func handleLeaf<T: SyntaxProtocol>(_ node: T, kind: String, name: String) {
        let start = node.startLocation(converter: locationConverter).line
        let end = node.endLocation(converter: locationConverter).line
        let symbol = SymbolInfo(kind: kind, name: name, startLine: start, endLine: end)

        if var parent = stack.last {
            parent.members.append(symbol)
            stack[stack.count - 1] = parent
        } else {
            topLevelSymbols.append(symbol)
        }
    }
}

