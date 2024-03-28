//
//  ProfileViewModel.swift
//  AWI-Mobile
//
//  Created by Thomas Coulon on 18/03/2024.
//

import Foundation


class ProfileViewModel: ObservableObject {
    @Published public var state = ProfileState()
    @Published public var profile: Profile? = nil
    private var profileIntent: ProfileIntent?
    private var idBenevole = UserDefaults.standard.integer(forKey: "userId")

    func send(intent: ProfileIntent) {
        self.profileIntent = intent

        switch intent {
        case .fetchDataProfil:
            getDataProfil()
        case .putDataProfil:
            getDataProfil()
        }
    }

    private func getDataProfil() {
        print("Idbenevole in profil\(idBenevole)")
        print("self.profile : \(self.profile)")
        guard let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/\(idBenevole)") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let profileData = try decoder.decode(Profile.self, from: data)
               // print("Data : \(profileData)")
                
                                    self.state.profile = profileData
                self.profile = self.state.profile
                                print("Data : \(self.state.profile)")
                    
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
        
    }
}



