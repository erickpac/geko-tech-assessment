//
//  DIContainer.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftData

actor DIContainer {
    static let shared = DIContainer()

    // Repositories
    let authRepository: AuthRepository

    // Data sources
    private let authLocalDataSource: AuthLocalDataSource

    // Use cases
    let loginUseCase: LoginUseCase
    let registerUseCase: RegisterUseCase

    private let modelContainer: ModelContainer

    private init() {
        do {
            // Initialize the model container for SwiftData
            self.modelContainer = try ModelContainer(for: User.self)
            
            // Configure the dependency graph
            self.authLocalDataSource = AuthLocalDataSourceImpl(modelContainer: self.modelContainer)
            self.authRepository = AuthRepositoryImpl(dataSource: self.authLocalDataSource)

            // Initialize use cases
            self.loginUseCase = LoginUseCase(repository: self.authRepository)
            self.registerUseCase = RegisterUseCase(repository: self.authRepository)

            print("DIContainer initialized successfully")
        } catch {
            print("Error initializing DIContainer: \(error.localizedDescription)")
            fatalError("Failed to initialize DIContainer")
        }
    }
}
