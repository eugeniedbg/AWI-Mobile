//
//  Poste.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 23/03/2024.
//

import Foundation

struct Poste: Codable, Identifiable{
    var id: Int {
            return idPoste
        }
    
    let idPoste: Int
    let nomPoste: String
    let description : String
    let capacite : Int
    
}
