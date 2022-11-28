import Foundation

public func checkIfPasswordFulfillsRequirements(_ password: String) -> PasswordChecker {
    guard password.count > 5 else {
        return .invalid(.atLeast5CharactersLong)
    }
    guard password.contains(where: { $0.isUppercase }) else {
        return .invalid(.atLeast1CapitalizedLetter)
    }
    guard password.contains(where: { !$0.isLetter }) else {
        return .invalid(.atLeast1SpecialCharactere)
    }
    return .valid
}

public enum PasswordChecker: Equatable, Sendable, Identifiable {
    
    case valid
    case invalid(InvalidPasswordError)
    
    public var rawValue: String {
        switch self {
        case .valid:
            return "Valid Password"
        case .invalid(.atLeast1CapitalizedLetter):
            return "Password must contains one capitalized letter"
        case .invalid(.atLeast1SpecialCharactere):
            return "Password must contains one special character"
        case .invalid(.atLeast5CharactersLong):
            return "Password must be at least 5 characters long"
        }
    }
    
    public var id: String {
        return self.rawValue
    }
    
    public enum InvalidPasswordError: Equatable, Sendable {
        
        case atLeast1SpecialCharactere
        case atLeast1CapitalizedLetter
        case atLeast5CharactersLong
    }
}
    
    public func checkIfEmailFullfillRequirements(_ email: String) -> EmailCheckerResult {
        let regex = #/^\S+@\S+\.\S+$/#
        if email.firstMatch(of: regex) != nil {
            return .valid
        }
        guard email.contains(where: { $0 == "@"}) else {
            return .invalid(.missingAtSymbol)
        }
        
        guard email.contains(#/\.\S+$/#) else {
            return .invalid(.missingDomain)
        }
        return .invalid(.invalidCharacters)
    }
    
    public enum EmailCheckerResult: Equatable, Sendable, Identifiable {
        
        case valid
        case invalid(InvalidEmailError)
        
        public var rawValue: String {
            switch self {
            case .valid:
                return "Valid Email"
            case .invalid(.invalidCharacters):
                return "Email contains invalid characters"
            case .invalid(.missingDomain):
                return "Missing domain"
            case .invalid(.missingAtSymbol):
                return "Missing @-symbol"
            }
        }
        
        public var id: String {
            return self.rawValue
        }
        
        public enum InvalidEmailError: Equatable, Sendable {
            
            case missingDomain
            case missingAtSymbol
            case invalidCharacters
        }
    }

//public func checkIfEmailFullfillRequirements(_ email: String) -> Swift.Result<EquatableVoid, InvalidEmailError> {
//    let regex = #/^\S+@\S+\.\S+$/#
//    if email.firstMatch(of: regex) != nil {
//        return .success(EquatableVoid())
//    }
//    guard email.contains(where: { $0 == "@"}) else {
//        return .failure(.missingAtSymbol)
//    }
//
//    guard email.contains(#/\.\S+$/#) else {
//        return .failure(.missingDomain)
//    }
//    return .failure(.invalidCharacters)
//}
//
//public enum InvalidEmailError: Error, Equatable, Sendable {
//
//    case missingDomain
//    case missingAtSymbol
//    case invalidCharacters
//
//    public var description: String {
//        switch self {
//        case .invalidCharacters:
//            return "Email contains invalid characters"
//        case .missingDomain:
//            return "Missing domain"
//        case .missingAtSymbol:
//            return "Missing @-symbol"
//        }
//    }
//}
//
//
//public struct EquatableVoid: Equatable {
// public init() {}
// public init(_ void: Void) {}
// public static func ==(lhs: Self, rhs: Self) -> Bool { true }
//}
