import struct Foundation.Data
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder

/// A representation of a JSON value.
///
/// Use `JSONValue` to work with JSON data in Swift in a type-safe way. This type can represent
/// all standard JSON types: null, boolean, number (integer or floating-point),
/// string, array, and object.
///
/// You can create JSON values directly using the enum cases, through literal expressions,
/// or by converting from `Codable` types.
///
/// ## Example
/// ```swift
/// // Creating JSON values
/// let object: JSONValue = [
///     "name": "John",
///     "age": 30,
///     "isActive": true,
///     "address": [
///         "street": "123 Main St",
///         "city": "Anytown"
///     ],
///     "tags": ["developer", "swift"]
/// ]
/// ```
@frozen public indirect enum JSONValue: Hashable, Sendable {
    /// Represents a JSON null value.
    case null

    /// Represents a JSON boolean value.
    ///
    /// - Parameter value: The boolean value.
    case bool(Bool)

    /// Represents a JSON integer value.
    ///
    /// - Parameter value: The integer value.
    case int(Int)

    /// Represents a JSON floating-point number.
    ///
    /// - Parameter value: The double value.
    case double(Double)

    /// Represents a JSON string value.
    ///
    /// - Parameter value: The string value.
    case string(String)

    /// Represents a JSON array containing zero or more JSON values.
    ///
    /// - Parameter value: An array of JSON values.
    case array([JSONValue])

    /// Represents a JSON object with string keys and JSON values.
    ///
    /// - Parameter value: A dictionary with string keys and JSON values.
    case object([String: JSONValue])

    /// Creates a `JSONValue` from a `Codable` value.
    ///
    /// This initializer encodes the value to JSON and then decodes it into a `JSONValue`.
    /// If the value is already a `JSONValue`, it's returned directly.
    ///
    /// - Parameter value: The `Codable` value to convert.
    /// - Returns: A `JSONValue` representing the value.
    /// - Throws: An error if encoding or decoding fails.
    public init<T: Codable>(_ value: T) throws {
        if let valueAsValue = value as? Value {
            self = valueAsValue
        } else {
            let data = try JSONEncoder().encode(value)
            self = try JSONDecoder().decode(Value.self, from: data)
        }
    }

    /// Returns whether the value is `null`.
    ///
    /// Use this property to check if the value is JSON null without pattern matching.
    ///
    /// - Returns: `true` if the value is `.null`, otherwise `false`.
    public var isNull: Bool {
        return self == .null
    }

    /// Returns the associated `Bool` value if this is a boolean value.
    ///
    /// - Returns: The boolean value if this is a `.bool` case, otherwise `nil`.
    public var boolValue: Bool? {
        guard case let .bool(value) = self else { return nil }
        return value
    }

    /// Returns the associated `Int` value if this is an integer value.
    ///
    /// - Returns: The integer value if this is an `.int` case, otherwise `nil`.
    public var intValue: Int? {
        guard case let .int(value) = self else { return nil }
        return value
    }

    /// Returns the numeric value as a `Double`.
    ///
    /// This property returns a `Double` if the value is either a `.double` or an `.int`.
    /// Integer values are converted to their double representation.
    ///
    /// - Returns: The double value if this is a `.double` or `.int` case, otherwise `nil`.
    public var doubleValue: Double? {
        switch self {
        case let .double(value): return value
        case let .int(value): return Double(value)
        default: return nil
        }
    }

    /// Returns the associated `String` value if this is a string value.
    ///
    /// - Returns: The string value if this is a `.string` case, otherwise `nil`.
    public var stringValue: String? {
        guard case let .string(value) = self else { return nil }
        return value
    }

    /// Returns the associated array if this is an array value.
    ///
    /// - Returns: The array of `JSONValue` if this is an `.array` case, otherwise `nil`.
    public var arrayValue: [JSONValue]? {
        guard case let .array(value) = self else { return nil }
        return value
    }

    /// Returns the associated dictionary if this is an object value.
    ///
    /// - Returns: The dictionary of string keys and `JSONValue` values if this is
    ///   an `.object` case, otherwise `nil`.
    public var objectValue: [String: JSONValue]? {
        guard case let .object(value) = self else { return nil }
        return value
    }
}

// MARK: - Codable

extension JSONValue: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            // Always preserve double values as doubles
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([Value].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: Value].self) {
            self = .object(value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Value type not found")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
}

extension JSONValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .null:
            return ""
        case .bool(let value):
            return value.description
        case .int(let value):
            return value.description
        case .double(let value):
            return value.description
        case .string(let value):
            return value.description
        case .array(let value):
            return value.description
        case .object(let value):
            return value.description
        }
    }
}

// MARK: - ExpressibleByNilLiteral

extension JSONValue: ExpressibleByNilLiteral {
    /// Creates a null JSON value.
    public init(nilLiteral: ()) {
        self = .null
    }
}

