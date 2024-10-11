//
//  User.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import ParseSwift
import SwiftUI

public struct User: ParseUser {
    // Required properties by ParseUser
    public var objectId: String?
    public var username: String?
    public var email: String?
    public var password: String?
    
    // Optional properties
    public var emailVerified: Bool?
    public var authData: [String: [String: String]?]?
    public var originalData: Data?
    public var ACL: ParseSwift.ParseACL?
    
    // Required by ParseUser
    public var createdAt: Date?
    public var updatedAt: Date?
    public var lastPostDate: Date?

    // Public initializer
    public init() {
        self.objectId = nil
        self.username = nil
        self.email = nil
        self.password = nil
        self.emailVerified = nil
        self.authData = nil
        self.originalData = nil
        self.ACL = nil
        self.createdAt = nil
        self.updatedAt = nil
        self.lastPostDate = nil
    }
}

