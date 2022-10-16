import Foundation

//WIP
public struct CredentialChecker: Equatable {
    static func checkEmail(email: String) -> Bool {
        email.count > 5 && email.contains("@")
        }
        
    static func checkPassword(password: String) -> Bool {
        password.count > 5
        }
    
    static func disableButton(email: String, password: String) -> Bool {
        !checkEmail(email: email) || !checkPassword(password: password)
        }
    }
