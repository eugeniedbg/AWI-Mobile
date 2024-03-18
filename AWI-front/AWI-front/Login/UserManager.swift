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
        self.isLoggedIn = UserDefaults.standard.bool(forKey: keyPrefix + "isLoggedIn")
        self.userId = UserDefaults.standard.string(forKey: keyPrefix + "userId") ?? ""
        self.email = UserDefaults.standard.string(forKey: keyPrefix + "email") ?? ""
        self.pseudo = UserDefaults.standard.string(forKey: keyPrefix + "pseudo") ?? ""
        self.role = UserDefaults.standard.string(forKey: keyPrefix + "role") ?? ""
        self.token = UserDefaults.standard.string(forKey: keyPrefix + "token") ?? ""
    }
    
    func login(userId: String, email: String, pseudo: String, role: String, token: String) {
        self.userId = userId
        self.email = email
        self.pseudo = pseudo
        self.role = role
        self.token = token
        self.isLoggedIn = true
        
        UserDefaults.standard.set(true, forKey: keyPrefix + "isLoggedIn")
        UserDefaults.standard.set(userId, forKey: keyPrefix + "userId")
        UserDefaults.standard.set(email, forKey: keyPrefix + "email")
        UserDefaults.standard.set(pseudo, forKey: keyPrefix + "pseudo")
        UserDefaults.standard.set(role, forKey: keyPrefix + "role")
        UserDefaults.standard.set(token, forKey: keyPrefix + "token")
    }
    
    func logout() {
        self.isLoggedIn = false
        self.userId = ""
        self.email = ""
        self.pseudo = ""
        self.role = ""
        self.token = ""
        
        UserDefaults.standard.set(false, forKey: keyPrefix + "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: keyPrefix + "userId")
        UserDefaults.standard.set(nil, forKey: keyPrefix + "email")
        UserDefaults.standard.set(nil, forKey: keyPrefix + "pseudo")
        UserDefaults.standard.set(nil, forKey: keyPrefix + "role")
        UserDefaults.standard.set(nil, forKey: keyPrefix + "token")
    }
}
