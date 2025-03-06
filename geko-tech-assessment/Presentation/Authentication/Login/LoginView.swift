//
//  LoginView.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel?
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        Group {
            if let viewModel = viewModel {
                contentView(viewModel: viewModel)
            } else {
                loadingView
                    .task {
                        viewModel = await LoginViewModel.create()
                    }
            }
        }
    }

    private func contentView(viewModel: LoginViewModel) -> some View {
        ScrollView {
            VStack(spacing: 30) {
                headerView

                if !viewModel.generalError.isEmpty {
                    errorView(message: viewModel.generalError)
                }

                formView(viewModel: viewModel)

                loginButton(viewModel: viewModel)

                registerLink
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: viewModel.loginSuccess) {
            if viewModel.loginSuccess {
                coordinator.navigate(to: .home)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Cargando...")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            Text("Iniciar Sesión")
                .font(.largeTitle.bold())

            Text("Bienvenido de nuevo")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }

    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
    }

    private func formView(viewModel: LoginViewModel) -> some View {
        VStack(spacing: 16) {
            AppTextField(
                title: "Correo Electrónico",
                text: Binding(
                    get: { viewModel.email },
                    set: { viewModel.email = $0; viewModel.validateEmail() }
                ),
                placeholder: "ejemplo@correo.com",
                keyboardType: .emailAddress,
                errorMessage: viewModel.emailError
            )

            AppTextField(
                title: "Contraseña",
                text: Binding(
                    get: { viewModel.password },
                    set: { viewModel.password = $0; viewModel.validatePassword() }
                ),
                placeholder: "Tu contraseña",
                isSecure: true,
                errorMessage: viewModel.passwordError
            )
        }
    }

    private func loginButton(viewModel: LoginViewModel) -> some View {
        PrimaryButton(
            title: "Iniciar Sesión",
            action: {
                hideKeyboard()
                viewModel.login()
            },
            isLoading: viewModel.isLoading,
            disabled: !viewModel.isLoginButtonEnabled
        )
    }

    private var registerLink: some View {
        HStack {
            Text("¿No tienes cuenta?")
                .foregroundColor(.secondary)

            Button("Regístrate aquí") {
                coordinator.navigate(to: .register)
            }
            .foregroundColor(.blue)
            .fontWeight(.semibold)
        }
        .padding(.top, 8)
    }
}
