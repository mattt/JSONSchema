/// A type that represents a JSON Schema definition.
///
/// JSONSchema is a representation of JSON Schema that lets you create,
/// manipulate, and encode/decode schema documents. It supports all major
/// schema types and validation keywords from the JSON Schema specification.
///
/// ## Example
/// ```swift
/// let schema: JSONSchema = .object(
///     properties: [
///         "name": .string(minLength: 2),
///         "age": .integer(minimum: 0),
///         "email": .string(format: .email)
///     ],
///     required: ["name", "email"]
/// )
/// ```
@frozen public indirect enum JSONSchema: Hashable, Sendable {
    // Schema types

    /// An object schema that validates JSON objects.
    ///
    /// Use this case to define the structure of a JSON object, including its properties,
    /// required fields, and rules for additional properties.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    ///   - examples: Example values that are valid against this schema.
    ///   - enum: An array of allowed values for this schema.
    ///   - const: A constant value that this schema must equal.
    ///   - properties: A dictionary mapping property names to their schema definitions.
    ///   - required: An array of property names that are required in valid objects.
    ///   - additionalProperties: Rules for validating properties not defined in `properties`.
    case object(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil,
        examples: [JSONValue]? = nil,
        enum: [JSONValue]? = nil,
        const: JSONValue? = nil,
        /*  */
        properties: [String: JSONSchema] = [:],
        required: [String] = [],
        additionalProperties: AdditionalProperties? = nil
    )

    /// Creates an empty object schema with default settings.
    static var object: JSONSchema { .object() }

    /// An array schema that validates JSON arrays.
    ///
    /// Use this case to define validation rules for JSON arrays, including the schema
    /// for array items and constraints on array length and uniqueness.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    ///   - examples: Example values that are valid against this schema.
    ///   - enum: An array of allowed values for this schema.
    ///   - const: A constant value that this schema must equal.
    ///   - items: The schema that all array items must validate against.
    ///   - minItems: The minimum number of items required in the array.
    ///   - maxItems: The maximum number of items allowed in the array.
    ///   - uniqueItems: Whether array items must be unique.
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

    /// A string schema that validates JSON strings.
    ///
    /// Use this case to define validation rules for JSON strings, including length
    /// constraints, pattern matching, and format validation.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    ///   - examples: Example values that are valid against this schema.
    ///   - enum: An array of allowed values for this schema.
    ///   - const: A constant value that this schema must equal.
    ///   - minLength: The minimum length of the string.
    ///   - maxLength: The maximum length of the string.
    ///   - pattern: A regular expression that the string must match.
    ///   - format: A predefined format the string must conform to (e.g., email, date-time).
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

    /// A number schema that validates JSON numbers with decimal points.
    ///
    /// Use this case to define validation rules for floating-point JSON numbers,
    /// including range constraints and multiple-of validation.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    ///   - examples: Example values that are valid against this schema.
    ///   - enum: An array of allowed values for this schema.
    ///   - const: A constant value that this schema must equal.
    ///   - minimum: The minimum value allowed (inclusive).
    ///   - maximum: The maximum value allowed (inclusive).
    ///   - exclusiveMinimum: The minimum value allowed (exclusive).
    ///   - exclusiveMaximum: The maximum value allowed (exclusive).
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

    /// An integer schema that validates JSON integer numbers.
    ///
    /// Use this case to define validation rules for integer JSON numbers,
    /// including range constraints and multiple-of validation.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    ///   - examples: Example values that are valid against this schema.
    ///   - enum: An array of allowed values for this schema.
    ///   - const: A constant value that this schema must equal.
    ///   - minimum: The minimum value allowed (inclusive).
    ///   - maximum: The maximum value allowed (inclusive).
    ///   - exclusiveMinimum: The minimum value allowed (exclusive).
    ///   - exclusiveMaximum: The maximum value allowed (exclusive).
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

    /// A boolean schema that validates JSON boolean values.
    ///
    /// Use this case to define a schema that validates boolean true/false values,
    /// with optional metadata.
    ///
    /// - Parameters:
    ///   - title: A descriptive title for the schema.
    ///   - description: A description of the schema's purpose.
    ///   - default: A default value for this schema.
    case boolean(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil
    )

    /// Creates an empty boolean schema with default settings.
    static var boolean: JSONSchema { .boolean() }

    /// A null schema that validates only the JSON null value.
    case null

    // Special schema types

    /// A reference to another schema definition.
    ///
    /// Use this case to reference a schema defined elsewhere, typically using
    /// a JSON Pointer format string such as "#/definitions/address".
    ///
    /// - Parameter reference: The reference string pointing to another schema.
    case reference(String)

    /// A schema that requires validation against any of the provided schemas.
    ///
    /// This is equivalent to a logical OR between the provided schemas.
    ///
    /// - Parameter schemas: An array of schemas, where a valid instance must
    ///   validate against at least one of these schemas.
    case anyOf([JSONSchema])

    /// A schema that requires validation against all of the provided schemas.
    ///
    /// This is equivalent to a logical AND between the provided schemas.
    ///
    /// - Parameter schemas: An array of schemas, where a valid instance must
    ///   validate against all of these schemas.
    case allOf([JSONSchema])

    /// A schema that requires validation against exactly one of the provided schemas.
    ///
    /// This is equivalent to a logical XOR between the provided schemas.
    ///
    /// - Parameter schemas: An array of schemas, where a valid instance must
    ///   validate against exactly one of these schemas.
    case oneOf([JSONSchema])

    /// A schema that requires validation to fail against the provided schema.
    ///
    /// This is equivalent to a logical NOT of the provided schema.
    ///
    /// - Parameter schema: A schema where a valid instance must NOT validate
    ///   against this schema.
    case not(JSONSchema)

    // Simple schemas

    /// An empty schema that imposes no constraints.
    ///
    /// This schema is equivalent to an empty JSON object `{}` and places
    /// no restrictions on the validated instance.
    case empty

    /// A schema that accepts any valid JSON value.
    ///
    /// This schema is equivalent to the boolean value `true` in JSON Schema
    /// and will accept any JSON value without restriction.
    case any
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

            try encodeIfNotEmpty(properties, forKey: .properties, into: &container)
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
            let properties =
                try container.decodeIfPresent([String: JSONSchema].self, forKey: .properties) ?? [:]
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

// MARK: -

/// Standard format options for string values in JSON Schema.
///
/// This enumeration covers all standard string formats defined in the JSON Schema
/// specification, including date-time, email, URI, UUID, and others. You can also
/// define custom formats using the `custom` case.
///
/// Use these formats with the `format` parameter in a string schema to indicate
/// the expected format of string values.
public enum StringFormat: Hashable, Sendable {
    /// String values must be valid according to RFC 3339 date-time format.
    case dateTime

    /// String values must be valid according to RFC 3339 full-date format.
    case date

    /// String values must be valid according to RFC 3339 time format.
    case time

    /// String values must be valid according to RFC 3339 duration format.
    case duration

    /// String values must be valid email addresses.
    case email

    /// String values must be valid internationalized email addresses.
    case idnEmail

    /// String values must be valid hostnames according to RFC 1034.
    case hostname

    /// String values must be valid internationalized hostnames.
    case idnHostname

    /// String values must be valid IPv4 addresses.
    case ipv4

    /// String values must be valid IPv6 addresses.
    case ipv6

    /// String values must be valid URIs according to RFC 3986.
    case uri

    /// String values must be valid URI references according to RFC 3986.
    case uriReference

    /// String values must be valid IRI references.
    case iriReference

    /// String values must be valid URI templates according to RFC 6570.
    case uriTemplate

    /// String values must be valid JSON Pointers according to RFC 6901.
    case jsonPointer

    /// String values must be valid relative JSON Pointers.
    case relativeJsonPointer

    /// String values must be valid regular expressions.
    case regex

    /// String values must be valid UUIDs according to RFC 4122.
    case uuid

    /// String values must conform to a custom format.
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
/// In JSON Schema, the `additionalProperties` keyword can be either:
/// - A boolean: `true` allows any additional properties (default),
///   `false` prohibits additional properties beyond those specified.
/// - A schema: Defines validation rules for any additional properties.
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
    ///
    /// - Parameter allowed: Whether additional properties are allowed.
    case boolean(Bool)

    /// Specifies a schema that additional properties must validate against.
    ///
    /// - Parameter schema: The schema to validate additional properties against.
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
