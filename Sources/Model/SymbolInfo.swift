//
//  SymbolInfo.swift
//  swift-ast-parser
//
//  Created by Austin Huang on 2025/11/15.
//
import Foundation
import SwiftSyntax
import SwiftParser

/// Represents a Swift symbol (class, struct, function, etc.) with its location and nested members.
///
/// This structure is used to capture the hierarchical organization of Swift code,
/// including the symbol type, name, line range, and any nested symbols.
struct SymbolInfo: Codable {
    /// The kind of symbol (e.g., "class", "struct", "func", "var", "protocol", "extension")
    let kind: String
    
    /// The name of the symbol as it appears in the source code
    let name: String
    
    /// The line number where the symbol declaration starts (1-indexed)
    let startLine: Int
    
    /// The line number where the symbol declaration ends (1-indexed)
    var endLine: Int
    
    /// Nested symbols contained within this symbol (e.g., methods in a class)
    var members: [SymbolInfo] = []
}
