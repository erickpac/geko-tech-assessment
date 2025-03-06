//
//  User.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var email: String
    var password: String
    var isLoggedIn: Bool

    init(email: String, password: String, isLoggedIn: Bool = false) {
        self.email = email
        self.password = password
        self.isLoggedIn = isLoggedIn
    }
}
