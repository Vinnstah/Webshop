import Foundation

public func checkIfPasswordFulfillsRequirements(_ password: String) -> Bool {
    guard password.count > 5 &&
            password.contains(where: { $0.isUppercase }) &&
            password.contains(where: { !$0.isLetter })
    else {
        return false
    }
    return true
}

public func checkIfEmailFullfillRequirements(_ email: String) -> Bool {
    let regex = #/^\S+@\S+\.\S+$/#
    if email.firstMatch(of: regex) != nil {
        return true
    }
    return false
}
