import Foundation
import Testing

@testable import JSONSchema

@Test func testJSONValueNull() throws {
    let nullValue: JSONValue = .null

    #expect(nullValue.isNull)
    #expect(nullValue.boolValue == nil)
    #expect(nullValue.intValue == nil)
    #expect(nullValue.doubleValue == nil)
    #expect(nullValue.stringValue == nil)
    #expect(nullValue.arrayValue == nil)
    #expect(nullValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(nullValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == nullValue)
    #expect(decodedValue.isNull)
}

@Test func testJSONValueBool() throws {
    let trueValue: JSONValue = .bool(true)
    let falseValue: JSONValue = .bool(false)

    #expect(trueValue.boolValue == true)
    #expect(falseValue.boolValue == false)

    #expect(!trueValue.isNull)
    #expect(trueValue.intValue == nil)
    #expect(trueValue.doubleValue == nil)
    #expect(trueValue.stringValue == nil)
    #expect(trueValue.arrayValue == nil)
    #expect(trueValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(trueValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == trueValue)
    #expect(decodedValue.boolValue == true)
}

@Test func testJSONValueInt() throws {
    let intValue: JSONValue = .int(42)

    #expect(intValue.intValue == 42)

    #expect(!intValue.isNull)
    #expect(intValue.boolValue == nil)
    #expect(intValue.doubleValue == Double(42))
    #expect(intValue.stringValue == nil)
    #expect(intValue.arrayValue == nil)
    #expect(intValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(intValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == intValue)
    #expect(decodedValue.intValue == 42)
}

@Test func testJSONValueDouble() throws {
    let doubleValue: JSONValue = .double(3.14)

    #expect(doubleValue.doubleValue == 3.14)

    #expect(!doubleValue.isNull)
    #expect(doubleValue.boolValue == nil)
    #expect(doubleValue.intValue == nil)
    #expect(doubleValue.stringValue == nil)
    #expect(doubleValue.arrayValue == nil)
    #expect(doubleValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(doubleValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == doubleValue)
    #expect(decodedValue.doubleValue == 3.14)
}

@Test func testJSONValueString() throws {
    let stringValue: JSONValue = .string("Hello, World!")

    #expect(stringValue.stringValue == "Hello, World!")

    #expect(!stringValue.isNull)
    #expect(stringValue.boolValue == nil)
    #expect(stringValue.intValue == nil)
    #expect(stringValue.doubleValue == nil)
    #expect(stringValue.arrayValue == nil)
    #expect(stringValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(stringValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == stringValue)
    #expect(decodedValue.stringValue == "Hello, World!")
}

@Test func testJSONValueArray() throws {
    let arrayValue: JSONValue = .array([
        .int(1),
        .string("test"),
        .bool(true),
        .null,
    ])

    #expect(arrayValue.arrayValue?.count == 4)
    #expect(arrayValue.arrayValue?[0].intValue == 1)
    #expect(arrayValue.arrayValue?[1].stringValue == "test")
    #expect(arrayValue.arrayValue?[2].boolValue == true)
    #expect(arrayValue.arrayValue?[3].isNull == true)

    #expect(!arrayValue.isNull)
    #expect(arrayValue.boolValue == nil)
    #expect(arrayValue.intValue == nil)
    #expect(arrayValue.doubleValue == nil)
    #expect(arrayValue.stringValue == nil)
    #expect(arrayValue.objectValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(arrayValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == arrayValue)
    #expect(decodedValue.arrayValue?.count == 4)
    #expect(decodedValue.arrayValue?[0].intValue == 1)
    #expect(decodedValue.arrayValue?[1].stringValue == "test")
    #expect(decodedValue.arrayValue?[2].boolValue == true)
    #expect(decodedValue.arrayValue?[3].isNull == true)
}

