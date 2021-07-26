//
//  NotificationCell.swift
//  Instagram
//
//  Created by Hải Chu on 24/07/2021.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: AnyObject {
    func showNotificationMaker(makerUid: String)
}

class NotificationCell: UITableViewCell {
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    lazy var profileImage: UIImageView = {
        let size: CGFloat = 50
        let image = UIImageView()
        image.image = UIImage(named: "venom")
        image.setDimensions(height: size, width: size)
        image.clipsToBounds = true
        image.layer.cornerRadius = size/2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage)))
        return image
    }()
    
    lazy var notificationLabel: UILabel = {
        let lb = UILabel()
        lb.attributedText = createAttributedText(name: "venom", text: "likes your post.")
        lb.numberOfLines = 0
        return lb
    }()
    
    let postImage: UIImageView = {
        let size: CGFloat = 45
        let image = UIImageView()
        image.backgroundColor = .gray
        image.setDimensions(height: size, width: size)
        return image
    }()
    
    lazy var container: UIStackView = {
        let container = UIStackView(arrangedSubviews: [profileImage, notificationLabel, postImage])
        container.axis = .horizontal
        container.spacing = 10
        container.alignment = .center
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add container
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 12, paddingBottom: 14, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func createAttributedText(name: String, text: String) -> NSAttributedString {
        let name = name + " "
        let nameString = NSAttributedString(string: name, attributes: [.font: UIFont.boldSystemFont(ofSize: 13), .foregroundColor: UIColor.black])
        let textString = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.gray])
        let attributedString = NSMutableAttributedString(attributedString: nameString)
        attributedString.append(textString)
        return attributedString
    }
    
    func configure() {
        guard let notification = notification else {return}
        profileImage.sd_setImage(with: URL(string: notification.makerImageUrl))
        
        var text: NSAttributedString
        switch notification.type {
        case .like:
            text = createAttributedText(name: notification.makerNickname, text: "likes your post.")
        case .comment:
            text = createAttributedText(name: notification.makerNickname, text: "comments on your post.")
        case .follow:
            text = createAttributedText(name: notification.makerNickname, text: "starts following you.")
        }
        notificationLabel.attributedText = text
        
        if notification.type == .follow {
            postImage.isHidden = true
        } else {
            postImage.sd_setImage(with: URL(string: notification.postImageUrl))
        }
        
    }
    
    // MARK: - Actions
    @objc func didTapProfileImage() {
        guard let notification = notification else {return}
        delegate?.showNotificationMaker(makerUid: notification.makerUid)
    }
}
