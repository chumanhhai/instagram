//
//  SignUpController.swift
//  Instagram
//
//  Created by Hải Chu on 14/07/2021.
//

import UIKit

class SignUpController: AuthenController {
    lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "person.fill.viewfinder"), for: .normal)
        button.setDimensions(height: 140, width: 140)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 140/2
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlusPhotoButton), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let nameTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Name")
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let nicknameTextField: AuthenTextField = {
        let tf = AuthenTextField(placeholder: "Nick Name")
        tf.addTarget(self, action: #selector(didEditText), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: AuthenSubmitButton = {
        let button = AuthenSubmitButton(title: "Sign Up")
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    lazy var alreadyHaveAccountButton: AuthenOptionButton = {
        let button = AuthenOptionButton(firstText: "Already have an account?", secondText: "Log In")
        button.addTarget(self, action: #selector(didTapAlreadyHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create authen view model
        authenViewModel = SignUpViewModel()
        
        // add plus button
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(centerX: view.centerXAnchor, top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        // add form
        let form = createFormContainer()
        view.addSubview(form)
        form.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        // add login option
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(centerX: view.centerXAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      paddingBottom: 0)
    }
    
    // MARK: - Functions
    func createFormContainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameTextField, nicknameTextField, signUpButton])
        container.axis = .vertical
        container.spacing = 20
        return container
    }
    
    // MARK: - Actions
    @objc func didTapPlusPhotoButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapAlreadyHaveAccountButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didEditText(sender: UITextField) {
        guard let authenViewModel = authenViewModel else {return}
        
        if(sender == emailTextField) {
            authenViewModel.email = emailTextField.text
        } else if(sender == passwordTextField) {
            authenViewModel.password = passwordTextField.text
        } else if(sender == nameTextField) {
            (authenViewModel as! SignUpViewModel).name = nameTextField.text
        } else {
            (authenViewModel as! SignUpViewModel).nickname = nicknameTextField.text
        }
        updateSubmitButton(button: signUpButton)
    }
    
    @objc func didTapSignInButton() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let nickname = nicknameTextField.text!
        let image = plusPhotoButton.imageView!.image!
        
        let credential = Credential(name: name, email: email, password: password, image: image, nickname: nickname)
        AuthenService.register(credential: credential) { error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            // success
            self.presentingViewController!
                .presentingViewController!
                .dismiss(animated: true, completion: nil)
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        (authenViewModel as! SignUpViewModel).image = selectedImage
        updateSubmitButton(button: signUpButton)
    
        dismiss(animated: true, completion: nil)
    }
}

