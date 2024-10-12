//
//  Post.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

public struct Post: ParseObject {
    public var originalData: Data?
    public var ACL: ParseACL?
    
    // Required fields
    public var objectId: String?
    public var text: String
    public var codeSnippet: String?
    public var isPrivate: Bool
    public var user: User? 
    public var createdAt: Date?
    public var updatedAt: Date?
    
    // Public initializer
    public init() {
        self.objectId = nil
        self.text = ""
        self.codeSnippet = nil
        self.isPrivate = false
        self.user = nil
        self.createdAt = nil
        self.updatedAt = nil
    }
}
