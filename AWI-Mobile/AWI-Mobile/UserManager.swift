import SwiftUI
import Foundation

class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userId: String = ""
    @Published var email: String = ""
    @Published var pseudo: String = ""
    @Published var role: String = ""
    @Published var token: String = ""
    
    private let keyPrefix = "UserManager."
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        self.email = UserDefaults.standard.string(forKey:  "email") ?? ""
        self.pseudo = UserDefaults.standard.string(forKey:  "pseudo") ?? ""
        self.role = UserDefaults.standard.string(forKey:  "role") ?? ""
        self.token = UserDefaults.standard.string(forKey:  "token") ?? ""
    }
    
    func login(userId: String, email: String, pseudo: String, role: String, token: String) {
        self.userId = userId
        self.email = email
        self.pseudo = pseudo
        self.role = role
        self.token = token
        self.isLoggedIn = true
        
        UserDefaults.standard.set(true, forKey:  "isLoggedIn")
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.set(email, forKey:  "email")
        UserDefaults.standard.set(pseudo, forKey:  "pseudo")
        UserDefaults.standard.set(role, forKey:  "role")
        UserDefaults.standard.set(token, forKey:  "token")
    }
    
    func logout() {
        self.isLoggedIn = false
        self.userId = ""
        self.email = ""
        self.pseudo = ""
        self.role = ""
        self.token = ""
        
        UserDefaults.standard.set(false, forKey:   "isLoggedIn")
        UserDefaults.standard.set(nil, forKey:  "userId")
        UserDefaults.standard.set(nil, forKey:  "email")
        UserDefaults.standard.set(nil, forKey:  "pseudo")
        UserDefaults.standard.set(nil, forKey:  "role")
        UserDefaults.standard.set(nil, forKey:  "token")
    }
}
