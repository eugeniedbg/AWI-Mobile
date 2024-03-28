//
//  Festival.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 19/03/2024.
//

import SwiftUI

import Foundation

struct Festival: Identifiable, Decodable {
    var id: Int
    let nomFestival: String
    let dateDebut: Date
    let dateFin: Date

    enum CodingKeys: String, CodingKey {
        case id = "idFestival"
        case nomFestival = "NomFestival"
        case dateDebut = "DateDebut"
        case dateFin = "DateFin" // Mettre à jour la casse pour correspondre au JSON
    }
    init(from decoder: Decoder) throws{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            nomFestival = try container.decode(String.self, forKey: .nomFestival)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateDebut = try dateFormatter.date(from: try container.decode(String.self, forKey: .dateDebut)) ?? Date()
            dateFin = try dateFormatter.date(from: try container.decode(String.self, forKey: .dateFin)) ?? Date()
        }
}
