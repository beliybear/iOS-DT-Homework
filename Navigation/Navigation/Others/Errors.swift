//
//  Errors.swift
//  Navigation
//
//  Created by Beliy.Bear on 21.05.2023.
//

import Foundation

enum Authorization: Error {
    case emptyPasswordOrEmail
    case invalidPassword
    case weakPassword
    case mismatchPassword
    case notFound
    case emailAlreadyInUse
    case invalidEmail
    case unexpected
}

extension Authorization: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyPasswordOrEmail:
            return NSLocalizedString("Seems like you forgot to write Email or Password",
                                     comment: "")
        case .invalidPassword:
            return NSLocalizedString("Wrong Email or Password",
                                     comment: "")
        case .weakPassword:
            return NSLocalizedString("The password consists of less than 6 characters",
                                     comment: "")
        case .mismatchPassword:
            return NSLocalizedString("Passwords entered do not match",
                                     comment: "")
        case .notFound:
            return NSLocalizedString("Error Description: The specified item could not be found.",
                                     comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("Such email is already in use",
                                     comment: "")
        case .invalidEmail:
            return NSLocalizedString("Incorrect Email",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("Something went wrong",
                                     comment: "")
        }
    }
}
