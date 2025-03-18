# JSONSchema

A Swift library for working with JSON Schema definitions.

## Requirements

- Swift 6.0+ / Xcode 16+
- macOS 14.0+ (Sonoma)
- iOS 17.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/loopwork-ai/JSONSchema.git", from: "0.1.0")
]
```

## Usage

### Creating JSON Schemas with Dictionary Literals

Create JSON Schema definitions with Swift's expressive dictionary literal syntax:

```swift
import JSONSchema

// Simple object schema with properties
let personSchema: JSONSchema = [
    "name": .string(minLength: 2),
    "age": .integer(minimum: 0, maximum: 120),
    "email": .string(format: .email)
]

// Nested object schema
let addressSchema: JSONSchema = [
    "street": .string(),
    "city": .string(),
    "zip": .string(pattern: "^[0-9]{5}$")
]

// Complex schema with nested objects
let userSchema: JSONSchema = [
    "name": .string(minLength: 2, maxLength: 100),
    "email": .string(format: .email),
    "address": addressSchema,
    "tags": .array(items: .string()),
    "status": .oneOf([
        .string(enum: ["active", "inactive", "pending"]),
        .object(properties: ["code": .integer(), "message": .string()])
    ])
]
```

### Working with JSON Values

The library provides a `JSONValue` type that represents any valid JSON value:

```swift
import JSONSchema

// Create JSON values
let nullValue: JSONValue = .null
let boolValue: JSONValue = true
let numberValue: JSONValue = 42
let stringValue: JSONValue = "hello"
let arrayValue: JSONValue = [1, 2, 3]
let objectValue: JSONValue = ["key": "value"]

// Extract typed values
if let string = stringValue.stringValue {
    print(string) // "hello"
}

if let number = numberValue.intValue {
    print(number) // 42
}

// Use in schema definitions
let schema: JSONSchema = .object(
    default: ["name": "John Doe"],
    examples: [["name": "Jane Doe", "age": 25]],
    properties: [
        "name": .string(),
        "age": .integer()
    ]
)
```

### Schema Serialization

```swift
import JSONSchema

// Create a schema
let schema: JSONSchema = .object(
    title: "Person",
    description: "A person schema",
    properties: [
        "name": .string(minLength: 2),
        "age": .integer(minimum: 0)
    ],
    required: ["name"]
)

// Encode to JSON
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted]
let jsonData = try encoder.encode(schema)
print(String(data: jsonData, encoding: .utf8)!)

// Decode from JSON
let decoder = JSONDecoder()
let decodedSchema = try decoder.decode(JSONSchema.self, from: jsonData)
```

## License

This project is licensed under the Apache License, Version 2.0.
