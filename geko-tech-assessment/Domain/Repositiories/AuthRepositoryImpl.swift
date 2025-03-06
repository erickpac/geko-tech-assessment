//
//  AuthRepositoryImpl.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthLocalDataSource

    init(dataSource: AuthLocalDataSource) {
        self.dataSource = dataSource
    }

    func login(email: String, password: String) async throws -> Bool {
        guard let user = try await dataSource.getUser(email: email, password: password) else {
            throw AuthError.invalidCredentials
        }

        return try await dataSource.updateUserLoginStatus(email: user.email, isLoggedIn: true)
    }

    func register(email: String, password: String) async throws -> Bool {
        try await dataSource.saveUser(email: email, password: password)
    }

    func logout() async throws -> Bool {
        guard let user = try await dataSource.getLoggedInUser() else {
            throw AuthError.noUserLoggedIn
        }

        return try await dataSource.updateUserLoginStatus(email: user.email, isLoggedIn: false)
    }

    func isUserLoggedIn() async throws -> Bool {
        let user = try await dataSource.getLoggedInUser()
        return user != nil
    }

    func getLoggedInUserEmail() async throws -> String? {
        let user = try await dataSource.getLoggedInUser()
        return user?.email
    }
}
