// Test file for function signature parsing
// This file contains various function signatures to test the AST parser

import Foundation

// MARK: - Basic Functions

func noParams() {
    print("Hello")
}

func singleParam(name: String) {
    print("Hello, \(name)")
}

func multipleParams(first: String, second: Int) -> String {
    return "\(first): \(second)"
}

// MARK: - Parameter Variations

func withDefaultValue(name: String = "World") -> String {
    return "Hello, \(name)"
}

func withInout(_ value: inout Int) {
    value += 1
}

func withVariadic(numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}

func withLabel(firstParam secondParam: String) -> String {
    return secondParam
}

func withUnderscore(_ value: String) -> String {
    return value.uppercased()
}

// MARK: - Generic Functions

func genericFunction<T>(value: T) -> T {
    return value
}

func genericWithConstraint<T: Equatable>(a: T, b: T) -> Bool {
    return a == b
}

func multipleGenerics<T, U>(first: T, second: U) -> (T, U) {
    return (first, second)
}

// MARK: - Complex Signatures

func complexFunction(
    name: String,
    age: Int,
    callback: (String) -> Void
) -> Bool {
    callback(name)
    return age > 18
}

func throwingFunction() throws -> String {
    return "success"
}

func asyncFunction() async -> String {
    return "async result"
}

func asyncThrowingFunction() async throws -> Int {
    return 42
}

// MARK: - Operator Functions

extension String {
    static func +(lhs: String, rhs: String) -> String {
        return lhs.appending(rhs)
    }
}

extension Int {
    static func *(lhs: Int, rhs: Int) -> Int {
        return lhs * rhs
    }
}

// MARK: - Nested Functions (for deep scan testing)

func outerFunction() {
    func innerFunction(param: String) -> Int {
        return param.count
    }

    let result = innerFunction(param: "test")
    print(result)
}

// MARK: - Protocol Methods

protocol TestProtocol {
    func requiredMethod(name: String) -> Bool
    func optionalMethod(value: Int) -> String
}

class TestClass: TestProtocol {
    func requiredMethod(name: String) -> Bool {
        return !name.isEmpty
    }

    func optionalMethod(value: Int) -> String {
        return String(value)
    }

    // Additional method
    func extraMethod(param1: String, param2 param2: Int) -> (String, Int) {
        return (param1, param2)
    }
}