//
//  test.swift
//  swift-ast-parser
//
//  Created by Austin Huang on 2025/11/15.
//

import Foundation

// MARK: - Protocol Definitions

protocol Vehicle {
    var numberOfWheels: Int { get }
    var maxSpeed: Double { get set }
    func drive()
    func stop()
}

protocol Electric {
    var batteryCapacity: Double { get }
    func charge(hours: Double) -> Double
}

// MARK: - Class Definitions

class Animal {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func makeSound() {
        print("Some generic animal sound")
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Dog: Animal {
    var breed: String
    
    init(name: String, age: Int, breed: String) {
        self.breed = breed
        super.init(name: name, age: age)
    }
    
    override func makeSound() {
        print("Woof!")
    }
    
    func fetch(item: String) {
        print("\(name) is fetching \(item)")
    }
}

// MARK: - Struct Definitions

struct Point {
    var x: Double
    var y: Double
    
    mutating func moveBy(dx: Double, dy: Double) {
        x += dx
        y += dy
    }
    
    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
}

struct Car: Vehicle {
    let numberOfWheels: Int = 4
    var maxSpeed: Double
    var brand: String
    var model: String
    
    func drive() {
        print("\(brand) \(model) is driving")
    }
    
    func stop() {
        print("\(brand) \(model) has stopped")
    }
}

struct ElectricCar: Vehicle, Electric {
    let numberOfWheels: Int = 4
    var maxSpeed: Double
    var brand: String
    var model: String
    let batteryCapacity: Double
    
    func drive() {
        print("\(brand) \(model) is driving silently")
    }
    
    func stop() {
        print("\(brand) \(model) has stopped")
    }
    
    func charge(hours: Double) -> Double {
        return min(batteryCapacity, hours * 50)
    }
}

// MARK: - Enum Definitions

enum Direction {
    case north
    case south
    case east
    case west
}

enum Result<T> {
    case success(T)
    case failure(Error)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}

enum NetworkError: Error {
    case timeout
    case serverError(code: Int)
    case invalidResponse
    case noConnection
}

// MARK: - Function Definitions

func calculateSum(_ numbers: [Int]) -> Int {
    return numbers.reduce(0, +)
}

func greet(person: String, greeting: String = "Hello") -> String {
    return "\(greeting), \(person)!"
}

func processData<T>(_ data: T, transform: (T) -> String) -> String {
    return transform(data)
}

func fibonacci(_ n: Int) -> Int {
    if n <= 1 {
        return n
    }
    return fibonacci(n - 1) + fibonacci(n - 2)
}

// Function with inout parameter
func swapValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

// Higher-order function
func applyOperation(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

// MARK: - Extension Definitions

extension String {
    var isPalindrome: Bool {
        let cleaned = self.lowercased().filter { $0.isLetter }
        return cleaned == String(cleaned.reversed())
    }
    
    func repeated(times: Int) -> String {
        return String(repeating: self, count: times)
    }
}

extension Array where Element == Int {
    func average() -> Double {
        guard !isEmpty else { return 0.0 }
        let sum = self.reduce(0, +)
        return Double(sum) / Double(count)
    }
}

extension Point {
    static let origin = Point(x: 0, y: 0)
    
    static func +(lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: - Generic Types

class Stack<Element> {
    private var items: [Element] = []
    
    func push(_ item: Element) {
        items.append(item)
    }
    
    func pop() -> Element? {
        return items.popLast()
    }
    
    func peek() -> Element? {
        return items.last
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    var count: Int {
        return items.count
    }
}

// MARK: - Nested Types

struct ChessBoard {
    let rows = 8
    let columns = 8
    
    struct Position {
        let row: Int
        let column: Int
        
        func isValid() -> Bool {
            return row >= 0 && row < 8 && column >= 0 && column < 8
        }
    }
    
    enum Piece {
        case pawn, knight, bishop, rook, queen, king
        
        func symbol() -> String {
            switch self {
            case .pawn: return "♙"
            case .knight: return "♘"
            case .bishop: return "♗"
            case .rook: return "♖"
            case .queen: return "♕"
            case .king: return "♔"
            }
        }
    }
}

// MARK: - Closure Examples

let numbers = [1, 2, 3, 4, 5]
let doubledNumbers = numbers.map { $0 * 2 }
let evenNumbers = numbers.filter { $0 % 2 == 0 }
let sum = numbers.reduce(0) { $0 + $1 }

// MARK: - Property Wrappers

@propertyWrapper
struct Clamped<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>
    
    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(range.lowerBound, wrappedValue), range.upperBound)
    }
}

struct GameCharacter {
    @Clamped(0...100) var health: Int = 100
    @Clamped(0...100) var mana: Int = 50
}

// MARK: - Actor (Concurrency)

actor BankAccount {
    private var balance: Double = 0.0
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func withdraw(_ amount: Double) -> Bool {
        if balance >= amount {
            balance -= amount
            return true
        }
        return false
    }
    
    func getBalance() -> Double {
        return balance
    }
}

// MARK: - Async/Await Functions

func fetchData(from url: URL) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

func processMultipleRequests() async {
    async let result1 = fetchData(from: URL(string: "https://example.com/1")!)
    async let result2 = fetchData(from: URL(string: "https://example.com/2")!)
    
    do {
        let _ = try await [result1, result2]
    } catch {
        print("Error fetching data: \(error)")
    }
}

// MARK: - Type Aliases

typealias Coordinate = (x: Double, y: Double)
typealias IntOperation = (Int, Int) -> Int
typealias StringDictionary = [String: String]

// MARK: - Global Variables and Constants

let globalConstant = 42
var globalVariable = "Swift"
private let privateConstant = 3.14159

// MARK: - Computed Properties

var computedValue: Int {
    return globalConstant * 2
}

// MARK: - Subscript

struct Matrix {
    let rows: Int
    let columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            return grid[row * columns + column]
        }
        set {
            grid[row * columns + column] = newValue
        }
    }
}

// MARK: - Operator Overloading

struct Vector2D {
    var x: Double
    var y: Double
    
    static func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        return Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        return Vector2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static prefix func -(vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

// MARK: - Main Execution

func demonstrateFeatures() {
    // Test classes
    let dog = Dog(name: "Buddy", age: 3, breed: "Golden Retriever")
    dog.makeSound()
    dog.fetch(item: "ball")
    
    // Test structs
    var point1 = Point(x: 3.0, y: 4.0)
    let point2 = Point(x: 6.0, y: 8.0)
    print("Distance: \(point1.distance(to: point2))")
    point1.moveBy(dx: 1.0, dy: 1.0)
    
    // Test enums
    let result: Result<Int> = .success(42)
    print("Success: \(result.isSuccess)")
    
    // Test functions
    print(greet(person: "World"))
    print("Sum: \(calculateSum([1, 2, 3, 4, 5]))")
    
    // Test extensions
    print("radar".isPalindrome)
    print([1, 2, 3, 4, 5].average())
    
    // Test generics
    let stack = Stack<String>()
    stack.push("First")
    stack.push("Second")
    print("Stack count: \(stack.count)")
    
    // Test closures
    let sortedNumbers = numbers.sorted { $0 > $1 }
    print("Sorted: \(sortedNumbers)")
}
