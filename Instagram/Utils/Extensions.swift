//
//  Extensions.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit
import JGProgressHUD


// MARK: - UIViewController
extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func createSpinner() -> JGProgressHUD {
        let hub = JGProgressHUD(style: .dark)
        hub.show(in: self.view)
        return hub
    }
}

// MARK: - UIView
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?=nil, left: NSLayoutXAxisAnchor?=nil,
                bottom: NSLayoutYAxisAnchor?=nil, right: NSLayoutXAxisAnchor?=nil,
                paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
    }
    
    func center(inView: UIView, xConstant: CGFloat = 0, yConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: inView.centerXAnchor, constant: xConstant).isActive = true
        centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: yConstant).isActive = true
    }
    
    func centerX(centerX: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor?=nil, bottom: NSLayoutYAxisAnchor?=nil,
                 paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: centerX).isActive = true
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
    }
    
    func centerY(centerY: NSLayoutYAxisAnchor, left: NSLayoutXAxisAnchor?=nil, right: NSLayoutXAxisAnchor?=nil,
                 paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: centerY).isActive = true
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(top: superview?.topAnchor, left: superview?.leftAnchor, bottom: superview?.bottomAnchor, right: superview?.rightAnchor)
    }
}
