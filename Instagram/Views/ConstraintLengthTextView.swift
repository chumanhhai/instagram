//
//  ContraintLengthTextField.swift
//  Instagram
//
//  Created by Hải Chu on 20/07/2021.
//

import UIKit

class ConstraintLengthTextView: UITextView {
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder!
        }
    }
    
    var maxLength: Int = 100
    
    let placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.systemGray
        return lb
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // FOR THE HEIGHT OF TEXTVIEW COULD BE DYNAMIC BASED OF TEXT INSIDE
        isScrollEnabled = false
        
        // set default font
        font = UIFont.systemFont(ofSize: 16)
        
        // add placeholder
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 7)
        
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func textDidChanged() {
        placeholderLabel.isHidden = !text.isEmpty
        if(text.count > maxLength) {
            deleteBackward()
        }
    }
}
