//
//  AuthLocalDataSource.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftData

protocol AuthLocalDataSource {
    func saveUser(email: String, password: String) async throws -> Bool
    func getUser(email: String, password: String) async throws -> User?
    func getLoggedInUser() async throws -> User?
    func updateUserLoginStatus(email: String, isLoggedIn: Bool) async throws -> Bool
}

class AuthLocalDataSourceImpl: AuthLocalDataSource {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    @MainActor
    func saveUser(email: String, password: String) async throws -> Bool {
        let context = modelContainer.mainContext

        // Check if the user already exists
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
        let existingUsers = try context.fetch(descriptor)

        if !existingUsers.isEmpty {
            throw NSError(domain: "AuthDataSource", code: 2, userInfo: [NSLocalizedDescriptionKey: "El usuario ya existe"])
        }

        // Create new user
        let newUser = User(email: email, password: password)
        context.insert(newUser)
        try context.save()

        return true
    }

    @MainActor
    func getUser(email: String, password: String) async throws -> User? {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<User>(predicate: #Predicate {
            $0.email == email && $0.password == password
        })

        let users = try context.fetch(descriptor)
        return users.first
    }

    @MainActor
    func getLoggedInUser() async throws -> User? {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.isLoggedIn == true })

        let users = try context.fetch(descriptor)
        return users.first
    }

    @MainActor
    func updateUserLoginStatus(email: String, isLoggedIn: Bool) async throws -> Bool {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })

        let users = try context.fetch(descriptor)
        guard let user = users.first else {
            throw NSError(domain: "AuthDataSource", code: 1, userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado"])
        }

        // Update the login status
        user.isLoggedIn = isLoggedIn
        try context.save()

        return true
    }
}
