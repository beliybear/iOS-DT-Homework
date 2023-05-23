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
            return NSLocalizedString("Похоже, вы оставили поле Email или Password пустым",
                                     comment: "")
        case .invalidPassword:
            return NSLocalizedString("Неверный email или пароль",
                                     comment: "")
        case .weakPassword:
            return NSLocalizedString("Пароль состоит менее чем из 6 символов",
                                     comment: "")
        case .mismatchPassword:
            return NSLocalizedString("Введенные пароли не совпадают",
                                     comment: "")
        case .notFound:
            return NSLocalizedString("Error Description: The specified item could not be found.",
                                     comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("Такой email уже используется",
                                     comment: "")
        case .invalidEmail:
            return NSLocalizedString("Неверно введен email",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("Что-то пошло не так",
                                     comment: "")
        }
    }
}
