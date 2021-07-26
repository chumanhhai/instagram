//
//  AuthenController.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit

class AuthenController: UIViewController {
    
    var authenViewModel: AuthenViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true // hide the nav bar
        navigationController?.navigationBar.barStyle = .black
        
        // set gradient
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: - Functions
    func updateSubmitButton(button: UIButton) {
        guard let authenViewModel = authenViewModel else { return }
        
        button.backgroundColor = authenViewModel.getSubmitButtonBgColor()
        button.setTitleColor(authenViewModel.getSubmitButtonTitleColor(), for: .normal)
        if(authenViewModel.isFormValid()) {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }

}
