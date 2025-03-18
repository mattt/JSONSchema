/// A type that represents a JSON Schema definition
@frozen public indirect enum JSONSchema: Hashable, Sendable {
    // Schema types
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
    static var object: JSONSchema { .object() }

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
    static var array: JSONSchema { .array() }

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
    static var string: JSONSchema { .string() }

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
    static var number: JSONSchema { .number() }

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
    static var integer: JSONSchema { .integer() }

    case boolean(
        title: String? = nil,
        description: String? = nil,
        `default`: JSONValue? = nil
    )
    static var boolean: JSONSchema { .boolean() }

    case null

    // Special schema types
    case reference(String)
    case anyOf([JSONSchema])
    case allOf([JSONSchema])
    case oneOf([JSONSchema])
    case not(JSONSchema)

    // Simple schemas
    case empty
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
        if self == .any {
            var singleValueContainer = encoder.singleValueContainer()
            try singleValueContainer.encode(true)
            return
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
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
            try container.encode("boolean", forKey: .type)

            try encodeIfPresent(title, forKey: .title, into: &container)
            try encodeIfPresent(description, forKey: .description, into: &container)
            try encodeIfPresent(`default`, forKey: .default, into: &container)

        case .null:
            try container.encode("null", forKey: .type)

        case .reference(let ref):
            try container.encode(ref, forKey: .ref)

        case .anyOf(let schemas):
            try container.encode(schemas, forKey: .anyOf)

        case .allOf(let schemas):
            try container.encode(schemas, forKey: .allOf)

        case .oneOf(let schemas):
            try container.encode(schemas, forKey: .oneOf)

        case .not(let schema):
            try container.encode(schema, forKey: .not)

        case .empty, .any:
            break
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

public enum StringFormat: Hashable, Sendable {
    case dateTime
    case date
    case time
    case duration
    case email
    case idnEmail
    case hostname
    case idnHostname
    case ipv4
    case ipv6
    case uri
    case uriReference
    case iriReference
    case uriTemplate
    case jsonPointer
    case relativeJsonPointer
    case regex
    case uuid
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

public enum AdditionalProperties: Hashable, Sendable {
    case boolean(Bool)
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
