//
//  InscriptionState.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation

class InscriptionState: ObservableObject{
    @Published var idBenevole: Int = UserDefaults.standard.integer(forKey: "userId")
    @Published var idZoneBenevole: Int? = nil
    @Published var idPoste: Int? = nil
    @Published var Creneau: String? = nil
    @Published var Jour: Date? = nil
    @Published var isPresent: Bool = false
}
