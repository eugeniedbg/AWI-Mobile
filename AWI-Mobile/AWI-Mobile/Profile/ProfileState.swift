//
//  ProfileState.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation

struct Profile: Codable {
    let idBenevole: Int
    let Pseudo: String
    let Prenom: String
    let Nom: String
    let Email: String
    let Adresse: String?
    let Ville: String?
    let Telephone: String?
    let Regime: String?
    let TailletTShirt: String?
    let StatutHebergement: String?
    let JeuPrefere: String?
    let NombreEditionPrecedente: Int?
}

class ProfileState: ObservableObject {
    @Published public var profile: Profile? = nil
}

