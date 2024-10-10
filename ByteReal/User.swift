//
//  User.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import ParseSwift
import SwiftUI

struct User: ParseUser {
    // Required properties by ParseUser
    var objectId: String?
    var username: String?
    var email: String?
    var password: String?
    
    // Optional properties
    var emailVerified: Bool?
    var authData: [String: [String: String]?]?
    var originalData: Data?
    var ACL: ParseSwift.ParseACL?
    
    // Required by ParseUser
    var createdAt: Date?
    var updatedAt: Date?
}