@Test func testJSONValueObject() throws {
    let objectValue: JSONValue = .object([
        "int": .int(1),
        "string": .string("test"),
        "bool": .bool(true),
        "null": .null,
        "array": .array([.int(1), .int(2)]),
        "object": .object(["key": .string("value")]),
    ])

    #expect(objectValue.objectValue?.count == 6)
    #expect(objectValue.objectValue?["int"]?.intValue == 1)
    #expect(objectValue.objectValue?["string"]?.stringValue == "test")
    #expect(objectValue.objectValue?["bool"]?.boolValue == true)
    #expect(objectValue.objectValue?["null"]?.isNull == true)
    #expect(objectValue.objectValue?["array"]?.arrayValue?.count == 2)
    #expect(objectValue.objectValue?["object"]?.objectValue?["key"]?.stringValue == "value")

    #expect(!objectValue.isNull)
    #expect(objectValue.boolValue == nil)
    #expect(objectValue.intValue == nil)
    #expect(objectValue.doubleValue == nil)
    #expect(objectValue.stringValue == nil)
    #expect(objectValue.arrayValue == nil)

    // Test encoding and decoding
    let encoder = JSONEncoder()
    let data = try encoder.encode(objectValue)

    let decoder = JSONDecoder()
    let decodedValue = try decoder.decode(JSONValue.self, from: data)

    #expect(decodedValue == objectValue)
    #expect(decodedValue.objectValue?.count == 6)
    #expect(decodedValue.objectValue?["int"]?.intValue == 1)
    #expect(decodedValue.objectValue?["string"]?.stringValue == "test")
    #expect(decodedValue.objectValue?["bool"]?.boolValue == true)
    #expect(decodedValue.objectValue?["null"]?.isNull == true)
    #expect(decodedValue.objectValue?["array"]?.arrayValue?.count == 2)
    #expect(decodedValue.objectValue?["object"]?.objectValue?["key"]?.stringValue == "value")
}

@Test func testJSONValueExpressibleByNilLiteral() {
    let value: JSONValue = nil

    #expect(value.isNull)
}

@Test func testJSONValueExpressibleByBooleanLiteral() {
    let trueValue: JSONValue = true
    let falseValue: JSONValue = false

    #expect(trueValue.boolValue == true)
    #expect(falseValue.boolValue == false)
}

@Test func testJSONValueExpressibleByIntegerLiteral() {
    let value: JSONValue = 42

    #expect(value.intValue == 42)
}

@Test func testJSONValueExpressibleByFloatLiteral() {
    let value: JSONValue = 3.14

    #expect(value.doubleValue == 3.14)
}

@Test func testJSONValueExpressibleByStringLiteral() {
    let value: JSONValue = "Hello, World!"

    #expect(value.stringValue == "Hello, World!")
}

@Test func testJSONValueExpressibleByArrayLiteral() {
    let value: JSONValue = [1, "test", true, nil]

    #expect(value.arrayValue?.count == 4)
    #expect(value.arrayValue?[0].intValue == 1)
    #expect(value.arrayValue?[1].stringValue == "test")
    #expect(value.arrayValue?[2].boolValue == true)
    #expect(value.arrayValue?[3].isNull == true)
}

@Test func testJSONValueExpressibleByDictionaryLiteral() {
    let value: JSONValue = [
        "int": 1,
        "string": "test",
        "bool": true,
        "null": nil,
        "array": [1, 2, 3],
    ]

    #expect(value.objectValue?.count == 5)
    #expect(value.objectValue?["int"]?.intValue == 1)
    #expect(value.objectValue?["string"]?.stringValue == "test")
    #expect(value.objectValue?["bool"]?.boolValue == true)
    #expect(value.objectValue?["null"]?.isNull == true)
    #expect(value.objectValue?["array"]?.arrayValue?.count == 3)
}

@Test func testJSONValueExpressibleByStringInterpolation() {
    let name = "World"
    let value: JSONValue = "Hello, \(name)!"

    #expect(value.stringValue == "Hello, World!")
}

@Test func testJSONValueCustomStringConvertible() {
    let nullValue: JSONValue = .null
    let boolValue: JSONValue = .bool(true)
    let intValue: JSONValue = .int(42)
    let doubleValue: JSONValue = .double(3.14)
    let stringValue: JSONValue = .string("Hello")
    let arrayValue: JSONValue = .array([.int(1), .int(2)])
    let objectValue: JSONValue = .object(["key": .string("value")])

    #expect(nullValue.description.isEmpty)
    #expect(boolValue.description == "true")
    #expect(intValue.description == "42")
    #expect(doubleValue.description == "3.14")
    #expect(stringValue.description == "Hello")
    #expect(arrayValue.description == "[1, 2]")
    #expect(objectValue.description == "[\"key\": value]")
}

@Test func testJSONValueCodableInitializer() throws {
    struct Person: Codable {
        let name: String
        let age: Int
    }

    let person = Person(name: "John", age: 30)
    let value = try JSONValue(person)

    if case let .object(object) = value {
        #expect(object.count == 2)
        #expect(object["name"]?.stringValue == "John")
        #expect(object["age"]?.intValue == 30)
    } else {
        Issue.record("Expected object value")
    }
}

