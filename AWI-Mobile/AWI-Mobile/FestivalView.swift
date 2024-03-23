//
//  FestivalView.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 19/03/2024.
//

import SwiftUI

struct FestivalView: View {
    @State private var festivals = [Festival]()
    @State private var selectedFestivalID: Int? = nil
    
    var body: some View {
        NavigationView {
            if (selectedFestivalID != nil) {
                AccueilView(currentFestival: selectedFestivalID!)
            }
            else{
                List(festivals) { festival in
                                    FestivalRow(festival: festival, onTap: { festivalID in
                                        self.selectedFestivalID = festivalID
                                    })
                                }
                .navigationTitle("Festivals")
                .onAppear {
                    loadFestivals()
                }
            }
        }
    }
    
    func loadFestivals() {
            let url = URL(string: "https://awi-api-2.onrender.com/festival-module")!
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.global().async {
                        do {
                            let decodedFestivals = try JSONDecoder().decode([Festival].self, from: data)
                            DispatchQueue.main.async {
                                self.festivals = decodedFestivals
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            }.resume()
        }
}

struct FestivalRow: View {
    let festival: Festival
    let onTap: (Int) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(festival.nomFestival)
                    .font(.headline)
                Text(" \(formatDateRange(festival.dateDebut, festival.dateFin))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.accentColor)

        }
        .onTapGesture {
                    onTap(festival.id)
                }
    }

    func formatDateRange(_ dateDebut: Date, _ dateFin: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return "\(dateFormatter.string(from: dateDebut)) - \(dateFormatter.string(from: dateFin))"
    }
}


#Preview {
    FestivalView()
}
