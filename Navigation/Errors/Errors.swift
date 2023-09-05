//
//  Error.swift
//  Navigation
//
//  Created by Ian Belyakov on 07.08.2023
//

import Foundation

enum AutorizationErrors: Error {
    case empty
    case invalidPassword
    case weakPassword
    case mismatchPassword
    case notFound
    case emailAlreadyInUse
    case invalidEmail
    case unexpected
    case autorization
}

extension AutorizationErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return NSLocalizedString("empty-autorizationError-localizable",
                                     comment: "")
        case .invalidPassword:
            return NSLocalizedString("invalidPassword-autorizationError-localizable",
                                     comment: "")
        case .weakPassword:
            return NSLocalizedString("weakPassword-autorizationError-localizable",
                                     comment: "")
        case .mismatchPassword:
            return NSLocalizedString("mismatchPassword-autorizationError-localizable",
                                     comment: "")
        case .notFound:
            return NSLocalizedString("notFound-autorizationError-localizable",
                                     comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("emailAlreadyInUse-autorizationError-localizable",
                                     comment: "")
        case .invalidEmail:
            return NSLocalizedString("invalidEmail-autorizationError-localizable",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("unexpected-autorizationError-localizable",
                                     comment: "")
        case .autorization:
            return NSLocalizedString("autorization-autorizationError-localizable", comment: "")
        }
    }
}

enum ImagesError: Error {
    case badURL
    case unexpected
}

//
//return NSLocalizedString("Похоже, вы оставили пустое поле",
//                         comment: "")
//case .invalidPassword:
//return NSLocalizedString("Не верный email или пароль",
//                         comment: "")
//case .weakPassword:
//return NSLocalizedString("Пароль состоит менее чем из 6 символов",
//                         comment: "")
//case .mismatchPassword:
//return NSLocalizedString("Введенные пароли не совпадают",
//                         comment: "")
//case .notFound:
//return NSLocalizedString("Error Description: The specified item could not be found.",
//                         comment: "")
//case .emailAlreadyInUse:
//return NSLocalizedString("Такой email уже используется",
//                         comment: "")
//case .invalidEmail:
//return NSLocalizedString("Неверно введен email",
//                         comment: "")
//case .unexpected:
//return NSLocalizedString("Что то пошло не так",
//                         comment: "")
//case .autorization:
//return NSLocalizedString("Пожалуйста авторизируйтесь", comment: "")
//}
//}
