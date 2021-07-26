//
//  LoginController.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit

class LoginController: AuthenController {
    let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Instagram"
        label.textColor = .white
        label.font = UIFont(name: "OleoScript-Regular", size: 52)
        return label
    }()
    
    let emailTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress // set keyboard type
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let LogInButton: AuthenSubmitButton = {
        let button = AuthenSubmitButton(title: "Log In")
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: AuthenOptionButton = {
        let button = AuthenOptionButton(firstText: "Forgot your password?", secondText: "Get Help")
        return button
    }()
    
    lazy var dontHaveAccountButton: AuthenOptionButton = {
        let button = AuthenOptionButton(firstText: "Do not have account?", secondText: "Sign Up")
        button.addTarget(self, action: #selector(didTapDontHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        // create authen view model
        authenViewModel = LoginViewModel()
        
        // add header
        view.addSubview(headerLabel)
        headerLabel.centerX(centerX: view.centerXAnchor, top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        // add form
        let formContainer = createFormContrainer()
        view.addSubview(formContainer)
        formContainer.anchor(top: headerLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        // add sign in option
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(centerX: view.centerXAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      paddingBottom: 0) 
        
    }
    
    // MARK: - Functions
    func createFormContrainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, LogInButton,
            forgotPasswordButton])
        
        container.axis = .vertical
        container.spacing = 20
        return container
    }
    
    // MARK: - Actions
    @objc func didTapDontHaveAccountButton() {
        let vc = SignUpController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didEditText(sender: UITextField) {
        guard let authenViewModel = authenViewModel else { return }
        
        if(sender == emailTextField) {
            authenViewModel.email = emailTextField.text
        } else {
            authenViewModel.password = passwordTextField.text
        }
        updateSubmitButton(button: LogInButton)
    }
    
    @objc func didTapLoginButton() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        AuthenService.login(email: email, password: password) { error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            // if success
            self.dismiss(animated: true, completion: nil)
        }
    }
}
