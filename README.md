# JSONSchema

A Swift library for working with JSON Schema definitions —
especially for declaring schemas for AI tool use.

This library implements core features of the
[JSON Schema](https://json-schema.org/) standard,
targeting the **draft-2020-12** version.

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
    .package(url: "https://github.com/mattt/JSONSchema.git", from: "1.3.0")
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

### Schema Properties

Access schema metadata and type information through convenience properties:

```swift
import JSONSchema

let schema: JSONSchema = .object(
    title: "Person",
    description: "A human being",
    properties: [
        "name": .string,
        "age": .integer
    ]
)

// Access metadata
print(schema.typeName) // "object"
print(schema.title) // "Person"
print(schema.description) // "A human being"
```

### JSON Value Compatibility

The library provides methods to check compatibility between JSON values and schemas:

```swift
import JSONSchema

// Check if a JSON value is compatible with a schema
let value: JSONValue = 42
let schema: JSONSchema = .integer(minimum: 0)
let isCompatible = value.isCompatible(with: schema) // true

// Strict vs non-strict compatibility
let numberValue: JSONValue = 42
let numberSchema: JSONSchema = .number()
let strictCompatible = numberValue.isCompatible(with: numberSchema) // false
let nonStrictCompatible = numberValue.isCompatible(with: numberSchema, strict: false) // true
```

### Schema Serialization

```swift
import JSONSchema

// Create a schema
let schema: JSONSchema = .object(
    title: "Person",
    description: "A human being",
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

### Preserving Property Order

According to [the JSON spec](https://www.ecma-international.org/wp-content/uploads/ECMA-404_2nd_edition_december_2017.pdf) (emphasis added):

> ## 6. Objects
> [...] The JSON syntax does not impose any restrictions on the strings used as names,
> does not require that name strings be unique,
> and **does not assign any significance to the ordering of name/value pairs**. [...]

And yet,
JSON Schema documents often _do_ assign significance to the order of properties.
In such cases, it may be desireable to preserve this ordering.
For example,
ensuring that an auto-generated form for a `createEvent` tool
lists `start` before `end`.
For this reason,
the associated value for `JSONSchema.object` properties use
[the `OrderedDictionary` type from `apple/swift-collections`](https://github.com/apple/swift-collections)

By default,
`JSONDecoder` doesn't guarantee stable ordering of keys.
However, this package provides the following affordances
to decode `JSONSchema` objects with properties
in order they appear in the JSON string:

- A static `extractSchemaPropertyOrder` method
  that extracts property order from the top-level `"properties"` field
  of a JSON Schema object.
- A static `extractPropertyOrder` method
  that extracts property order from any JSON object at a specified keypath.
- A static `propertyOrderUserInfoKey` constant
  that you can pass to `JSONDecoder`
  (determined with either extraction method or some other means)
  to guide the ordering of JSON Schema object properties.

```swift
let json = """
{
  "type": "object",
  "properties": {
    "firstName": {"type": "string"},
    "lastName": {"type": "string"},
    "age": {"type": "integer"},
    "email": {"type": "string", "format": "email"}
  }
}
""".data(using: .utf8)!

// Extract property order from a JSON Schema object's "properties" field
if let propertyOrder = JSONSchema.extractSchemaPropertyOrder(from: jsonData) {
    // Configure decoder to preserve order
    let decoder = JSONDecoder()
    decoder.userInfo[JSONSchema.propertyOrderUserInfoKey] = propertyOrder

    // Decode with preserved property order
    let schema = try decoder.decode(JSONSchema.self, from: data)

    // Properties will maintain their original order: `firstName`, `lastName`, `age`, `email`
}

// Or extract from a nested object using a keypath
let nestedJSONData = """
{
  "definitions": {
    "person": {
      "firstName": "John",
      "lastName": "Doe"
    }
  }
}
""".data(using: .utf8)!

let keyOrder = JSONSchema.extractPropertyOrder(from: nestedJSONData,
                                               at: ["definitions", "person"])
// keyOrder will be ["firstName", "lastName"]
```

## Motivation

There are a few other packages out there for working with JSON Schema,
but they did more than I needed.

This library focuses solely on defining and serializing JSON Schema values
with a clean, ergonomic API. <br/>
_That's it_.

The [implementation](/Sources/JSONSchema/) is deliberately minimal.
At its core is one big `JSONSchema` enumeration
with associated values for most of the JSON Schema keywords you might want.
No result builders, property wrappers, macros, or dynamic member lookup —
just old-school Swift with choice conformance to `ExpressibleBy___Literal` 💅

## License

This project is available under the MIT license.
See the LICENSE file for more info.
