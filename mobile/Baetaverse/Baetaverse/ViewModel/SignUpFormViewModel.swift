//
//  SignUpFormViewModel.swift
//  Baetaverse
//
//  Created by JeongTaek Han on 2022/05/13.
//

import Foundation
import UIKit.UIApplication

final class SignUpFormViewModel {
    
    private var appService: AppService? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.appService
    }
    
    func signUp(email: String, password: String, name: String, phoneNumber: String) async throws {
        try await appService?.signUp(
            email: email,
            password: password,
            name: name,
            phoneNumber: phoneNumber
        )
    }
    
}