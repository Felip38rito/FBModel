//
//  FBModel.swift
//  FBModel
//
//  Created by Felipe Correia Brito on 16/09/20.
//  Copyright © 2020 Felipe Correia Brito. All rights reserved.
//

import Foundation

/// Represents the model layer on MVC and MVVM patterns
public protocol FBModel: Codable, Equatable {
    /// JSON string representation of the Model
    var JSON: String { get }
    
    /// Generates the model from a JSON representation in string.
    /// Returns nil if not possible
    /// - Parameter json: string in json format to parse this model
    static func from(_ json: String) -> Self?
    
    /// Generates the model from a JSON representation in Data.
    /// - Parameter data: the data representation of some json string to parse this model
    static func from(_ data: Data) -> Self?
}

// Codable conformance
public extension FBModel {
    fileprivate var jsonData: Data {
        get {
            let encoder = JSONEncoder()
            
            do {
                return try encoder.encode(self)
            } catch {
                print(error)
                return Data()
            }
        }
    }
    // The default implementation just catch the data from codable and then translate it to JSON
    var JSON: String {
        get {
            return String(data: self.jsonData, encoding: .utf8) ?? ""
        }
    }
    
    // The default implementation just take a json string and tries to generate.
    static func from(_ json: String) -> Self? {
        guard let data = json.data(using: .utf8) else { return nil }
        return from(data)
    }
    
    static func from(_ data: Data) -> Self? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(self, from: data)
        } catch {
            print("Parser error on FBModel ::: \(self) ::: ", error.localizedDescription)
            return nil
        }
    }
}

// Equatable conformance
public extension FBModel {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.JSON == rhs.JSON
    }
}

