//
//  UploadPostController.swift
//  Instagram
//
//  Created by Hải Chu on 20/07/2021.
//

import UIKit

protocol UploadPostControllerDelegate {
    func didFinishedUploadPost(newPost: Post)
}

class UploadPostController: UIViewController {
    var delegate: UploadPostControllerDelegate?
    
    var image: UIImage? {
        didSet {
            imageView.image = image!
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.setDimensions(height: 180, width: 180)
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    lazy var captionTextView: UITextView = {
        let tv = ConstraintLengthTextView()
        tv.placeholder = "Enter caption ..."
        tv.maxLength = 100
        tv.delegate = self
        return tv
    }()
    
    let constraintLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/500"
        lb.textColor = UIColor.systemGray
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configure()
        
        // add image view
        view.addSubview(imageView)
        imageView.centerX(centerX: view.centerXAnchor, top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        // add caption
        view.addSubview(captionTextView)
        captionTextView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 12, paddingRight: 12)
        
        // add constraint label
        view.addSubview(constraintLabel)
        constraintLabel.anchor(top: captionTextView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 12)
        
    }
    
    // MARK: - Functions
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapShareButton))
    }
    
    // MARK: - Actions
    @objc func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShareButton() {
        guard let image = image else {return}
        let spinner = createSpinner()
        PostService.uploadPost(image: image, caption: captionTextView.text) { post, error in
            spinner.dismiss()
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.delegate?.didFinishedUploadPost(newPost: post!)
            self.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        constraintLabel.text = "\(captionTextView.text.count)/500"
    }
}
