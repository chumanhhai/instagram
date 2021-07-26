//
//  AuthenTextField.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit

class AuthenTextField: UITextField {

    let height: CGFloat = 50
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 1, alpha: 0.1) // set background color
        textColor = .white // set text color
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]) // set placeholder
        setHeight(height: height) // set height
        keyboardAppearance = .dark // set keyboard theme
        
        // set padding
        let leftPadding = UIView()
        leftPadding.setDimensions(height: height, width: 20)
        leftView = leftPadding
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
