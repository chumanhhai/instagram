//
//  FeedCell.swift
//  Instagram
//
//  Created by Hải Chu on 13/07/2021.
//

import UIKit
import Firebase

protocol FeedCellDelegate {
    func showCommnentForPost(_ post: Post)
    func showOwnerForPost(_ owner: Owner)
}

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            configure()
        }
    }
    
    var delegate: FeedCellDelegate?
    
    var isLike: Bool = false
    
    // MARK: - PROPERTIES
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        let size: CGFloat = 40
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(height: size, width: size)
        iv.layer.cornerRadius = size/2
        return iv
    }()
    
    lazy var profileNameView: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(btnNameHandler), for: .touchUpInside)
        return button
    }()
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var btnLike = functionButtons(image: UIImage(systemName: "heart")!, action: #selector(btnLikeHandler))
    
    lazy var btnComment = functionButtons(image: UIImage(systemName: "message")!, action: #selector(btnCommentHandler))
    
    lazy var btnShare = functionButtons(image: UIImage(systemName: "paperplane")!, action: #selector(btnShareHandler))
    
    let likeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "5 minutes ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add avatar
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        // add name
        addSubview(profileNameView)
        profileNameView.centerY(centerY: profileImageView.centerYAnchor, left: profileImageView.rightAnchor, paddingLeft: 8)
        
        // add post image
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.setHeight(height: frame.width)
        
        // add function buttons, labels
        let infoContainer = createInfoContainer()
        addSubview(infoContainer)
        infoContainer.anchor(top: postImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure() {
        guard let post = post else {return}
        guard let currentUser = Auth.auth().currentUser else {return}
        postImageView.sd_setImage(with: URL(string: post.imageUrl))
        likeLabel.text = "\(post.likes.count) likes"
        statusLabel.text = post.caption
        profileImageView.sd_setImage(with: URL(string: post.owner.imageUrl))
        profileNameView.setTitle(post.owner.nickname, for: .normal)
        timeLabel.text = createTimeIntervalText(createAt: post.createdAt)
        // set like button ui
        if post.likes.contains(currentUser.uid) {
            setLikedButton()
        } else {
            setUnlikedButton()
        }
    }
    
    func createTimeIntervalText(createAt: Double) -> String {
        let timeInterval = Int(Date().timeIntervalSince1970 - createAt)
        let ti: Int
        if(timeInterval > 0 && timeInterval < 60) {
            return "\(timeInterval) seconds ago"
        } else if(timeInterval < 3600) {
            ti = timeInterval / 60
            return "\(ti) minutes ago"
        } else if (timeInterval < 86400) {
            ti = timeInterval / 3600
            return "\(ti) hours ago"
        } else if (timeInterval < 2592000) {
            ti = timeInterval / 86400
            return "\(ti) days ago"
        } else if (timeInterval < 31104000) {
            ti = timeInterval / 2592000
            return "\(ti) months ago"
        } else {
            ti = timeInterval / 31104000
            return "\(ti) years ago"
        }
    }
    
    func setLikedButton() {
        btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        btnLike.tintColor = .red
        isLike = true
    }
    
    func setUnlikedButton() {
        btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
        btnLike.tintColor = .black
        isLike = false
    }
    
    // MARK: - ACTIONS
    @objc func btnNameHandler(_ sender: UIButton?) {
        guard let post = post else {return}
        delegate?.showOwnerForPost(post.owner)
    }
    
    @objc func btnLikeHandler() {
        guard let post = post else {return}
        guard let currentUser = Auth.auth().currentUser else {return}
        if isLike { // set to unlike
            PostService.removeLike(postUid: post.uid)
            // remove element from post.likes
            for (i, uid) in post.likes.enumerated() {
                if uid == currentUser.uid {
                    self.post!.likes.remove(at: i)
                    break
                }
            }
        } else { // set to like
            PostService.addLike(postUid: post.uid)
            NotificationService.uploadNotification(post: post, ownerUid: post.owner.uid
                                                   , type: .like)
            self.post!.likes.append(currentUser.uid)
        }
    }
    
    @objc func btnCommentHandler() {
        guard let post = post else {return}
        delegate?.showCommnentForPost(post)
    }
    
    @objc func btnShareHandler() {
        print("Share button is clicked")
    }
    
    func functionButtons(image: UIImage, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func createFunctionButtonsContainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [btnLike, btnComment, btnShare])
        
        container.spacing = 12
        container.axis = .horizontal
        return container
    }
    
    func createInfoContainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [createFunctionButtonsContainer(),
                                                       likeLabel, statusLabel, timeLabel])
        container.spacing = 8
        container.axis = .vertical
        container.alignment = .leading
        return container
    }
}

