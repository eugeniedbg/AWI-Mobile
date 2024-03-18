import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var pseudo = ""
    @Published var passwordConfirmation = ""
    @Published var isRegistering = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isLoggedIn = false
    @Published var userManager = UserManager()
    
    var loginModel: LoginModel
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.loginModel = LoginModel()
    }
    
    func send(intent: LoginIntent) {
        switch intent {
        case .login(let email, let password):
            loginModel.login(email: email, password: password) { [weak self] result in
                switch result {
                case .success:
                    // Handle successful login
                    DispatchQueue.main.async {
                        self?.isLoggedIn = true
                    }
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        case .register(let pseudo, let email, let password1, let password2):
            if password1 != password2 {
                self.alertMessage = "Les mots de passe ne correspondent pas."
                self.showAlert = true
            } else {
                loginModel.register(pseudo: pseudo, email: email, password: password1) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self?.isRegistering = false
                        case .failure(let error as NSError):
                            if error.code == 409 {
                                self?.alertMessage = "Cette adresse e-mail est déjà utilisée."
                            } else {
                                self?.alertMessage = "Une erreur s'est produite. Veuillez réessayer."
                            }
                            self?.showAlert = true
                        }
                    }
                }
            }
        
        case .emailChanged(let email):
            self.email = email
        case .passwordChanged(let password):
            self.password = password
        case .toggleRegistration:
            isRegistering.toggle()
        }
    }
}
