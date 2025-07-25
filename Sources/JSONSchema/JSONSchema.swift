import Foundation
import OrderedCollections

#if canImport(RegexBuilder)
    import RegexBuilder
#endif

/// A type that represents a JSON Schema definition.
///
/// Use JSONSchema to create, manipulate, and encode/decode JSON Schema documents.
/// This type supports all major schema types and validation keywords from the
/// JSON Schema specification.
///
/// ## Example
/// ```swift
/// let schema: JSONSchema = .object(
///     properties: [
///         "name": .string(),
///         "age": .integer(minimum: 0),
///         "email": .string(format: .email)
///     ],
///     required: ["name", "email"]
/// )
/// ```
@frozen public indirect enum JSONSchema: Hashable, Sendable {
    // Schema types

    /// A schema for JSON objects.
    ///
    /// Use this case to define the structure of objects, including properties,
    /// required fields, and rules for additional properties.
    ///
    /// - Parameters:
    ///   - title: A title describing the object.
    ///   - description: A description of the object's purpose.
    ///   - default: A default object value.
    ///   - examples: Example objects that are valid.
    ///   - enum: Allowed object values.
    ///   - const: A specific object this schema must equal.
    ///   - properties: Property names mapped to their schema definitions.
    ///   - required: Property names that are required.
    ///   - additionalProperties: Rules for properties not defined in `properties`.
    case object(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        properties: OrderedDictionary<String, JSONSchema> = [:],
        required: [String] = [],
        additionalProperties: AdditionalProperties? = nil
    )

    /// Creates an empty object schema with default settings.
    static var object: JSONSchema { .object() }

    /// A schema for JSON arrays.
    ///
    /// Use this case to define validation rules for arrays, including item schemas,
    /// length constraints, and uniqueness requirements.
    ///
    /// - Parameters:
    ///   - title: A title describing the array.
    ///   - description: A description of the array's purpose.
    ///   - default: A default array value.
    ///   - examples: Example arrays that are valid.
    ///   - enum: Allowed array values.
    ///   - const: A specific array this schema must equal.
    ///   - items: The schema all array items must validate against.
    ///   - minItems: The minimum number of items required.
    ///   - maxItems: The maximum number of items allowed.
    ///   - uniqueItems: Whether items must be unique.
    case array(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        items: JSONSchema? = nil,
        minItems: Int? = nil,
        maxItems: Int? = nil,
        uniqueItems: Bool? = nil
    )

    /// Creates an empty array schema with default settings.
    static var array: JSONSchema { .array() }

    /// A schema for JSON strings.
    ///
    /// Use this case to define validation rules for strings, including length
    /// constraints, patterns, and format validation.
    ///
    /// - Parameters:
    ///   - title: A title describing the string.
    ///   - description: A description of the string's purpose.
    ///   - default: A default string value.
    ///   - examples: Example strings that are valid.
    ///   - enum: Allowed string values.
    ///   - const: A specific string this schema must equal.
    ///   - minLength: The minimum string length.
    ///   - maxLength: The maximum string length.
    ///   - pattern: A regex pattern the string must match.
    ///   - format: A predefined format the string must conform to.
    case string(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        minLength: Int? = nil,
        maxLength: Int? = nil,
        pattern: String? = nil,
        format: StringFormat? = nil
    )

    /// Creates an empty string schema with default settings.
    static var string: JSONSchema { .string() }

    /// A schema for JSON numbers with decimal points.
    ///
    /// Use this case to define validation rules for floating-point numbers,
    /// including range constraints and multiple-of validation.
    ///
    /// - Parameters:
    ///   - title: A title describing the number.
    ///   - description: A description of the number's purpose.
    ///   - default: A default number value.
    ///   - examples: Example numbers that are valid.
    ///   - enum: Allowed number values.
    ///   - const: A specific number this schema must equal.
    ///   - minimum: The minimum value (inclusive).
    ///   - maximum: The maximum value (inclusive).
    ///   - exclusiveMinimum: The minimum value (exclusive).
    ///   - exclusiveMaximum: The maximum value (exclusive).
    ///   - multipleOf: A value that the number must be a multiple of.
    case number(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        minimum: Double? = nil,
        maximum: Double? = nil,
        exclusiveMinimum: Double? = nil,
        exclusiveMaximum: Double? = nil,
        multipleOf: Double? = nil
    )

    /// Creates an empty number schema with default settings.
    static var number: JSONSchema { .number() }

    /// A schema for JSON integers.
    ///
    /// Use this case to define validation rules for integers,
    /// including range constraints and multiple-of validation.
    ///
    /// - Parameters:
    ///   - title: A title describing the integer.
    ///   - description: A description of the integer's purpose.
    ///   - default: A default integer value.
    ///   - examples: Example integers that are valid.
    ///   - enum: Allowed integer values.
    ///   - const: A specific integer this schema must equal.
    ///   - minimum: The minimum value (inclusive).
    ///   - maximum: The maximum value (inclusive).
    ///   - exclusiveMinimum: The minimum value (exclusive).
    ///   - exclusiveMaximum: The maximum value (exclusive).
    ///   - multipleOf: A value that the integer must be a multiple of.
    case integer(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        minimum: Int? = nil,
        maximum: Int? = nil,
        exclusiveMinimum: Int? = nil,
        exclusiveMaximum: Int? = nil,
        multipleOf: Int? = nil
    )

    /// Creates an empty integer schema with default settings.
    static var integer: JSONSchema { .integer() }

    /// A schema for JSON boolean values.
    ///
    /// Use this case to define a schema that validates boolean true/false values.
    ///
    /// - Parameters:
    ///   - title: A title describing the boolean.
    ///   - description: A description of the boolean's purpose.
    ///   - default: A default boolean value.
    case boolean(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil
    )

    /// Creates an empty boolean schema with default settings.
    static var boolean: JSONSchema { .boolean() }

    /// A schema that validates only the JSON null value.
    case null

    // Special schema types

    /// A reference to another schema definition.
    ///
    /// Use this case to reference a schema defined elsewhere, typically using
    /// a JSON Pointer like "#/definitions/address".
    case reference(String)

    /// A schema requiring validation against any of the provided schemas.
    ///
    /// This represents a logical OR operation. The JSON value must validate
    /// against at least one of the schemas.
    case anyOf([JSONSchema])

    /// A schema requiring validation against all of the provided schemas.
    ///
    /// This represents a logical AND operation. The JSON value must validate
    /// against all of the schemas.
    case allOf([JSONSchema])

    /// A schema requiring validation against exactly one of the provided schemas.
    ///
    /// This represents a logical XOR operation. The JSON value must validate
    /// against exactly one of the schemas.
    case oneOf([JSONSchema])

    /// A schema requiring validation to fail against the provided schema.
    ///
    /// This represents a logical NOT operation. The JSON value must not
    /// validate against the schema.
    case not(JSONSchema)

    // Simple schemas

    /// An empty schema that imposes no constraints.
    ///
    /// This is equivalent to an empty JSON object `{}` and validates any instance.
    case empty

    /// A schema that accepts any valid JSON value.
    ///
    /// This is equivalent to the boolean value `true` in JSON Schema.
    case any
}

