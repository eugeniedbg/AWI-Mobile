//
//  InscriptionView.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import SwiftUI

struct InscriptionView: View {
    
    @ObservedObject var viewModel: InscriptionViewModel
    @State public var selectedPostsFlexible: [Poste] = []
    @State private var selectedPost: Poste?
    @State private var showPopup = false
    @State private var showFlexibleFrame = false

    
    
    
    var body: some View {
        VStack {
            if let posts = viewModel.poste {
                Text("Inscription à une activité")
                    .font(.title)
                    .padding(.top, -115)
                listAllPosts()

                // Ajouter le bouton "Je suis flexible"
                Button(action: {
                    // Ouvrir la frame pour les bénévoles flexibles
                    self.showFlexibleFrame.toggle()
                }) {
                    Text("Je suis flexible")
                        .padding(.top, 10)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showFlexibleFrame) {
                    // Contenu de la frame pour les bénévoles flexibles
                    FlexibleFrameView()
                }
            } else {
                Text("Chargement en cours ... ")
            }
        }
        .onAppear {
            self.viewModel.send(intent: .fetchDataInscription)
        }
    }
    struct LegendItem: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
    }
    
    let legend:
    [LegendItem] = [
        LegendItem(name: "Accueil", color: Color(red: 0.235, green: 0.796, blue: 0.957)),
        LegendItem(name: "Buvette", color: Color(red: 0.067, green: 0.498, blue: 0.271)),
        LegendItem(name: "Animation Jeux", color: Color(red: 0.063, green: 0.361, blue: 0.624)),
        LegendItem(name: "Cuisine", color: Color(red: 0.2, green: 0.769, blue: 0.506)),
        LegendItem(name: "Flexible", color: Color(red: 0.9921568627450981, green: 0.30980392156862746, blue: 0.30980392156862746))
    ]
    
    
    private func postButton(for post: Poste) -> some View {
        let legendItem = legend.first(where: { $0.name == post.nomPoste })
        
        return Button(action: {
            self.selectedPost = post
        }) {
            ZStack {
                if let legendItem = legendItem {
                    Rectangle()
                        .fill(legendItem.color)
                    Text(post.nomPoste)
                        .font(.subheadline)
                        .foregroundColor(.white)
                } else {
                    Text(post.nomPoste)
                        .font(.subheadline)
                }
            }
            .frame(height: UIScreen.main.bounds.height/11)
        }
    }
    
    private func listAllPosts() -> some View {
        print("Postes [] \(viewModel.poste)")
        return VStack {
            ForEach(viewModel.poste ?? [], id: \.id) { post in
                postButton(for: post)
            }
        }
        .sheet(item: $selectedPost) { post in
            AffichageCreneau(idPost: post.idPoste)
        }
    }
    
    
    private func FlexibleFrameView() -> some View {
        VStack {
            ForEach(legend.filter { ["Accueil", "Buvette", "Cuisine"].contains($0.name) }) { legendItem in
                Toggle(isOn: Binding<Bool>(
                    get: {
                        // Vérifie si le poste est déjà sélectionné
                        return self.selectedPostsFlexible.contains(where: { $0.nomPoste == legendItem.name })
                    },
                    set: { newValue in
                        if newValue {
                            // Ajoute le poste sélectionné à selectedPostsFlexible
                            if let posteToAdd = self.viewModel.poste?.first(where: { $0.nomPoste == legendItem.name }) {
                                self.selectedPostsFlexible.append(posteToAdd)
                            }
                        } else {
                            // Retire le poste désélectionné de selectedPostsFlexible
                            self.selectedPostsFlexible.removeAll { $0.nomPoste == legendItem.name }
                        }
                    }
                )) {
                    ZStack {
                        Rectangle()
                            .fill(legendItem.color)
                            .frame(width: 200, height: 120)
                            .cornerRadius(8)
                        Text(legendItem.name)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 5)
            }
            .padding()
            
            Button(action: {
                // Appeler la fonction sinscrireflexible avec les postes sélectionnés
                //self.sinscrireflexible()
            }) {
                Text("S'inscrire")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func AffichageCreneau(idPost: Int) -> some View {
        let result = viewModel.getAllInscriptionByIdpost(idPostes: idPost)
        
        // Utiliser le résultat stocké pour afficher les créneaux
        let days = Array(result.keys).sorted()
        
    


        
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(days, id: \.self) { day in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(day)
                            .font(.largeTitle)
                            .padding(.bottom, 5)
                        
                        if let creneaux = result[day] {
                            ForEach(creneaux, id: \.0) { creneau, inscrits, capacite in
                                Button(action: {
                                    self.viewModel.state.Creneau = creneau
                                    self.viewModel.state.idPoste = idPost
                                    self.viewModel.state.idZoneBenevole = idPost
                                    self.viewModel.state.Jour = day
                                    self.viewModel.sinscrire()
                                    self.showPopup = true
                                }) {
                                    HStack {
                                        Text(creneau)
                                            .font(.headline)
                                            .padding(.bottom, 5)
                                        
                                        Spacer()
                                        
                                        Gauge(value: Double(inscrits) / Double(capacite)) {
                                        } currentValueLabel: {
                                            Text("\(inscrits) / \(capacite)")
                                                .font(.body)
                                        }
                                        
                                    }
                                }
                            }
                        } else {
                            Text("Aucun créneau disponible")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showPopup) {
            // Contenu de la popup
            VStack {
                Text("Votre inscription a bien été prise en compte.")
                    .font(.headline)
                Button("OK") {
                    self.showPopup = false
                }
            }
            .padding()
            .frame(width: 300, height: 150)
        }
    }
}
