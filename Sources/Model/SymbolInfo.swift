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
    
    /// The detected type for variables (e.g., "UICollectionView", "UInt64", "Double")
    /// This is populated when show_type flag is enabled
    let type: String?
    
    init(kind: String, name: String, startLine: Int, endLine: Int, members: [SymbolInfo] = [], type: String? = nil) {
        self.kind = kind
        self.name = name
        self.startLine = startLine
        self.endLine = endLine
        self.members = members
        self.type = type
    }
}
