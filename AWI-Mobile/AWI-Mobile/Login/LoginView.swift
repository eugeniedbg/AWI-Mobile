import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {            
            if viewModel.isLoggedIn {
                BlueBackgroundView(viewModel: viewModel, userId: viewModel.userManager.userId, email: viewModel.userManager.email, pseudo: viewModel.userManager.pseudo, role: viewModel.userManager.role)
            } else {
                ScrollView {
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 10)
                        
                        
                        Text(viewModel.isRegistering ? "Register" : "Login")
                            .font(.largeTitle)
                            .padding()
                        
                        if viewModel.isRegistering {
                            Group {
                                TextField("Pseudo", text: $viewModel.pseudo)
                                    .padding()
                                TextField("Email", text: $viewModel.email)
                                    .padding()
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                SecureField("Mot de passe", text: $viewModel.password)
                                    .padding()
                                SecureField("Confirmation Mot de passe", text: $viewModel.passwordConfirmation)
                                    .padding()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            
                            Button(action: {
                                self.viewModel.send(intent: .register(pseudo: self.viewModel.pseudo, email: self.viewModel.email, password: self.viewModel.password, passwordConfirmation: self.viewModel.passwordConfirmation))
                            }) {
                                Text("Register")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        } else {
                            Group {
                                TextField("Email", text: $viewModel.email)
                                    .padding()
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                SecureField("Password", text: $viewModel.password)
                                    .padding()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            
                            Button(action: {
                                self.viewModel.send(intent: .login(email: self.viewModel.email, password: self.viewModel.password))
                                
                            }) {
                                Text(viewModel.isRegistering ? "Register" : "Login")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                            
                        }
                        Button(action: {
                            self.viewModel.send(intent: .toggleRegistration)
                        }) {
                            Text(viewModel.isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                                .padding()
                        }
                        Spacer()
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Erreur"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

