//
//  FBType.swift
//  FBModel
//
//  Created by Felipe Correia Brito on 30/09/20.
//  Copyright © 2020 Felipe Correia Brito. All rights reserved.
//

import Foundation

/// Complex type that is capable of encode and decode itself on more basic types
///
/// The objective of FBType is to work with api when the same object can be received
/// as either string, boolean, int or double, case when the default codable will not extract
public enum FBType: Codable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        else if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        else if let value = try? container.decode(Double.self) {
            self = .double(value)
        }
        
        throw DecodingError.typeMismatch(FBType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Incompatible type for FBType"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let string):
            try container.encode(string)
        case .bool(let bool):
            try container.encode(bool)
        case .double(let double):
            try container.encode(double)
        case .int(let int):
            try container.encode(int)
        }
    }
    
    /// The string representation of this FBType
    var string: String {
        get {
            switch self {
            case .string(let val):
                return val
            case .int(let val):
                return String(val)
            case .double(let val):
                return String(val)
            case .bool(let val):
                return String(val)
            }
        }
    }
    /// The integer representation of this FBType
    var int: Int? {
        get {
            switch self {
            case .string(let val):
                return Int(val)
            case .int(let val):
                return val
            case .double(let val):
                return Int(val)
            case .bool(let val):
                return val ? 1 : 0
            }
        }
    }
    /// The double representation of this FBType
    var double: Double? {
        get {
            switch self {
            case .string(let val):
                return Double(val)
            case .int(let val):
                return Double(val)
            case .double(let val):
                return val
            case .bool(let val):
                return Double(val ? 1 : 0)
            }
        }
    }
    /// The boolean representation of this FBType
    var bool: Bool? {
        get {
            switch self {
            case .string(let val):
                return Bool(val)
            case .int(let val):
                return Bool(truncating: val as NSNumber)
            case .double(let val):
                return Bool(truncating: val as NSNumber)
            case .bool(let val):
                return val
            }
        }
    }
}
