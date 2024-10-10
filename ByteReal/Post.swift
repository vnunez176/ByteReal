//
//  Post.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import ParseSwift
import SwiftUI

struct Post: ParseObject {
    var originalData: Data?
    
    init() {
        self.objectId = nil
        self.text = ""
        self.image = nil
        self.isPrivate = false
        self.user = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    var ACL: ParseACL?
    
    // Required fields
    var objectId: String?
    var text: String
    var image: Data? // Store image as Data
    var isPrivate: Bool
    var user: User? // Relation to User
    var createdAt: Date?
    var updatedAt: Date?
    
    // Other necessary methods and properties can be added as needed
}
