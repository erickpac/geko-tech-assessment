//
//  HomeViewModel.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    var username: String = ""
    var isLoading: Bool = false
    var logoutSuccess: Bool = false
    var errorMessage: String = ""
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    static func create() async -> HomeViewModel {
        let viewModel = HomeViewModel(authRepository: await DIContainer.shared.authRepository)
        
        // Load user data on initialization
        await viewModel.loadUserInfo()
        
        return viewModel
    }
    
    func loadUserInfo() async {
        do {
            if let email = try await authRepository.getLoggedInUserEmail() {
                await MainActor.run {
                    self.username = email
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error al cargar información del usuario: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let success = try await authRepository.logout()
                
                await MainActor.run {
                    self.isLoading = false
                    self.logoutSuccess = success
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