@Test func testJSONValueEquals() {
    // Test null equality
    #expect(JSONValue.null == JSONValue.null)
    #expect(JSONValue.null != JSONValue.bool(false))

    // Test bool equality
    #expect(JSONValue.bool(true) == JSONValue.bool(true))
    #expect(JSONValue.bool(false) == JSONValue.bool(false))
    #expect(JSONValue.bool(true) != JSONValue.bool(false))
    #expect(JSONValue.bool(true) != JSONValue.int(1))

    // Test int equality
    #expect(JSONValue.int(42) == JSONValue.int(42))
    #expect(JSONValue.int(42) != JSONValue.int(43))
    #expect(JSONValue.int(42) != JSONValue.double(42.0))

    // Test double equality
    #expect(JSONValue.double(3.14) == JSONValue.double(3.14))
    #expect(JSONValue.double(3.14) != JSONValue.double(3.15))
    #expect(JSONValue.double(42.0) != JSONValue.int(42))

    // Test string equality
    #expect(JSONValue.string("hello") == JSONValue.string("hello"))
    #expect(JSONValue.string("hello") != JSONValue.string("world"))

    // Test array equality
    #expect(JSONValue.array([.int(1), .int(2)]) == JSONValue.array([.int(1), .int(2)]))
    #expect(JSONValue.array([.int(1), .int(2)]) != JSONValue.array([.int(2), .int(1)]))
    #expect(JSONValue.array([.int(1), .int(2)]) != JSONValue.array([.int(1)]))

    // Test object equality
    #expect(
        JSONValue.object(["a": .int(1), "b": .int(2)])
            == JSONValue.object(["a": .int(1), "b": .int(2)]))
    #expect(
        JSONValue.object(["a": .int(1), "b": .int(2)])
            == JSONValue.object(["b": .int(2), "a": .int(1)]))
    #expect(
        JSONValue.object(["a": .int(1), "b": .int(2)])
            != JSONValue.object(["a": .int(1), "c": .int(2)]))
    #expect(JSONValue.object(["a": .int(1), "b": .int(2)]) != JSONValue.object(["a": .int(1)]))

    // Test complex equality
    let complex1: JSONValue = .object([
        "name": .string("John"),
        "age": .int(30),
        "address": .object([
            "street": .string("123 Main St"),
            "city": .string("New York"),
        ]),
        "hobbies": .array([.string("reading"), .string("gaming")]),
    ])

    let complex2: JSONValue = .object([
        "name": .string("John"),
        "age": .int(30),
        "address": .object([
            "street": .string("123 Main St"),
            "city": .string("New York"),
        ]),
        "hobbies": .array([.string("reading"), .string("gaming")]),
    ])

    let complex3: JSONValue = .object([
        "name": .string("John"),
        "age": .int(30),
        "address": .object([
            "street": .string("123 Main St"),
            "city": .string("Boston"),  // Different city
        ]),
        "hobbies": .array([.string("reading"), .string("gaming")]),
    ])

    #expect(complex1 == complex2)
    #expect(complex1 != complex3)
}

@Test func testJSONValueHash() {
    let values: [JSONValue] = [
        .null,
        .bool(true),
        .bool(false),
        .int(42),
        .double(3.14),
        .string("hello"),
        .array([.int(1), .int(2)]),
        .object(["a": .int(1), "b": .int(2)]),
    ]

    // Create a set from the values
    let valueSet = Set(values)

    // Check that all values are in the set (hash is working correctly)
    for value in values {
        #expect(valueSet.contains(value))
    }

    // Check that equal values have the same hash
    #expect(JSONValue.null.hashValue == JSONValue.null.hashValue)
    #expect(JSONValue.bool(true).hashValue == JSONValue.bool(true).hashValue)
    #expect(JSONValue.int(42).hashValue == JSONValue.int(42).hashValue)
    #expect(JSONValue.double(3.14).hashValue == JSONValue.double(3.14).hashValue)
    #expect(JSONValue.string("hello").hashValue == JSONValue.string("hello").hashValue)
    #expect(
        JSONValue.array([.int(1), .int(2)]).hashValue
            == JSONValue.array([.int(1), .int(2)]).hashValue)
    #expect(
        JSONValue.object(["a": .int(1), "b": .int(2)]).hashValue
            == JSONValue.object(["a": .int(1), "b": .int(2)]).hashValue)

    // Verify Dictionary works with JSONValue as key (uses Hashable)
    var dict = [JSONValue: String]()
    dict[.string("key")] = "value"
    #expect(dict[.string("key")] == "value")
}

