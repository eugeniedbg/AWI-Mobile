//
//  Inscription.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 23/03/2024.
//

import Foundation

struct Inscription: Codable{
    let idBenevole: Int
    let idZoneBenevole: Int?
    let idPoste: Int
    let Creneau: String
    let Jour: String
    let isPresent: Bool
}
