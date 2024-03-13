//
//  AccueilView.swift
//  AWI-front
//
//  Created by Thomas Coulon on 16/03/2024.
//

import SwiftUI

struct AccueilView: View {
    @State private var festivals : [Festival] = []
    @State private var selectedFestivalId : Int? = nil
    
    var body: some View {
        NavigationView {
                   VStack {
                       if festivals.isEmpty {
                           Text("Il n’y a pas de festival prévu pour le moment.")
                               .font(.largeTitle)
                               .padding()
                       } else {
                           List(festivals) { festival in
                               Button(action: {
                                   self.selectedFestivalId = festival.id
                               }) {
                                   HStack {
                                       VStack(alignment: .leading) {
                                           Text(festival.nomFestival)
                                               .font(.headline)
                                           Text("Du \(formatDate(festival.dateDebut)) au \(formatDate(festival.dateFin))")
                                               .font(.subheadline)
                                       }
                                       Spacer()
                                       Image(systemName: "chevron.right")
                                           .foregroundColor(.gray)
                                   }
                               }
                           }
                           .listStyle(PlainListStyle())

                       }
                   }
                   .onAppear {
                       self.loadFestivals()
                       print("test")
                   }
               }
        NavigationLink{
        destination: InscriptionViewModel(festivals: self.$festivals)
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
    
    private func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
}



#Preview {
    AccueilView()
}