// MARK: - ExpressibleByBooleanLiteral

extension JSONValue: ExpressibleByBooleanLiteral {
    /// Creates a boolean JSON value.
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension JSONValue: ExpressibleByIntegerLiteral {
    /// Creates an integer JSON value.
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension JSONValue: ExpressibleByFloatLiteral {
    /// Creates a floating-point JSON value.
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

// MARK: - ExpressibleByStringLiteral

extension JSONValue: ExpressibleByStringLiteral {
    /// Creates a string JSON value.
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - ExpressibleByArrayLiteral

extension JSONValue: ExpressibleByArrayLiteral {
    /// Creates an array JSON value.
    public init(arrayLiteral elements: JSONValue...) {
        self = .array(elements)
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension JSONValue: ExpressibleByDictionaryLiteral {
    /// Creates an object JSON value.
    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        var dictionary: [String: Value] = [:]
        for (key, value) in elements {
            dictionary[key] = value
        }
        self = .object(dictionary)
    }
}

// MARK: - ExpressibleByStringInterpolation

extension JSONValue: ExpressibleByStringInterpolation {
    /// Implementation of string interpolation for JSONValue strings.
    public struct StringInterpolation: StringInterpolationProtocol {
        var stringValue: String

        public init(literalCapacity: Int, interpolationCount: Int) {
            self.stringValue = ""
            self.stringValue.reserveCapacity(literalCapacity + interpolationCount)
        }

        public mutating func appendLiteral(_ literal: String) {
            self.stringValue.append(literal)
        }

        public mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T) {
            self.stringValue.append(value.description)
        }
    }

    /// Creates a string JSON value from string interpolation.
    public init(stringInterpolation: StringInterpolation) {
        self = .string(stringInterpolation.stringValue)
    }
}

// MARK: - Standard Library Type Extensions

extension Bool {
    /// Creates a boolean value from a JSON value.
    ///
    /// - Parameters:
    ///   - value: The JSON value to convert
    ///   - strict: When `true`, only converts from boolean values. Defaults to `true`
    ///
    /// In non-strict mode, converts:
    /// - Integers: `1` to `true`, `0` to `false`
    /// - Doubles: `1.0` to `true`, `0.0` to `false`
    /// - Strings (case-insensitive): "true", "yes", "on", "1" to `true`;
    ///   "false", "no", "off", "0" to `false`
    public init?(_ value: JSONValue, strict: Bool = true) {
        switch value {
        case .bool(let b):
            self = b
        case .int(let i) where !strict:
            switch i {
            case 0: self = false
            case 1: self = true
            default: return nil
            }
        case .double(let d) where !strict:
            switch d {
            case 0.0: self = false
            case 1.0: self = true
            default: return nil
            }
        case .string(let s) where !strict:
            switch s {
            case "true", "t", "yes", "y", "on", "1":
                self = true
            case "false", "f", "no", "n", "off", "0":
                self = false
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

extension Int {
    /// Creates an integer value from a JSON value.
    ///
    /// - Parameters:
    ///   - value: The JSON value to convert
    ///   - strict: When `true`, only converts from integer values. Defaults to `true`
    ///
    /// In non-strict mode, converts:
    /// - Doubles that can be represented exactly as integers
    /// - Strings that contain a valid integer representation
    public init?(_ value: JSONValue, strict: Bool = true) {
        switch value {
        case .int(let i):
            self = i
        case .double(let d) where !strict:
            guard let intValue = Int(exactly: d) else { return nil }
            self = intValue
        case .string(let s) where !strict:
            guard let intValue = Int(s) else { return nil }
            self = intValue
        default:
            return nil
        }
    }
}

extension Double {
    /// Creates a double value from a JSON value.
    ///
    /// - Parameters:
    ///   - value: The JSON value to convert
    ///   - strict: When `true`, only converts from number values. Defaults to `true`
    ///
    /// In non-strict mode, also converts strings containing valid floating-point numbers.
    public init?(_ value: JSONValue, strict: Bool = true) {
        switch value {
        case .double(let d):
            self = d
        case .int(let i):
            self = Double(i)
        case .string(let s) where !strict:
            guard let doubleValue = Double(s) else { return nil }
            self = doubleValue
        default:
            return nil
        }
    }
}

extension String {
    /// Creates a string value from a JSON value.
    ///
    /// - Parameters:
    ///   - value: The JSON value to convert
    ///   - strict: When `true`, only converts from string values. Defaults to `true`
    ///
    /// In non-strict mode, converts any value to its string representation.
    public init?(_ value: JSONValue, strict: Bool = true) {
        switch value {
        case .string(let s):
            self = s
        case .int(let i) where !strict:
            self = String(i)
        case .double(let d) where !strict:
            self = String(d)
        case .bool(let b) where !strict:
            self = String(b)
        default:
            return nil
        }
    }
}
