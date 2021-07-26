//
//  AuthenOptionButton.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit

class AuthenOptionButton: UIButton {
    
    init(firstText: String, secondText: String) {
        super.init(frame: .zero)
        
        let regulartAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                           .foregroundColor: UIColor(white: 1, alpha: 0.87)]
        let boldAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14),
                                                       .foregroundColor: UIColor(white: 1, alpha: 0.87)]
        let title = NSMutableAttributedString(string: firstText, attributes: regulartAttr)
        title.append(NSAttributedString(string: " \(secondText)", attributes: boldAttr))
        
        setAttributedTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
