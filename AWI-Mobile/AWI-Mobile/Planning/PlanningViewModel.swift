//
//  PlanningViewModel.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation
import SwiftUI

class PlanningViewModel: ObservableObject{
    @Published var state = PlanningState()
    @Published public var festival: Festival? = nil
    private var planningIntent : PlanningIntent?
    
    struct LegendItem {
        let name: String
        let color: Color
    }
    
    
    private func getInscription(){
        let idbenevole = UserDefaults.standard.integer(forKey: "userId")
        print("idbenevole : \(idbenevole)")
        guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module/volunteer/\(idbenevole)")else
        {
            print("Problème ID")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoderInscription = try decoder.decode([Inscription].self, from: data)
                DispatchQueue.main.async {
                    
                    // Ajoute les éléments décodés à self.state.inscription
                    for item in decoderInscription {
                        if self.state.poste.contains(where: { $0.idPoste == item.idPoste }) {
                            self.state.inscription.append(item)
                        }
                    }
                    self.festival = self.state.festival
                    print("inscription : \(self.state.inscription)")
                    debugPrint("festival=\(self.festival?.nomFestival)")
                    
                }
            }
            catch{
                print("Error decoding : \(error)")
            }
            
        }
        task.resume()
    }
    
    private func getPostes() {
        guard let url = URL(string: "https://awi-api-2.onrender.com/position-module") else {
            print("Problème URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedPostes = try decoder.decode([Poste].self, from: data)
                DispatchQueue.main.async {
                    self.state.poste.removeAll()

                    // Ajoute les éléments décodés à self.state.poste
                    for item in decodedPostes {
                        if self.state.employers.contains(where: { $0.idPoste == item.idPoste }) {
                            self.state.poste.append(item)
                        }
                    }
                    print("Post : \(self.state.poste)")
                    self.getInscription()
                }
            }
            catch {
                print("Error decoding: \(error)")
            }
        }
        task.resume()
    }
    
    private func getEmployers() {
        let festivale = UserDefaults.standard.integer(forKey: "festivalID")

            // Initialisation de self.state.festival
            let festivalUrl = URL(string: "https://awi-api-2.onrender.com/festival-module/\(festivale)")!
            var festivalRequest = URLRequest(url: festivalUrl)
            festivalRequest.httpMethod = "GET"
            festivalRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let festivalTask = URLSession.shared.dataTask(with: festivalRequest) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("Error: No data received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let decodedFestival = try decoder.decode(Festival.self, from: data)
                    DispatchQueue.main.async {
                        self.state.festival = decodedFestival
                    }
                }
                catch {
                    print("Error decoding: \(error)")
                }
            }
            festivalTask.resume()
        
        guard let url = URL(string: "https://awi-api-2.onrender.com/employer-module/festival/\(UserDefaults.standard.integer(forKey: "festivalID"))") else {
            print("Problème URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedEmployers = try decoder.decode([Employer].self, from: data)
                DispatchQueue.main.async {
                    self.state.employers.removeAll()

                    // Ajoute les éléments décodés à self.state.employers
                    for item in decodedEmployers {
                        if(item.idFestival == UserDefaults.standard.integer(forKey: "festivalID")){
                            self.state.employers.append(item)
                            
                        }
                        
                    }
                    print("employers : \(self.state.employers)")
                    self.getPostes()
                }
            }
            catch {
                print("Error decoding: \(error)")
            }
        }
        task.resume()
    }
    
    func send(intent: PlanningIntent){
        self.planningIntent = intent
        
        switch intent{
        case .getFestivalData:
            getEmployers()
        }
    }

    public func getColorForCreneau(jour: String, creneau: String) -> Color {
            // Récupérer les inscriptions pour le jour et le créneau donnés
        let inscriptionsForCreneau = state.inscription.filter { $0.Jour == jour && $0.Creneau == creneau }


            // Récupérer les noms de poste des inscriptions trouvées
            let postesForCreneau = inscriptionsForCreneau.compactMap { inscription in
                state.poste.first { $0.idPoste == inscription.idPoste }?.nomPoste
            }

            // Créer une légende avec les noms de poste et leurs couleurs correspondantes
            let legend: [LegendItem] = [
                LegendItem(name: "Accueil", color: Color(red: 0.235, green: 0.796, blue: 0.957)),
                LegendItem(name: "Buvette", color: Color(red: 0.067, green: 0.498, blue: 0.271)),
                LegendItem(name: "Animation Jeux", color: Color(red: 0.063, green: 0.361, blue: 0.624)),
                LegendItem(name: "Cuisine", color: Color(red: 0.2, green: 0.769, blue: 0.506))
            ]

            // Trouver la couleur correspondante au nom de poste trouvé dans les inscriptions
            for poste in postesForCreneau {
                if let legendItem = legend.first(where: { $0.name == poste }) {
                    return legendItem.color
                }
            }

            // Retourner une couleur par défaut si aucun nom de poste ne correspond
            return Color.white
        }
    
}