@Test func testJSONValueIsCompatible() {
    // Test object compatibility
    let objectValue: JSONValue = .object(["key": .string("value")])
    #expect(objectValue.isCompatible(with: .object))
    #expect(!objectValue.isCompatible(with: .array))
    #expect(!objectValue.isCompatible(with: .string))
    #expect(!objectValue.isCompatible(with: .number))
    #expect(!objectValue.isCompatible(with: .integer))
    #expect(!objectValue.isCompatible(with: .boolean))
    #expect(!objectValue.isCompatible(with: .null))

    // Test array compatibility
    let arrayValue: JSONValue = .array([.int(1), .string("test")])
    #expect(!arrayValue.isCompatible(with: .object))
    #expect(arrayValue.isCompatible(with: .array))
    #expect(!arrayValue.isCompatible(with: .string))
    #expect(!arrayValue.isCompatible(with: .number))
    #expect(!arrayValue.isCompatible(with: .integer))
    #expect(!arrayValue.isCompatible(with: .boolean))
    #expect(!arrayValue.isCompatible(with: .null))

    // Test string compatibility
    let stringValue: JSONValue = .string("test")
    #expect(!stringValue.isCompatible(with: .object))
    #expect(!stringValue.isCompatible(with: .array))
    #expect(stringValue.isCompatible(with: .string))
    #expect(!stringValue.isCompatible(with: .number))
    #expect(!stringValue.isCompatible(with: .integer))
    #expect(!stringValue.isCompatible(with: .boolean))
    #expect(!stringValue.isCompatible(with: .null))

    // Test number compatibility
    let doubleValue: JSONValue = .double(3.14)
    #expect(!doubleValue.isCompatible(with: .object))
    #expect(!doubleValue.isCompatible(with: .array))
    #expect(!doubleValue.isCompatible(with: .string))
    #expect(doubleValue.isCompatible(with: .number))
    #expect(!doubleValue.isCompatible(with: .integer))
    #expect(!doubleValue.isCompatible(with: .boolean))
    #expect(!doubleValue.isCompatible(with: .null))

    // Test integer compatibility
    let intValue: JSONValue = .int(42)
    #expect(!intValue.isCompatible(with: .object))
    #expect(!intValue.isCompatible(with: .array))
    #expect(!intValue.isCompatible(with: .string))
    #expect(intValue.isCompatible(with: .number, strict: false))
    #expect(!intValue.isCompatible(with: .number, strict: true))
    #expect(intValue.isCompatible(with: .integer))
    #expect(!intValue.isCompatible(with: .boolean))
    #expect(!intValue.isCompatible(with: .null))

    // Test boolean compatibility
    let boolValue: JSONValue = .bool(true)
    #expect(!boolValue.isCompatible(with: .object))
    #expect(!boolValue.isCompatible(with: .array))
    #expect(!boolValue.isCompatible(with: .string))
    #expect(!boolValue.isCompatible(with: .number))
    #expect(!boolValue.isCompatible(with: .integer))
    #expect(boolValue.isCompatible(with: .boolean))
    #expect(!boolValue.isCompatible(with: .null))

    // Test null compatibility
    let nullValue: JSONValue = .null
    #expect(!nullValue.isCompatible(with: .object))
    #expect(!nullValue.isCompatible(with: .array))
    #expect(!nullValue.isCompatible(with: .string))
    #expect(!nullValue.isCompatible(with: .number))
    #expect(!nullValue.isCompatible(with: .integer))
    #expect(!nullValue.isCompatible(with: .boolean))
    #expect(nullValue.isCompatible(with: .null))

    // Test composite schema types (should always return true)
    let anyValue: JSONValue = .string("any")
    #expect(anyValue.isCompatible(with: .reference("$ref")))
    #expect(anyValue.isCompatible(with: .anyOf([])))
    #expect(anyValue.isCompatible(with: .allOf([])))
    #expect(anyValue.isCompatible(with: .oneOf([])))
    #expect(anyValue.isCompatible(with: .not(.string)))
    #expect(anyValue.isCompatible(with: .empty))
    #expect(anyValue.isCompatible(with: .any))
}
