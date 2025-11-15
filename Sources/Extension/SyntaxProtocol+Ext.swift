//
//  SyntaxProtocol+Ext.swift
//  swift-ast-parser
//
//  Created by Austin Huang on 2025/11/15.
//
import Foundation
import SwiftSyntax
import SwiftParser

extension SyntaxProtocol {
    /// Returns the start location of this syntax node, skipping any leading trivia (whitespace, comments).
    ///
    /// - Parameter converter: The source location converter to use for position calculation
    /// - Returns: The source location representing the start of the actual code
    func startLocation(converter: SourceLocationConverter) -> SourceLocation {
        converter.location(for: self.positionAfterSkippingLeadingTrivia)
    }
    
    /// Returns the end location of this syntax node, before any trailing trivia (whitespace, comments).
    ///
    /// - Parameter converter: The source location converter to use for position calculation
    /// - Returns: The source location representing the end of the actual code
    func endLocation(converter: SourceLocationConverter) -> SourceLocation {
        converter.location(for: self.endPositionBeforeTrailingTrivia)
    }
}

