//
//  ProfileView.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import SwiftUI
struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showLoginView = false


    var body: some View {
        ScrollView{
            VStack {
                Text("Mon profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                if let profile = viewModel.profile {
                    VStack(alignment: .leading) {
                        ProfileRowView(label: "Pseudo", value: profile.Pseudo)
                        ProfileRowView(label: "Nom", value: profile.Nom)
                        ProfileRowView(label: "Prénom", value: profile.Prenom)
                        ProfileRowView(label: "Email", value: profile.Email)
                        ProfileRowView(label: "Adresse", value: profile.Adresse ?? "")
                        ProfileRowView(label: "Ville", value: profile.Ville ?? "")
                        ProfileRowView(label: "Téléphone", value: profile.Telephone ?? "")
                        ProfileRowView(label: "Régime", value: profile.Regime ?? "")
                        ProfileRowView(label: "Taille T-Shirt", value: profile.TailletTShirt ?? "")
                        ProfileRowView(label: "Statut Hébergement", value: profile.StatutHebergement ?? "")
                        ProfileRowView(label: "Jeu préféré", value: profile.JeuPrefere ?? "")
                        ProfileRowView(label: "Nombre d'éditions précédentes", value: profile.NombreEditionPrecedente.map { String($0) } ?? "")
                    }
                    .padding()
                } else {
                    Text("Chargement en cours...")
                        .padding()
                }
                Button(action: {
                    // Code à exécuter lorsque le bouton est pressé
                    self.viewModel.send(intent: .putDataProfil)
                }) {
                    Text("Modifier")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Button(action: {
                    // Code à exécuter lorsque le bouton est pressé
                    UserDefaults.standard.removeObject(forKey: "userId")
                    UserDefaults.standard.removeObject(forKey: "token")
                    self.showLoginView = true
                    
                }) {
                    Text("Déconnexion ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
                .fullScreenCover(isPresented: $showLoginView){
                                   LoginView(viewModel: LoginViewModel())
                               }
            }
            .onAppear {
                self.viewModel.send(intent: .fetchDataProfil)
            }
        }
    }
}

struct ProfileRowView: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}
