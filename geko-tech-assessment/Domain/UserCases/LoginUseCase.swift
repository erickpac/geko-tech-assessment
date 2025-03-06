//
//  LoginUseCase.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation

struct LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> Bool {
        return try await repository.login(email: email, password: password)
    }
}
