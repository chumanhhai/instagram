//
//  FeedViewController.swift
//  Instagram
//
//  Created by Hải Chu on 12/07/2021.
//

import UIKit
import Firebase
import JGProgressHUD

class FeedViewController: UICollectionViewController {

    private let identifier = "reusableCell"
    
    var posts: [Post]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var singlePost: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var spinner: JGProgressHUD?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if user is login in
        if(singlePost == nil) {
            checkUserLogin()
        }

        // style
        collectionView.backgroundColor = .white
        navigationItem.title = "Feed"
        
        // navigation bar
        if(singlePost == nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                                action: #selector(didTapLogOutButton))
        }
        
        // collection
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: identifier)
        
        // pull to refresh
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        collectionView.refreshControl = refresh
    
    }
    
    // MARK: - Actions
    @objc func didTapLogOutButton() {
        do {
            try Auth.auth().signOut()
            showAuthenScreen(true)
        } catch {
            showAlert("Login failed!")
        }
    }
    
    // MARK: - Functions
    func checkUserLogin() {
        if(Auth.auth().currentUser == nil) {
            showAuthenScreen(false)
        } else {
            spinner = createSpinner()
            fetchPosts()
        }
    }
    
    func showAuthenScreen(_ animated: Bool) {
        let vc = LoginController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: animated)
    }
    
    @objc func fetchPosts() {
        collectionView.refreshControl?.beginRefreshing()
        if let post = singlePost { // if a post
            PostService.fetchSinglePost(uid: post.uid) { post, error in
                self.collectionView.refreshControl?.endRefreshing()
                self.spinner?.dismiss()
                if let error = error {
                    self.showAlert(error.localizedDescription)
                    return
                }
                self.singlePost = post
            }
        } else { // if new feed
            PostService.fetchPosts { posts, error in
                self.collectionView.refreshControl?.endRefreshing()
                self.spinner?.dismiss()
                if let error = error {
                    self.showAlert(error.localizedDescription)
                    return
                }
                self.posts = posts
            }
        }
    }
}

// MARK: - data source
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(singlePost == nil) { // if new feed
            return posts?.count ?? 0
        } else { // if a post
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FeedCell
        if let post = singlePost { // if a post
            cell.post = post
        } else { // if new feed
            cell.post = posts![indexPath.row]
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - delegate flow layout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var post: Post
        if let singlePost = singlePost {
            post = singlePost
        } else {
            post = posts![indexPath.row]
        }
        let caption = post.caption
        
        let width = view.frame.width
        let approximateWidthOfStatus = width - 12*2
        let size = CGSize(width: approximateWidthOfStatus, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: caption).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let height = 12 + 40 + 8 + width + 5*8 + 14*3 + 10 + estimatedFrame.height

        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate
extension FeedViewController: FeedCellDelegate {
    func showCommnentForPost(_ post: Post) {
        let vc = CommentController()
        vc.post = post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showOwnerForPost(_ owner: Owner) {
        let spinner = createSpinner()
        UserService.fetchUser(uid: owner.uid) { user, error in
            spinner.dismiss(animated: true)
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

