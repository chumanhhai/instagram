//
//  AuthenViewModel.swift
//  Instagram
//
//  Created by Hải Chu on 14/07/2021.
//

import UIKit

// MARK: - Authen View Model
class AuthenViewModel {
    var email: String? = nil
    var password: String? = nil
    
    func isFormValid() -> Bool {
        return (email?.contains("@") ?? false) && ((password?.count ?? 0) >= 6)
    }
    
    func getSubmitButtonBgColor() -> UIColor {
        return isFormValid() ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).withAlphaComponent(0.87) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.87)
    }
    
    func getSubmitButtonTitleColor() -> UIColor {
        return isFormValid() ? .white : UIColor(white: 1, alpha: 0.8)
    }
}

// MARK: - Login View Model
class LoginViewModel: AuthenViewModel {}

// MARK: - SignUp View Model
class SignUpViewModel: AuthenViewModel {
    var name: String? = nil
    var image: UIImage? = nil
    var nickname: String? = nil
    
    override func isFormValid() -> Bool {
        return super.isFormValid() && !(name?.isEmpty ?? true) && (image != nil) && (nickname != nil)
    }
}
