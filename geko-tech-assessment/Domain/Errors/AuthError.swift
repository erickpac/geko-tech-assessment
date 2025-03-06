//
//  AuthError.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 6/03/25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case userAlreadyExists
    case userNotFound
    case noUserLoggedIn

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Credenciales inválidas"
        case .userAlreadyExists:
            return "El usuario ya existe"
        case .userNotFound:
            return "Usuario no encontrado"
        case .noUserLoggedIn:
            return "No hay usuario con sesión iniciada"
        }
    }
}
