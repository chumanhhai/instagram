//
//  CommentCell.swift
//  Instagram
//
//  Created by Hải Chu on 23/07/2021.
//

import UIKit
import SDWebImage

protocol CommentCellDelegate: AnyObject {
    func showOwnerForComment (_ owner: Owner)
}

class CommentCell: UITableViewCell {
    
    weak var delegate: CommentCellDelegate?
    
    var comment: Comment? {
        didSet {
            configure()
        }
    }
    
    let profileImage: UIImageView = {
        let size: CGFloat = 50
        let imageView = UIImageView()
        imageView.setDimensions(height: size, width: size)
        imageView.layer.cornerRadius = size / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapNameButton), for: .touchUpInside)
        return button
    }()
    
    let commentText: UILabel = {
        let lb = UILabel()
//        lb.text = "I am the Venom mother fucker I am the Venom mother fucker I am the Venom mother fucker"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add profile image
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 14, paddingLeft: 12)
        profileImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -14).isActive = true
        
        // add name label
        addSubview(nameButton)
        nameButton.anchor(top: topAnchor, left: profileImage.rightAnchor, paddingTop: 10, paddingLeft: 10)
        
        // add commentText
        addSubview(commentText)
        commentText.anchor(top: nameButton.bottomAnchor, left: nameButton.leftAnchor, right: rightAnchor, paddingRight: 12)
        commentText.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -14).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func didTapNameButton() {
        guard let comment = comment else {return}
        delegate?.showOwnerForComment(comment.owner)
    }
    
    // MARK: - Functions
    func configure() {
        guard let comment = comment else {return}
        profileImage.sd_setImage(with: URL(string: comment.owner.imageUrl))
        nameButton.setTitle(comment.owner.nickname, for: .normal)
        commentText.text = comment.content
    }
}
