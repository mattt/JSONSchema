# JSONSchema

A Swift library for working with JSON Schema definitions —
_especially_ for declaring schemas for AI tool use.

This library implements core features of the 
[JSON Schema](https://json-schema.org/) standard, 
specifically targeting compatibility with **draft-2020-12** version.

🙅‍♀️ This library specifically **does not** support the following features:

- Document validation
- Reference resolution
- Conditional validation keywords, like 
  `dependentRequired`, `dependentSchemas`, and `if`/`then`/`else`
- Custom vocabularies and meta-schemas

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

// Example of defining a schema for an AI tool
let getWeatherSchema: JSONSchema = .object(
    properties: [
        "location": .string(
            description: "The city and state/country, e.g. 'San Francisco, CA'",
            examples: ["London, UK", "Tokyo, Japan"]
        ),
        "unit": .string(
            description: "The temperature unit to use",
            enum: ["celsius", "fahrenheit"],
            default: "celsius"
        ),
        "include_forecast": .boolean(
            description: "Whether to include the weather forecast",
            default: false
        )
    ],
    required: ["location"]
)

// Complex schema with nested objects
let addressSchema: JSONSchema = [
    "street": .string(),
    "city": .string(),
    "zip": .string(pattern: "^[0-9]{5}$")
]

let orderSchema: JSONSchema = [
    "name": .string(minLength: 2, maxLength: 100),
    "email": .string(format: .email),
    "address": addressSchema,
    "tags": .array(items: .string()),
    "status": .oneOf([
        .string(enum: ["active", "inactive", "pending"]),
        .object(
            properties: [
                "error": .boolean(const: true),
                "code": .integer(enum: [400, 401, 403, 404]),
                "message": .string(
                    description: "Detailed error message",
                    examples: ["Invalid credentials", "Not found"]
                )
            ],
            required: ["error"],
            additionalProperties: false
        )
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
        "name": .string(),
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

# JSONSchema

A Swift library for working with JSON Schema definitions —
_especially_ for declaring schemas for AI tool use.

## Motivation

There are a few other libraries out there for working with JSON Schema, 
but they did more than I needed.

This library focuses solely on defining and serializing JSON Schema structures 
with a clean, ergonomic API.
_That's it_.

The implementation is deliberately minimal: 
two files under 1,000 lines of code.
At its core is one big `JSONSchema` enumerations 
with associated values for most of the JSON Schema keywords you might want.
No result builders, property wrappers, macros, or dynamic member lookup —
just old-school Swift with choice conformance to `ExpressibleBy___Literal` 💅

## License

This project is licensed under the Apache License, Version 2.0.