extension JSONSchema {
    /// The user info key for specifying property order during JSON decoding.
    ///
    /// When decoding JSON Schema objects, the standard `JSONDecoder` does not preserve
    /// the order of properties from the original JSON. To maintain property order, you
    /// can provide an array of property names in the decoder's `userInfo` dictionary
    /// using this key.
    ///
    /// ## Example
    /// ```swift
    /// let decoder = JSONDecoder()
    /// decoder.userInfo[JSONSchema.propertyOrderUserInfoKey] = ["name", "age", "email"]
    /// let schema = try decoder.decode(JSONSchema.self, from: jsonData)
    /// ```
    public static let propertyOrderUserInfoKey = CodingUserInfoKey(
        rawValue: "JSONSchemaPropertyOrder")!

    /// Extracts the order of property keys from a JSON Schema object's "properties" field.
    ///
    /// This method is specifically designed for JSON Schema objects and automatically
    /// extracts property keys from the "properties" field in the order they appear.
    ///
    /// - Parameter jsonData: The JSON Schema data to extract property order from.
    /// - Returns: An array of property keys in the order they appear in the JSON Schema's properties field, or nil if extraction fails.
    ///
    /// ## Example
    /// ```swift
    /// let jsonString = """
    /// {
    ///   "type": "object",
    ///   "properties": {
    ///     "name": {"type": "string"},
    ///     "age": {"type": "integer"},
    ///     "email": {"type": "string"}
    ///   }
    /// }
    /// """
    ///
    /// if let data = jsonString.data(using: .utf8),
    ///    let keyOrder = JSONSchema.extractSchemaPropertyOrder(from: data) {
    ///     let decoder = JSONDecoder()
    ///     decoder.userInfo[JSONSchema.propertyOrderUserInfoKey] = keyOrder
    ///     let schema = try decoder.decode(JSONSchema.self, from: data)
    /// }
    /// ```
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    public static func extractSchemaPropertyOrder(from jsonData: Data) -> [String]? {
        return extractPropertyOrder(from: jsonData, at: ["properties"])
    }

    /// Extracts the order of property keys from a JSON object at a specified keypath.
    ///
    /// This general-purpose method can extract property key order from any JSON object
    /// by navigating through the provided keypath.
    ///
    /// - Parameters:
    ///   - jsonData: The JSON data to extract keys from.
    ///   - keypath: An array of string keys representing the path to the target object.
    ///              An empty array extracts keys from the root object.
    /// - Returns: An array of property keys in the order they appear in the JSON, or nil if extraction fails.
    ///
    /// ## Example
    /// ```swift
    /// let jsonString = """
    /// {
    ///   "definitions": {
    ///     "person": {
    ///       "name": "John",
    ///       "age": 30,
    ///       "email": "john@example.com"
    ///     }
    ///   }
    /// }
    /// """
    ///
    /// if let data = jsonString.data(using: .utf8),
    ///    let keyOrder = JSONSchema.extractPropertyOrder(from: data, at: ["definitions", "person"]) {
    ///     // keyOrder will be ["name", "age", "email"]
    /// }
    /// ```
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    public static func extractPropertyOrder(from jsonData: Data, at keypath: [String] = [])
        -> [String]?
    {
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return nil }

