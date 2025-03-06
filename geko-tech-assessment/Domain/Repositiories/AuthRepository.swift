//
//  AuthRepository.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> Bool
    func register(email: String, password: String) async throws -> Bool
    func logout() async throws -> Bool
    func isUserLoggedIn() async throws -> Bool
    func getLoggedInUserEmail() async throws -> String?
}
