import SwiftUI

import Foundation

enum LoginIntent {
    case login(email: String, password: String)
    case register(pseudo: String, email: String, password: String, passwordConfirmation: String)
    case emailChanged(String)
    case passwordChanged(String)
    case toggleRegistration
}
