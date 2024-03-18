import SwiftUI

import Foundation

class LoginModel {
    let userManager = UserManager()
    
    private struct UserResponse: Codable {
        let data: UserData
    }
    
    private struct UserData: Codable {
        let token: String
        let id: Int
        let email: String
        let role: String
        let pseudo: String
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/signin") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
            return
        }
        
        let parameters: [String: Any] = [
            "Email": email,
            "Password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide du serveur"])))
                return
            }
            
            if let data = data {
                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    let userData = userResponse.data
                    // Stockez les informations de l'utilisateur ici
                    self.userManager.login(userId: String(userData.id), email: userData.email, pseudo: userData.pseudo, role: userData.role, token: userData.token)
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Pas de données dans la réponse"])))
            }
        }
        
        task.resume()
    }
    
    func register(pseudo: String, email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/signup") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
            return
        }
        
        let parameters: [String: Any] = [
            "Pseudo": pseudo,
            "Email": email,
            "Password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide du serveur"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Traiter la réponse réussie ici, par exemple, enregistrer le jeton d'authentification.
                // Pour l'instant, nous supposons simplement que l'inscription a réussi.
                completion(.success(true))
            } else {
                // Traiter la réponse d'échec ici
                if let data = data, let errorMessage = self.errorMessage(from: data) {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Réponse invalide du serveur"])))
                }
            }
        }
        
        task.resume()
    }
    
    private func errorMessage(from data: Data) -> String? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let error = json["error"] as? String {
                return error
            }
        } catch {
            print("Failed to parse error message: \(error)")
        }
        
        return nil
    }
}
