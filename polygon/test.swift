// ============ 1. КОММЕНТАРИИ ============
// однострочный комментарий
/* блочный
   многострочный */
/// Doc-комментарий
/// - Parameter name: имя параметра

// ============ 2. ИМПОРТЫ ============
import Foundation
import SwiftUI

// ============ 3. КОНСТАНТЫ И ЛИТЕРАЛЫ ============
let maxSize: Int = 100
var intDec: Int = 42
let intNeg: Int = -17
let floatNum: Double = 3.14159
let expNum: Double = 6.022e23
let hexNum: Int = 0xFF00FF
let octNum: Int = 0o755
let binNum: Int = 0b1010_1010
let underscoreSep: Int = 1_000_000
let boolTrue: Bool = true
let boolFalse: Bool = false
let optionalVal: Int? = nil
let charVal: Character = "A"

// ============ 4. СТРОКИ ============
let single = "обычная строка"
let escaped = "с \"кавычками\" и \n переводом"
let interpolated = "Значение: \(intDec), hex: \(String(hexNum, radix: 16))"
let multiline = """
    многострочная
    строка
    """

// ============ 5. КОЛЛЕКЦИИ ============
let array: [Int] = [1, 2, 3, 4, 5]
let dict: [String: Int] = ["a": 1, "b": 2]
let set: Set<Int> = [1, 2, 3]
let tuple: (Int, String) = (1, "один")

// ============ 6. ENUM ============
enum Status: String {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}

enum Shape {
    case circle(radius: Double)
    case rectangle(width: Double, height: Double)
}

// ============ 7. STRUCT И CLASS ============
protocol Describable {
    func describe() -> String
}

struct Point: Describable, Equatable {
    var x: Double
    var y: Double

    func describe() -> String {
        return "(\(x), \(y))"
    }
}

class Animal: Describable {
    static var instanceCount = 0
    private var name: String
    var age: Int = 0

    init(name: String, age: Int = 0) {
        self.name = name
        self.age = age
        Animal.instanceCount += 1
    }

    func describe() -> String {
        return "\(name) (\(age))"
    }

    deinit {
        Animal.instanceCount -= 1
    }
}

final class Dog: Animal {
    let breed: String

    init(name: String, breed: String) {
        self.breed = breed
        super.init(name: name)
    }

    override func describe() -> String {
        return "\(super.describe()) - \(breed)"
    }
}

// ============ 8. ДЖЕНЕРИКИ ============
struct Container<T> {
    var items: [T] = []

    mutating func push(_ item: T) {
        items.append(item)
    }
}

func genericMax<T: Comparable>(_ items: [T]) -> T? {
    return items.max()
}

// ============ 9. ФУНКЦИИ И ЗАМЫКАНИЯ ============
func simpleFunction(a: Int, b: Int = 10) -> Int {
    return a + b
}

func withClosure(completion: @escaping (Int) -> Void) {
    completion(42)
}

let square: (Int) -> Int = { x in x * x }
let doubled = array.map { $0 * 2 }
let filtered = array.filter { $0 % 2 == 0 }

// ============ 10. УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ ============
if boolTrue {
    print("if")
} else if boolFalse {
    print("else if")
} else {
    print("else")
}

guard let value = optionalVal else {
    print("guard")
    fatalError("значение отсутствует")
}

for i in 0..<10 {
    if i == 5 { continue }
    if i == 8 { break }
}

for item in array {
    print(item)
}

var n = 0
while n < 3 { n += 1 }
repeat { n -= 1 } while n > 0

switch intDec {
case 42:
    print("matched")
case 0..<10:
    print("range")
default:
    print("default")
}

if case .circle(let radius) = Shape.circle(radius: 5.0) {
    print("радиус: \(radius)")
}

do {
    struct CustomError: Error {}
    throw CustomError()
} catch let error as CustomError {
    print("поймано: \(error)")
} catch {
    print("общая ошибка")
}

// ============ 11. ОПЕРАТОРЫ ============
let arithmetic = 1 + 2 - 3 * 4 / 5 % 6
let comparison = 1 < 2 && 3 > 2 || 4 <= 4
let nilCoalesce = optionalVal ?? 0
let optChain = optionalVal?.description
let range1 = 1...10
let range2 = 1..<10

// ============ 12. MAIN ============
let dog = Dog(name: "Бобик", breed: "лабрадор")
print(dog.describe())
