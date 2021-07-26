//
//  AuthenSubmitButton.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit

class AuthenSubmitButton: UIButton {
    
    let height: CGFloat = 50
    
    init(title: String) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        tintColor = UIColor(white: 1, alpha: 0.8)
        setTitle(title, for: .normal)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