        // First validate it's valid JSON by trying to decode
        do {
            let decoded = try JSONDecoder().decode(JSONValue.self, from: jsonData)

            // Verify root is an object
            guard case .object = decoded else { return nil }

            // Use the parser to extract keys
            let parser = JSONKeyOrderParser(json: jsonString)

            if keypath.isEmpty {
                return parser.extractRootKeys()
            } else {
                return parser.extractKeys(at: keypath)
            }
        } catch {
            return nil
        }
    }

    /// The title of the schema, if present.
    public var title: String? {
        switch self {
        case .object(let title, _, _, _, _, _, _, _, _),
            .array(let title, _, _, _, _, _, _, _, _, _),
            .string(let title, _, _, _, _, _, _, _, _, _),
            .number(let title, _, _, _, _, _, _, _, _, _, _),
            .integer(let title, _, _, _, _, _, _, _, _, _, _),
            .boolean(let title, _, _):
            return title
        case .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The description of the schema, if present.
    public var description: String? {
        switch self {
        case .object(_, let description, _, _, _, _, _, _, _),
            .array(_, let description, _, _, _, _, _, _, _, _),
            .string(_, let description, _, _, _, _, _, _, _, _),
            .number(_, let description, _, _, _, _, _, _, _, _, _),
            .integer(_, let description, _, _, _, _, _, _, _, _, _),
            .boolean(_, let description, _):
            return description
        case .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The default value of the schema, if present.
    public var `default`: JSONValue? {
        switch self {
        case .object(_, _, let `default`, _, _, _, _, _, _),
            .array(_, _, let `default`, _, _, _, _, _, _, _),
            .string(_, _, let `default`, _, _, _, _, _, _, _),
            .number(_, _, let `default`, _, _, _, _, _, _, _, _),
            .integer(_, _, let `default`, _, _, _, _, _, _, _, _),
            .boolean(_, _, let `default`):
            return `default`
        case .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The examples of the schema, if present.
    public var examples: [JSONValue]? {
        switch self {
        case .object(_, _, _, let examples, _, _, _, _, _),
            .array(_, _, _, let examples, _, _, _, _, _, _),
            .string(_, _, _, let examples, _, _, _, _, _, _),
            .number(_, _, _, let examples, _, _, _, _, _, _, _),
            .integer(_, _, _, let examples, _, _, _, _, _, _, _):
            return examples
        case .boolean, .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The enum values of the schema, if present.
    public var `enum`: [JSONValue]? {
        switch self {
        case .object(_, _, _, _, let `enum`, _, _, _, _),
            .array(_, _, _, _, let `enum`, _, _, _, _, _),
            .string(_, _, _, _, let `enum`, _, _, _, _, _),
            .number(_, _, _, _, let `enum`, _, _, _, _, _, _),
            .integer(_, _, _, _, let `enum`, _, _, _, _, _, _):
            return `enum`
        case .boolean, .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The const value of the schema, if present.
    public var const: JSONValue? {
        switch self {
        case .object(_, _, _, _, _, let const, _, _, _),
            .array(_, _, _, _, _, let const, _, _, _, _),
            .string(_, _, _, _, _, let const, _, _, _, _),
            .number(_, _, _, _, _, let const, _, _, _, _, _),
            .integer(_, _, _, _, _, let const, _, _, _, _, _):
            return const
        case .boolean, .null, .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }

    /// The name of the schema type.
    public var typeName: String {
        switch self {
        case .object: return "object"
        case .array: return "array"
        case .string: return "string"
        case .number: return "number"
        case .integer: return "integer"
        case .boolean: return "boolean"
        case .null: return "null"
        case .reference: return "reference"
        case .anyOf: return "anyOf"
        case .allOf: return "allOf"
        case .oneOf: return "oneOf"
        case .not: return "not"
        case .empty: return "empty"
        case .any: return "any"
        @unknown default:
            return "unknown"
        }
    }

    /// The default value that the schema infers from its type.
    ///
    /// - For objects, this property returns an empty object (`{}`).
    /// - For arrays, this property returns an empty array (`[]`).
    /// - For strings, this property returns an empty string (`""`).
    /// - For numbers, this property returns `0.0`.
    /// - For integers, this property returns `0`.
    /// - For booleans, this property returns `false`.
    /// - For null values, this property returns `null`.
    /// - For references and composite schemas (anyOf, allOf, oneOf, not, empty, or any), this property returns `nil`.
    public var typeDefault: JSONValue? {
        switch self {
        case .object: return .object([:])
        case .array: return .array([])
        case .string: return .string("")
        case .number: return .double(0.0)
        case .integer: return .int(0)
        case .boolean: return .bool(false)
        case .null: return .null
        case .reference, .anyOf, .allOf, .oneOf, .not, .empty, .any:
            return nil
        @unknown default:
            return nil
        }
    }
}

extension JSONSchema: Codable {
    private enum CodingKeys: String, CodingKey {
        // Any
        case type, `enum`, const

        // Metadata
        case title, description
        case `default`
        case deprecated
        case readOnly, writeOnly
        case examples

        // Object
        case properties, additionalProperties, required, items, minItems, maxItems, uniqueItems
        // String
        case minLength, maxLength, pattern, format
        // Number
        case minimum, maximum, exclusiveMinimum, exclusiveMaximum, multipleOf
        // Reference
        case ref = "$ref"
        // Special
        case anyOf, allOf, oneOf, not
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .any:
            var container = encoder.singleValueContainer()
            try container.encode(true)

        case .not(.any):
            var container = encoder.singleValueContainer()
            try container.encode(false)

        case .empty:
            _ = encoder.container(keyedBy: CodingKeys.self)

        case let .object(
            title,
            description,
            `default`,
            examples,
            `enum`,
            const,
            /*  */
            properties,
            required,
            additionalProperties
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("object", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)
            try encodeIfPresent(examples, forKey: .examples, into: &container)
            try encodeIfPresent(`enum`, forKey: .enum, into: &container)
            try encodeIfPresent(const, forKey: .const, into: &container)

            // Custom encoding for properties to preserve order but encode as object
            if !properties.isEmpty {
                try container.encode(PropertyDictionary(properties), forKey: .properties)
            }
            try encodeIfNotEmpty(required, forKey: .required, into: &container)

            if let additionalProperties = additionalProperties {
                try container.encode(additionalProperties, forKey: .additionalProperties)
            }

        case let .array(
            title,
            description,
            `default`,
            examples,
            `enum`,
            const,
            /*  */
            items,
            minItems,
            maxItems,
            uniqueItems
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("array", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)
            try encodeIfPresent(examples, forKey: .examples, into: &container)
            try encodeIfPresent(`enum`, forKey: .enum, into: &container)
            try encodeIfPresent(const, forKey: .const, into: &container)

            try encodeIfNotEmpty(items, forKey: .items, into: &container)
            try encodeIfPresent(minItems, forKey: .minItems, into: &container)
            try encodeIfPresent(maxItems, forKey: .maxItems, into: &container)
            try encodeIfPresent(uniqueItems, forKey: .uniqueItems, into: &container)

        case let .string(
            title,
            description,
            `default`,
            examples,
            `enum`,
            const,
            /*  */
            minLength,
            maxLength,
            pattern,
            format
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("string", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)
            try encodeIfPresent(examples, forKey: .examples, into: &container)
            try encodeIfPresent(`enum`, forKey: .enum, into: &container)
            try encodeIfPresent(const, forKey: .const, into: &container)

            try encodeIfPresent(minLength, forKey: .minLength, into: &container)
            try encodeIfPresent(maxLength, forKey: .maxLength, into: &container)
            try encodeIfPresent(pattern, forKey: .pattern, into: &container)
            try encodeIfPresent(format, forKey: .format, into: &container)

        case let .number(
            title,
            description,
            `default`,
            examples,
            `enum`,
            const,
            /*  */
            minimum,
            maximum,
            exclusiveMinimum,
            exclusiveMaximum,
            multipleOf
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("number", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)
            try encodeIfPresent(examples, forKey: .examples, into: &container)
            try encodeIfPresent(`enum`, forKey: .enum, into: &container)
            try encodeIfPresent(const, forKey: .const, into: &container)

            try encodeIfPresent(minimum, forKey: .minimum, into: &container)
            try encodeIfPresent(maximum, forKey: .maximum, into: &container)
            try encodeIfPresent(exclusiveMinimum, forKey: .exclusiveMinimum, into: &container)
            try encodeIfPresent(exclusiveMaximum, forKey: .exclusiveMaximum, into: &container)
            try encodeIfPresent(multipleOf, forKey: .multipleOf, into: &container)

        case let .integer(
            title,
            description,
            `default`,
            examples,
            `enum`,
            const,
            /*  */
            minimum,
            maximum,
            exclusiveMinimum,
            exclusiveMaximum,
            multipleOf
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("integer", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)
            try encodeIfPresent(examples, forKey: .examples, into: &container)
            try encodeIfPresent(`enum`, forKey: .enum, into: &container)
            try encodeIfPresent(const, forKey: .const, into: &container)

            try encodeIfPresent(minimum, forKey: .minimum, into: &container)
            try encodeIfPresent(maximum, forKey: .maximum, into: &container)
            try encodeIfPresent(exclusiveMinimum, forKey: .exclusiveMinimum, into: &container)
            try encodeIfPresent(exclusiveMaximum, forKey: .exclusiveMaximum, into: &container)
            try encodeIfPresent(multipleOf, forKey: .multipleOf, into: &container)

        case let .boolean(
            title,
            description,
            `default`
        ):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("boolean", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)

        case .null:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("null", forKey: .type)

        case .reference(let ref):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ref, forKey: .ref)

        case .anyOf(let schemas):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(schemas, forKey: .anyOf)

        case .allOf(let schemas):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(schemas, forKey: .allOf)

        case .oneOf(let schemas):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(schemas, forKey: .oneOf)

        case .not(let schema):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(schema, forKey: .not)
        }
    }

    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        if let bool = try? singleValueContainer.decode(Bool.self) {
            self = bool ? .any : .not(.any)
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.ref) {
            self = .reference(try container.decode(String.self, forKey: .ref))
            return
        }

        if container.contains(.anyOf) {
            self = .anyOf(try container.decode([JSONSchema].self, forKey: .anyOf))
            return
        }

        if container.contains(.allOf) {
            self = .allOf(try container.decode([JSONSchema].self, forKey: .allOf))
            return
        }

        if container.contains(.oneOf) {
            self = .oneOf(try container.decode([JSONSchema].self, forKey: .oneOf))
            return
        }

        if container.contains(.not) {
            self = .not(try container.decode(JSONSchema.self, forKey: .not))
            return
        }

        // If there's no type field, it's either empty or any schema
        if !container.contains(.type) {
            // Check if it's a completely empty container (no keys)
            if container.allKeys.isEmpty {
                self = .empty
            } else {
                // If it has other keys but no type, it's an "any" schema
                self = .any
            }
            return
        }

        let type = try container.decode(String.self, forKey: .type)

        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let description = try container.decodeIfPresent(String.self, forKey: .description)
        let `default` = try container.decodeIfPresent(JSONValue.self, forKey: .default)
        let examples = try container.decodeIfPresent([JSONValue].self, forKey: .examples)
        let `enum` = try container.decodeIfPresent([JSONValue].self, forKey: .enum)
        let const = try container.decodeIfPresent(JSONValue.self, forKey: .const)

        switch type {
        case "object":
            let propertiesWrapper = try container.decodeIfPresent(
                PropertyDictionary.self, forKey: .properties)
            let properties = propertiesWrapper?.orderedDictionary ?? [:]
            let required = try container.decodeIfPresent([String].self, forKey: .required) ?? []
            let additionalProperties = try container.decodeIfPresent(
                AdditionalProperties.self, forKey: .additionalProperties)

            self = .object(
                title: title,
                description: description,
                default: `default`,
                examples: examples,
                enum: `enum`,
                const: const,
                /*  */
                properties: properties,
                required: required,
                additionalProperties: additionalProperties)

        case "array":
            let items = try container.decodeIfPresent(JSONSchema.self, forKey: .items)
            let minItems = try container.decodeIfPresent(Int.self, forKey: .minItems)
            let maxItems = try container.decodeIfPresent(Int.self, forKey: .maxItems)
            let uniqueItems = try container.decodeIfPresent(Bool.self, forKey: .uniqueItems)
            let `enum` = try container.decodeIfPresent([JSONValue].self, forKey: .enum)
            let const = try container.decodeIfPresent(JSONValue.self, forKey: .const)

            self = .array(
                title: title,
                description: description,
                default: `default`,
                examples: examples,
                enum: `enum`,
                const: const,
                /*  */
                items: items,
                minItems: minItems,
                maxItems: maxItems,
                uniqueItems: uniqueItems
            )

        case "string":
            let minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
            let maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
            let pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            let format = try container.decodeIfPresent(StringFormat.self, forKey: .format)
            let `enum` = try container.decodeIfPresent([JSONValue].self, forKey: .enum)
            let const = try container.decodeIfPresent(JSONValue.self, forKey: .const)

            self = .string(
                title: title,
                description: description,
                default: `default`,
                examples: examples,
                enum: `enum`,
                const: const,
                /*  */
                minLength: minLength,
                maxLength: maxLength,
                pattern: pattern,
                format: format
            )

        case "number":
            let minimum = try container.decodeIfPresent(Double.self, forKey: .minimum)
            let maximum = try container.decodeIfPresent(Double.self, forKey: .maximum)
            let exclusiveMinimum = try container.decodeIfPresent(
                Double.self, forKey: .exclusiveMinimum)
            let exclusiveMaximum = try container.decodeIfPresent(
                Double.self, forKey: .exclusiveMaximum)
            let multipleOf = try container.decodeIfPresent(Double.self, forKey: .multipleOf)
            let `enum` = try container.decodeIfPresent([JSONValue].self, forKey: .enum)
            let const = try container.decodeIfPresent(JSONValue.self, forKey: .const)

            self = .number(
                title: title,
                description: description,
                default: `default`,
                examples: examples,
                enum: `enum`,
                const: const,
                /*  */
                minimum: minimum,
                maximum: maximum,
                exclusiveMinimum: exclusiveMinimum,
                exclusiveMaximum: exclusiveMaximum,
                multipleOf: multipleOf
            )

        case "integer":
            let minimum = try container.decodeIfPresent(Int.self, forKey: .minimum)
            let maximum = try container.decodeIfPresent(Int.self, forKey: .maximum)
            let exclusiveMinimum = try container.decodeIfPresent(
                Int.self, forKey: .exclusiveMinimum)
            let exclusiveMaximum = try container.decodeIfPresent(
                Int.self, forKey: .exclusiveMaximum)
            let multipleOf = try container.decodeIfPresent(Int.self, forKey: .multipleOf)
            let `enum` = try container.decodeIfPresent([JSONValue].self, forKey: .enum)
            let const = try container.decodeIfPresent(JSONValue.self, forKey: .const)

            self = .integer(
                title: title,
                description: description,
                default: `default`,
                examples: examples,
                enum: `enum`,
                const: const,
                /*  */
                minimum: minimum,
                maximum: maximum,
                exclusiveMinimum: exclusiveMinimum,
                exclusiveMaximum: exclusiveMaximum,
                multipleOf: multipleOf
            )

        case "boolean":
            self = .boolean(
                title: title,
                description: description,
                default: `default`)

        case "null":
            self = .null

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown schema type: \(type)"
            )
        }
    }

    private func encodeIfNotEmpty<T: Encodable>(
        _ value: T, forKey key: CodingKeys, into container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        // For collections, check if they're empty before encoding
        if let collection = value as? any Collection, !collection.isEmpty {
            try container.encode(value, forKey: key)
        } else if !(value is any Collection) {
            try container.encode(value, forKey: key)
        }
    }

    private func encodeIfPresent<T: Encodable>(
        _ value: T?, forKey key: CodingKeys,
        into container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        if let value = value {
            try container.encode(value, forKey: key)
        }
    }
}

// MARK: ExpressibleByDictionaryLiteral

extension JSONSchema: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONSchema)...) {
        self = .object(properties: .init(uniqueKeysWithValues: elements))
    }
}

// MARK: ExpressibleByBooleanLiteral

extension JSONSchema: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        if value {
            self = .any  // true schema accepts anything
        } else {
            self = .not(.any)  // false schema accepts nothing
        }
    }
}

// MARK: ExpressibleByNilLiteral

extension JSONSchema: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .empty
    }
}

// MARK: - Property Dictionary Wrapper

/// A wrapper around OrderedDictionary that encodes as a JSON object while preserving key order.
private struct PropertyDictionary: Codable {
    let orderedDictionary: OrderedDictionary<String, JSONSchema>

    init(_ orderedDictionary: OrderedDictionary<String, JSONSchema>) {
        self.orderedDictionary = orderedDictionary
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        for (key, value) in orderedDictionary {
            try container.encode(value, forKey: DynamicKey(stringValue: key)!)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        var result = OrderedDictionary<String, JSONSchema>()

        // Check if property order was provided in userInfo
        if let keyOrder = decoder.userInfo[JSONSchema.propertyOrderUserInfoKey] as? [String] {
            // Use the provided order
            for key in keyOrder {
                guard let codingKey = DynamicKey(stringValue: key) else { continue }
                if container.contains(codingKey) {
                    let value = try container.decode(JSONSchema.self, forKey: codingKey)
                    result[key] = value
                }
            }
            // Add any keys that weren't in the provided order
            for key in container.allKeys where !keyOrder.contains(key.stringValue) {
                let value = try container.decode(JSONSchema.self, forKey: key)
                result[key.stringValue] = value
            }
        } else {
            // Fallback to default behavior - order not preserved
            for key in container.allKeys {
                let value = try container.decode(JSONSchema.self, forKey: key)
                result[key.stringValue] = value
            }
        }

        self.orderedDictionary = result
    }

    private struct DynamicKey: CodingKey {
        let stringValue: String
        let intValue: Int? = nil

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }
}

// MARK: -

/// Standard format options for string values in JSON Schema.
///
/// This enumeration includes all standard string formats defined in the JSON Schema
/// specification, such as date-time, email, URI, and UUID. Use the `custom` case to
/// define your own formats.
///
/// Use these formats with the `format` parameter in a string schema to validate
/// string values according to specific patterns.
public enum StringFormat: Hashable, Sendable {
    /// String must be a valid RFC 3339 date-time.
    case dateTime

    /// String must be a valid RFC 3339 full-date.
    case date

    /// String must be a valid RFC 3339 time.
    case time

    /// String must be a valid RFC 3339 duration.
    case duration

    /// String must be a valid email address.
    case email

    /// String must be a valid internationalized email address.
    case idnEmail

    /// String must be a valid hostname per RFC 1034.
    case hostname

    /// String must be a valid internationalized hostname.
    case idnHostname

    /// String must be a valid IPv4 address.
    case ipv4

    /// String must be a valid IPv6 address.
    case ipv6

    /// String must be a valid URI per RFC 3986.
    case uri

    /// String must be a valid URI reference per RFC 3986.
    case uriReference

    /// String must be a valid IRI reference.
    case iriReference

    /// String must be a valid URI template per RFC 6570.
    case uriTemplate

    /// String must be a valid JSON Pointer per RFC 6901.
    case jsonPointer

    /// String must be a valid relative JSON Pointer.
    case relativeJsonPointer

    /// String must be a valid regular expression.
    case regex

    /// String must be a valid UUID per RFC 4122.
    case uuid

    /// String must conform to a custom format.
    ///
    /// - Parameter format: The name of the custom format.
    case custom(String)
}

// MARK: RawRepresentable

extension StringFormat: RawRepresentable {
    public init(rawValue: String) {
        switch rawValue {
        case "date-time": self = .dateTime
        case "date": self = .date
        case "time": self = .time
        case "duration": self = .duration
        case "email": self = .email
        case "idn-email": self = .idnEmail
        case "hostname": self = .hostname
        case "idn-hostname": self = .idnHostname
        case "ipv4": self = .ipv4
        case "ipv6": self = .ipv6
        case "uri": self = .uri
        case "uri-reference": self = .uriReference
        case "iri-reference": self = .iriReference
        case "uri-template": self = .uriTemplate
        case "json-pointer": self = .jsonPointer
        case "relative-json-pointer": self = .relativeJsonPointer
        case "regex": self = .regex
        case "uuid": self = .uuid
        default: self = .custom(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .dateTime: return "date-time"
        case .date: return "date"
        case .time: return "time"
        case .duration: return "duration"
        case .email: return "email"
        case .idnEmail: return "idn-email"
        case .hostname: return "hostname"
        case .idnHostname: return "idn-hostname"
        case .ipv4: return "ipv4"
        case .ipv6: return "ipv6"
        case .uri: return "uri"
        case .uriReference: return "uri-reference"
        case .iriReference: return "iri-reference"
        case .uriTemplate: return "uri-template"
        case .jsonPointer: return "json-pointer"
        case .relativeJsonPointer: return "relative-json-pointer"
        case .regex: return "regex"
        case .uuid: return "uuid"
        case .custom(let value): return value
        }
    }
}

// MARK: CustomStringConvertible

extension StringFormat: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

// MARK: Codable

extension StringFormat: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

// MARK: ExpressibleByStringLiteral

extension StringFormat: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

// MARK: -

/// Configuration for additional properties in a JSON Schema object.
///
/// In JSON Schema, `additionalProperties` can be a boolean or a schema:
/// - A boolean: `true` allows any additional properties (default),
///   `false` prohibits additional properties.
/// - A schema: Defines validation rules for additional properties.
///
/// ## Examples
/// ```swift
/// // No additional properties allowed
/// .object(properties: ["name": .string()], additionalProperties: .boolean(false))
///
/// // Additional properties must be integers
/// .object(properties: ["name": .string()], additionalProperties: .schema(.integer()))
/// ```
public enum AdditionalProperties: Hashable, Sendable {
    /// Controls whether additional properties are allowed.
    ///
    /// - `true`: Additional properties are allowed (default behavior)
    /// - `false`: No additional properties are allowed
    case boolean(Bool)

    /// Specifies a schema that additional properties must validate against.
    case schema(JSONSchema)
}

// MARK: Codable

extension AdditionalProperties: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else {
            self = .schema(try container.decode(JSONSchema.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .boolean(let value):
            try container.encode(value)
        case .schema(let schema):
            try container.encode(schema)
        }
    }
}

// MARK: ExpressibleByBooleanLiteral

extension AdditionalProperties: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

// MARK: ExpressibleByDictionaryLiteral

extension AdditionalProperties: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONSchema)...) {
        self = .schema(.object(properties: .init(uniqueKeysWithValues: elements)))
    }
}

// MARK: -

/// A simple JSON parser that extracts property keys in order.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
private struct JSONKeyOrderParser {
    private let json: String

    init(json: String) {
        self.json = json
    }

    /// Extract keys from the root object
    func extractRootKeys() -> [String]? {
        return extractKeysFromObject(json)
    }

    /// Extract keys from an object at a specific keypath
    func extractKeys(at keypath: [String]) -> [String]? {
        guard !keypath.isEmpty else {
            return extractRootKeys()
        }

        // Navigate through the keypath to find the target object
        var currentObject = json

        for key in keypath {
            guard let nextObject = findObjectAtPath(key, in: currentObject) else {
                return nil
            }
            currentObject = nextObject
        }

        return extractKeysFromObject(currentObject)
    }

    /// Find an object value for a given key within a JSON string
    private func findObjectAtPath(_ targetKey: String, in jsonString: String) -> String? {
        var index = jsonString.startIndex
        var inString = false
        var escapeNext = false
        var braceDepth = 0

        // Skip to opening brace
        while index < jsonString.endIndex {
            if jsonString[index] == "{" {
                braceDepth = 1
                index = jsonString.index(after: index)
                break
            }
            index = jsonString.index(after: index)
        }

        guard braceDepth == 1 else { return nil }

        // Look for the key at root level
        while index < jsonString.endIndex && braceDepth > 0 {
            let char = jsonString[index]

            if escapeNext {
                escapeNext = false
            } else if inString {
                if char == "\\" {
                    escapeNext = true
                } else if char == "\"" {
                    inString = false
                }
            } else {
                switch char {
                case "\"":
                    if braceDepth == 1 {
                        // Potential key at root level
                        if let (key, keyEnd) = extractString(startingAt: index, in: jsonString) {
                            if key == targetKey {
                                // Found the key, now extract its value
                                if let objectStart = skipToValue(from: keyEnd, in: jsonString) {
                                    return extractObject(startingAt: objectStart, in: jsonString)
                                }
                            }
                            index = keyEnd
                            continue
                        }
                    }
                    inString = true

                case "{":
                    braceDepth += 1

                case "}":
                    braceDepth -= 1

                default:
                    break
                }
            }

            index = jsonString.index(after: index)
        }

        return nil
    }

    /// Extract all top-level keys from a JSON object string
    private func extractKeysFromObject(_ objectJson: String) -> [String]? {
        var keys: [String] = []
        var index = objectJson.startIndex
        var inString = false
        var escapeNext = false
        var braceDepth = 0

        // Skip to opening brace
        while index < objectJson.endIndex {
            if objectJson[index] == "{" {
                braceDepth = 1
                index = objectJson.index(after: index)
                break
            }
            index = objectJson.index(after: index)
        }

        guard braceDepth == 1 else { return nil }

        while index < objectJson.endIndex && braceDepth > 0 {
            let char = objectJson[index]

            if escapeNext {
                escapeNext = false
            } else if inString {
                if char == "\\" {
                    escapeNext = true
                } else if char == "\"" {
                    inString = false
                }
            } else {
                switch char {
                case "\"":
                    if braceDepth == 1 {
                        // Extract key at top level
                        if let (key, keyEnd) = extractString(startingAt: index, in: objectJson) {
                            // Verify it's followed by a colon
                            var colonIndex = keyEnd
                            while colonIndex < objectJson.endIndex
                                && objectJson[colonIndex].isWhitespace
                            {
                                colonIndex = objectJson.index(after: colonIndex)
                            }

                            if colonIndex < objectJson.endIndex && objectJson[colonIndex] == ":" {
                                keys.append(key)
                            }

                            index = keyEnd
                            continue
                        }
                    }
                    inString = true

                case "{":
                    braceDepth += 1

                case "}":
                    braceDepth -= 1

                default:
                    break
                }
            }

            index = objectJson.index(after: index)
        }

        return braceDepth == 0 ? keys : nil
    }

    /// Extract a quoted string starting at the given index
    private func extractString(startingAt startIndex: String.Index, in str: String? = nil) -> (
        String, String.Index
    )? {
        let targetString = str ?? json
        guard startIndex < targetString.endIndex && targetString[startIndex] == "\"" else {
            return nil
        }

        var index = targetString.index(after: startIndex)
        var result = ""
        var escapeNext = false

        while index < targetString.endIndex {
            let char = targetString[index]

            if escapeNext {
                result.append("\\")
                result.append(char)
                escapeNext = false
            } else if char == "\\" {
                escapeNext = true
            } else if char == "\"" {
                return (result, targetString.index(after: index))
            } else {
                result.append(char)
            }

            index = targetString.index(after: index)
        }

        return nil
    }

    /// Skip whitespace and colon to get to the value
    private func skipToValue(from index: String.Index, in jsonString: String) -> String.Index? {
        var current = index

        // Skip whitespace
        while current < jsonString.endIndex && jsonString[current].isWhitespace {
            current = jsonString.index(after: current)
        }

        // Expect colon
        guard current < jsonString.endIndex && jsonString[current] == ":" else {
            return nil
        }

        current = jsonString.index(after: current)

        // Skip whitespace after colon
        while current < jsonString.endIndex && jsonString[current].isWhitespace {
            current = jsonString.index(after: current)
        }

        return current < jsonString.endIndex ? current : nil
    }

    /// Extract a complete object starting at the given index
    private func extractObject(startingAt startIndex: String.Index, in jsonString: String)
        -> String?
    {
        guard startIndex < jsonString.endIndex && jsonString[startIndex] == "{" else {
            return nil
        }

        var index = jsonString.index(after: startIndex)
        var braceDepth = 1
        var inString = false
        var escapeNext = false

        while index < jsonString.endIndex && braceDepth > 0 {
            let char = jsonString[index]

            if escapeNext {
                escapeNext = false
            } else if inString {
                if char == "\\" {
                    escapeNext = true
                } else if char == "\"" {
                    inString = false
                }
            } else {
                switch char {
                case "\"":
                    inString = true
                case "{":
                    braceDepth += 1
                case "}":
                    braceDepth -= 1
                default:
                    break
                }
            }

            index = jsonString.index(after: index)
        }

        return braceDepth == 0 ? String(jsonString[startIndex..<index]) : nil
    }
}
