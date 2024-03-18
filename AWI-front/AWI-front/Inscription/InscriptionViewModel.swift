//
//  InscriptionViewModel.swift
//  AWI-front
//
//  Created by Thomas Coulon on 17/03/2024.
//

import SwiftUI

struct InscriptionViewModel: View {
    @State private var festivals = [Festival]()

        var body: some View {
            List(festivals) { festival in
                Text(festival.nomFestival)
            }
            .onAppear {
                loadFestivals()
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

#Preview {
    InscriptionViewModel()
}
