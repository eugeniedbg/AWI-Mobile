//
//  InscriptionViewModel.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import SwiftUI
class InscriptionViewModel: ObservableObject{
    @Published var state = InscriptionState()
    @Published public var festival: Festival? = nil
    private var zonesBenevoles : [ZoneBenevole]? = []
    private var inscriptionIntent: InscriptionIntent?
    @Published var poste:[Poste]? = []
    private var employers: [Employer]? = []
    private var inscription: [Inscription]? = []
    let creneaux: [String] = ["09-11", "11-14", "14-17", "17-20", "20-22"]
    var jours: [String] {
            guard let startDate = festival?.dateDebut,
                  let endDate = festival?.dateFin
        else {
                return []
            }
            return joursEntreDeuxDates(startDate: startDate, endDate: endDate)
        }
    
    private func joursEntreDeuxDates(startDate: Date, endDate: Date) -> [String] {
    var days: [String] = []
    var currentDate = startDate
        let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    
    while currentDate <= endDate {
        days.append(dateFormatter.string(from: currentDate))
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
        return days
    }
    
    struct ZoneBenevole: Codable {
        let idZoneBenevole: Int
        let nomZoneBenevole: String
        let capacite: Int
        let idFestival: Int
        let idPoste: Int
    }
    
    func send(intent: InscriptionIntent){
        self.inscriptionIntent = intent
        
        switch intent{
        case .fetchDataInscription:
            getEmployers()
        case .sinscrire:
            sinscrire()
            
        }
    }
    
    private func getCapacite(){
        guard let url = URL(string: "https://awi-api-2.onrender.com/volunteer-area-module") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let zonesBenevoles = try decoder.decode([ZoneBenevole].self, from: data)
                
                let festivalID = UserDefaults.standard.integer(forKey: "festivalID")
                self.zonesBenevoles = zonesBenevoles.filter { $0.idFestival == festivalID }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            //print("ZoneBenevole : \(self.zonesBenevoles)")
            self.getAllInscriptionByIdpost(idPostes: 5)
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
                    self.poste?.removeAll()

                    // Ajoute les éléments décodés à self.state.poste
                    for item in decodedPostes {
                        if self.employers!.contains(where: { $0.idPoste == item.idPoste }) {
                            self.poste?.append(item)
                        }
                    }
                    print("Post : \(self.poste)")
                    self.getAllInscription()
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
        print("Festivale in getEmployers \(festivale)")

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
                        self.festival = decodedFestival
                        //print("Festivale \(self.festival)")
                    }
                }
                catch {
                    print("Error decoding: \(error)")
                }
            }
            festivalTask.resume()
        
        guard let url = URL(string: "https://awi-api-2.onrender.com/employer-module/festival/\(festivale)") else {
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
                    self.employers?.removeAll()

                    // Ajoute les éléments décodés à self.state.employers
                    for item in decodedEmployers {
                        if(item.idFestival == festivale){
                            self.employers?.append(item)
                        }
                        
                    }
                    print("employers : \(self.employers)")
                    self.getPostes()
                }
            }
            catch {
                print("Error decoding: \(error)")
            }
        }
        task.resume()
    }
    
    private func getAllInscription(){
        let idbenevole = UserDefaults.standard.integer(forKey: "userId")
        print("idbenevole : \(idbenevole)")
        guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module")else
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
                        if ((self.poste?.contains(where: { $0.idPoste == item.idPoste })) != nil) {
                            self.inscription?.append(item)
                        }
                    }
                    //print("inscription : \(self.inscription)")
                    //debugPrint("festival=\(self.festival?.nomFestival)")
                    self.getCapacite()
                }
            }
            catch{
                print("Error decoding : \(error)")
            }
            
        }
        task.resume()
    }
    
    public func getAllInscriptionByIdpost(idPostes: Int) -> [String: [(String, Int, Int)]] {
        var inscriptionDict: [String: [(String, Int, Int)]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Regrouper les inscriptions par jour et par idPoste
        let inscriptionsByDay = Dictionary(grouping: self.inscription?.filter({ $0.idPoste == idPostes }) ?? [], by: { $0.Jour })
        //print("inscriptionByDay\(inscriptionsByDay)")
        //print("self.jours\(self.jours)")
        
       

        // Parcourir les jours et créer les tableaux de créneaux avec le nombre d'inscrits et la capacité
       /* for (jourString, inscriptions) in inscriptionsByDay {
            
           // print("JourString \(jourString)")
            //print("Inscriptions \(inscriptions)")
            
            // Créer un nouveau formateur de date à chaque itération
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = dateFormatter.date(from: jourString) {
                // Réinitialiser le formateur pour formater la date différemment
                dateFormatter.dateFormat = "dd MMM"
                let formattedDate = dateFormatter.string(from: date)
                print("Formatted Date \(formattedDate)")
                
                var creneaux: [(String, Int, Int)] = []
                
                // Parcourir les créneaux pour le jour donné
                for timeSlot in self.creneaux {
                    let nbInscrits = inscriptions.filter({ $0.Creneau == timeSlot }).count
                    let capacite = self.zonesBenevoles?.filter({ $0.idPoste == idPostes }).first?.capacite ?? 0
                    let creneau = (timeSlot, nbInscrits, capacite)
                    creneaux.append(creneau)
                }
                
                // Ajouter les créneaux au dictionnaire
                inscriptionDict[formattedDate] = creneaux
            }*/
        
        
        
        
        for (jourString, inscriptions) in inscriptionsByDay {
             
            // print("JourString \(jourString)")
             //print("Inscriptions \(inscriptions)")
             
             // Créer un nouveau formateur de date à chaque itération
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
             dateFormatter.locale = Locale(identifier: "en_US_POSIX")
             
            if let date = dateFormatter.date(from: jourString) {
                // Réinitialiser le formateur pour formater la date différemment
                dateFormatter.dateFormat = "dd MMM"
                let formattedDate = dateFormatter.string(from: date)
                print("Formatted Date \(formattedDate)")
                
                var creneaux: [(String, Int, Int)] = []
                
                // Parcourir les créneaux pour le jour donné
                for timeSlot in self.creneaux {
                    let nbInscrits = inscriptions.filter({ $0.Creneau == timeSlot }).count
                    let capacite = self.zonesBenevoles?.filter({ $0.idPoste == idPostes }).first?.capacite ?? 0
                    let creneau = (timeSlot, nbInscrits, capacite)
                    creneaux.append(creneau)
                }
                
                // Ajouter les créneaux au dictionnaire
                inscriptionDict[formattedDate] = creneaux
            }
        }
        // Vérifier que inscriptionDict contient tous les jours de self.jours et ajouter les jours manquants avec les créneaux
        for jour in self.jours {
                if inscriptionDict[jour, default: []].isEmpty {
                    print("jour\(jour)")
                    var creneaux: [(String, Int, Int)] = []

                    // Ajouter tous les créneaux avec 0 inscrit pour ce jour manquant
                    for timeSlot in self.creneaux {
                        let nbInscrits = 0
                        let capacite = 5
                        let creneau = (timeSlot, nbInscrits, capacite)
                        creneaux.append(creneau)
                    }

                    inscriptionDict[jour] = creneaux
                }
        }

        
        
        
        
        
            print("Liste des inscription by id and day  \(inscriptionDict)")
            return inscriptionDict
        
    }
    
    
    private func getInscriptionDictionary() -> [String: [(String, Int, Int)]] {
        var inscriptionDict: [String: [(String, Int, Int)]] = [:]

        // Regrouper les inscriptions par jour
        let inscriptionsByDay = Dictionary(grouping: self.inscription ?? [], by: { $0.Jour })

        // Parcourir les jours et créer les tableaux de créneaux avec le nombre d'inscrits et la capacité
        for (day, inscriptions) in inscriptionsByDay {
            var creneaux: [(String, Int, Int)] = []

            // Parcourir les créneaux pour le jour donné
            for timeSlot in self.creneaux {
                let nbInscrits = inscriptions.filter({ $0.Creneau == timeSlot }).count
                let capacite = self.zonesBenevoles?.filter({ $0.idPoste == inscriptions[0].idPoste }).first?.capacite ?? 0
                creneaux.append((timeSlot, nbInscrits, capacite))
            }

            // Ajouter les créneaux au dictionnaire
            inscriptionDict[day] = creneaux
        }
        print("Liste des inscription \(inscriptionDict)")
        return inscriptionDict
    }
    
    public func sinscrire() {
        guard let idBenevole = UserDefaults.standard.integer(forKey: "userId")  as? Int,
              let idZoneBenevole = self.state.idBenevole  as? Int ,
              let idPoste = self.state.idPoste
        else {
            print("Erreur : ID manquant")
            return
        }

        let body: [String: Any?] = [
            "idBenevole": idBenevole,
            "idZoneBenevole": idZoneBenevole,
            "idPoste": idPoste,
            "Creneau": self.state.Creneau ,
            "Jour": self.state.Jour,
            "isPresent": false
        ]
        
        
        guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { (response, request, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 201 else {
                print("Error: Invalid response")
                return
            }

            DispatchQueue.main.async {
                // Mettre à jour l'état de la vue si nécessaire
                print("Inscription réussie")
            }
        }
        task.resume()
    }


    public func sinscrireflexible(postes: [Poste]) {
        for poste in postes {
            guard let idBenevole = UserDefaults.standard.integer(forKey: "userId") as? Int
            else {
                print("Erreur : ID manquant")
                return
            }

            let body: [String: Any?] = [
                "idBenevole": idBenevole,
                "idZoneBenevole": nil,
                "idPoste": poste.idPoste,
                "Creneau": self.state.Creneau,
                "Jour": self.state.Jour,
                "isPresent": false
            ]

            guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let task = URLSession.shared.dataTask(with: request) { (response, request, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 201 else {
                    print("Error: Invalid response")
                    return
                }

                DispatchQueue.main.async {
                    // Mettre à jour l'état de la vue si nécessaire
                    print("Inscription réussie pour le poste \(poste.nomPoste)")
                }
            }
            task.resume()
        }
    }

    
    
        

        
    
    
}

