//
//  ProfileHeader.swift
//  Instagram
//
//  Created by Hải Chu on 15/07/2021.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: UIViewController!
    
    let profileImage: UIImageView = {
        let size: CGFloat = 70
        let image = UIImageView()
        image.setDimensions(height: size, width: size)
        image.backgroundColor = .systemGray
        image.layer.cornerRadius = size / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    lazy var postLabel = createStatisticLabel(value: 0, label: "posts")
    
    lazy var followerLabel = createStatisticLabel(value: 0, label: "followers")
    
    lazy var followingLabel = createStatisticLabel(value: 0, label: "followings")
    
    lazy var statisticLabelContainer: UIStackView = {
       let container = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        container.axis = .horizontal
        container.distribution = .fillEqually
        return container
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle.grid.3x3.fill"), for: .normal)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()
    
    lazy var categoryButtonContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.setHeight(height: 50)
        return container
    }()
    
    let categoryBtnContainerTopBorder: UIView = {
        let border = UIView()
        border.setHeight(height: 1)
        border.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return border
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        // add image
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 14, paddingLeft: 16)
        
        // add name label
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 14, paddingRight: 14)
        
        // add edit button
        addSubview(editButton)
        editButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 14,
                          paddingLeft: 20, paddingRight: 20)
        
        // add statistic labels container
        addSubview(statisticLabelContainer)
        statisticLabelContainer.centerY(centerY: profileImage.centerYAnchor, left: profileImage.rightAnchor,
                                        right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        // add category button container
        addSubview(categoryButtonContainer)
        categoryButtonContainer.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 14, paddingRight: 14)
        
        // add border of category button container
        addSubview(categoryBtnContainerTopBorder)
        categoryBtnContainerTopBorder.anchor(left: leftAnchor, bottom: categoryButtonContainer.topAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure() {
        guard let user = user else {return}
        // set data to header
        nameLabel.text = user.name
        profileImage.sd_setImage(with: URL(string: user.imageUrl))
        postLabel.attributedText = createStatisticText(value: user.stats.posts, label: "posts")
        followerLabel.attributedText = createStatisticText(value: user.stats.followers, label: "followers")
        followingLabel.attributedText = createStatisticText(value: user.stats.followings, label: "followings")
        // set edit/follow button
        if(user.isCurrentUser) { // edit
            styleEditButton(title: "Edit Profile", titleColor: .black, bgColor: .white, borderWidth: 1)
        } else if(user.isFollowed) { // following
            styleEditButton(title: "Following", titleColor: .white, bgColor: .systemBlue, borderWidth: 0)
        } else { // follow
            styleEditButton(title: "Follow", titleColor: .white, bgColor: .systemBlue, borderWidth: 0)
        }
    }
    
    func createStatisticLabel(value: Int, label: String) -> UILabel {
        let string = createStatisticText(value: value, label: label)
        let label = UILabel()
        label.attributedText = string
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    func createStatisticText(value: Int, label: String) -> NSAttributedString {
        let valueString = NSAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 13)])
        let labelString = NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor(white: 0, alpha: 0.5)])
        let string = NSMutableAttributedString(attributedString: valueString)
        string.append(labelString)
        return string
    }
    
    func styleEditButton(title: String, titleColor: UIColor, bgColor: UIColor, borderWidth: CGFloat) {
        editButton.setTitle(title, for: .normal)
        editButton.setTitleColor(titleColor, for: .normal)
        editButton.backgroundColor = bgColor
        editButton.layer.borderWidth = borderWidth
    }
    
    // MARK: - Actions
    @objc func didTapEditButton() {
        guard let user = user else {return}
        if(user.isCurrentUser) { // if current user
            print("DEBUG: Edit")
        } else if (user.isFollowed) { // set unfollow
            editButton.setTitle("Loading...", for: .normal)
            UserService.unfollow(uid: user.uid) { error in
                if let error = error {
                    self.delegate?.showAlert(error.localizedDescription)
                }
                self.user?.isFollowed = false
                self.user?.stats.followers -= 1
                User.currentUser?.stats.followings -= 1
            }
        } else { // set follow
            editButton.setTitle("Loading...", for: .normal)
            UserService.follow(uid: user.uid) { error in
                if let error = error {
                    self.delegate?.showAlert(error.localizedDescription)
                }
                self.user?.isFollowed = true
                self.user?.stats.followers += 1
                User.currentUser?.stats.followings += 1
                NotificationService.uploadNotification(post: nil, ownerUid: user.uid, type: .follow)
            }
        }
    }
}
