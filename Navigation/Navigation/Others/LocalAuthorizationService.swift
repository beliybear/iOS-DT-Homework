//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Beliy.Bear on 27.06.2023.
//

import Foundation
import LocalAuthentication

class LocalAuthorizationService {
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization") { (success, error) in
                DispatchQueue.main.async {
                    authorizationFinished(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                authorizationFinished(false)
            }
        }
    }
}
