//
//  HomeView.swift
//  geko-tech-assessment
//
//  Created by Erick Pac on 5/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel?
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        Group {
            if let viewModel = viewModel {
                contentView(viewModel: viewModel)
            } else {
                loadingView
                    .task {
                        viewModel = await HomeViewModel.create()
                    }
            }
        }
    }

    private func contentView(viewModel: HomeViewModel) -> some View {
        VStack(spacing: 30) {
            welcomeSection(email: viewModel.username)

            Spacer()

            if !viewModel.errorMessage.isEmpty {
                errorView(message: viewModel.errorMessage)
            }

            logoutButton(viewModel: viewModel)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
        .onChange(of: viewModel.logoutSuccess) {
            if viewModel.logoutSuccess {
                coordinator.popToRoot()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            Text("Cargando información del usuario...")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private func welcomeSection(email: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding(.bottom, 20)

            Text("¡Bienvenido!")
                .font(.largeTitle.bold())

            Text("Has iniciado sesión exitosamente")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(email)
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 8)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.top, 40)
    }

    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
    }

    private func logoutButton(viewModel: HomeViewModel) -> some View {
        PrimaryButton(
            title: "Cerrar Sesión",
            action: {
                viewModel.logout()
            },
            isLoading: viewModel.isLoading,
            disabled: false,
            color: .red
        )
        .padding(.bottom, 40)
    }
}
