//
//  CommentController.swift
//  Instagram
//
//  Created by Hải Chu on 22/07/2021.
//

import UIKit

class CommentController: UIViewController {

    let cellIdentifier = "reuseCell"
    
    var post: Post?
    
    var comments: [Comment]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(CommentCell.self, forCellReuseIdentifier: cellIdentifier)
        table.separatorStyle = .none
        return table
    }()
    
    let input: ConstraintLengthTextView = {
        let input = ConstraintLengthTextView()
        input.placeholder = "Enter a comment ..."
        input.maxLength = 100
        return input
    }()
    
    let topBorder: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        border.setHeight(height: 1)
        return border
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setWidth(width: 45)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // style
        view.backgroundColor = .white
        navigationItem.title = "Comment"
        
        // add input view
        view.addSubview(input)

        // add post button
        view.addSubview(postButton)
        input.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingLeft: 12, paddingBottom: 16, paddingRight: 12)
        postButton.anchor(top: input.topAnchor, right: view.rightAnchor, paddingRight: 12)

        // add top border of input section
        view.addSubview(topBorder)
        topBorder.anchor(left: view.leftAnchor, bottom: input.topAnchor, right: view.rightAnchor, paddingBottom: 16)
        
        // add table view
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: topBorder.topAnchor, right: view.rightAnchor)
        
        // fetch comments
        fetchComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    @objc func didTapPostButton() {
        guard let post = post else {return}
        guard let commentContent = input.text else {return}
        if(commentContent.isEmpty) {return}
        // behavior
        view.endEditing(true)
        input.text = ""
        input.placeholderLabel.isHidden = false
        // upload comment
        let spinner = createSpinner()
        PostService.uploadComment(postUid: post.uid, content: commentContent) { comment, error in
            spinner.dismiss(animated: true)
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.comments?.append(comment!)
            NotificationService.uploadNotification(post: post, ownerUid: post.owner.uid, type: .comment)
        }
    }
    
    // MARK: - Functions
    func fetchComments() {
        guard let post = post else {return}
        PostService.fetchComments(postUid: post.uid) { comments, error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.comments = comments
        }
    }
}

// MARK: - UITableViewDataSource
extension CommentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        cell.comment = comments![indexPath.row]
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        return cell
        
    }
}

// MARK: - UITableViewDelegate
extension CommentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CommentCellDelegate
extension CommentController: CommentCellDelegate {
    func showOwnerForComment(_ owner: Owner) {
        let spinner = createSpinner()
        UserService.fetchUser(uid: owner.uid) { user, error in
            spinner.dismiss()
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            let vc = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
