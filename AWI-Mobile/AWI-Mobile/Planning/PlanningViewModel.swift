//
//  PlanningViewModel.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject{
    @Published var state = PlanningState()
    
    
    
    
    public func getInscription(){
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
                    print("isncription : \(self.state.inscription)")
                }
            }
            catch{
                print("Error decoding : \(error)")
            }
            
        }
        task.resume()
    }
    
    public func getPostes() {
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
    
    public func getEmployers() {
        /*let festivale = UserDefaults.standard.integer(forKey: "festivalID")

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
            festivalTask.resume()*/

        
        
        

        
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
    
    public func getPlanning(){
        self.getEmployers()
        self.getPostes()
        self.getInscription()
    }


    
}
