//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Hải Chu on 12/07/2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UICollectionViewController {

    let headerIdentifier = "header identifier"
    let cellIdentifier = "cell identifier"
    
    var user: User? {
        didSet {
            collectionView.reloadData()
            navigationItem.title = user?.nickname
        }
    }
    
    var posts: [Post]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .white
        
        // collection view
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // fetch user data
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // sync between local current user vs global current user
        guard let user = user else {return}
        if(user.uid == User.currentUser!.uid) {
            self.user = User.currentUser
            self.posts = Post.currentPosts
        }
    }
    
    // MARK: - Functions
    func fetchUser() {
        // fetch user
        if let user = user { // if this is not current user
            UserService.checkFollowed(uid: user.uid) { isFollowed, error in
                if let error = error {
                    self.showAlert(error.localizedDescription)
                    return
                }
                self.user!.isFollowed = isFollowed!
            }
            setStats()
        } else { // if this is current user
            user = User.currentUser
            posts = Post.currentPosts
        }
    }
    
    func fetchPosts() {
        // fetch post
        guard let user = user else {return}
        PostService.fetchUserPosts(uid: user.uid) {posts, error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.user?.stats.posts = posts!.count
            self.posts = posts
        }
    }
    
    func setStats() {
        guard let uid = user?.uid else {return}
        UserService.getStatics(uid: uid) { stats, error in
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.user!.stats = stats!
            self.fetchPosts()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            as! ProfileCell
        cell.post = posts![indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        if let user = user {
            header.user = user
        }
        return header
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.singlePost = posts![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    // space between 2 columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // space between 2 rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width-2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}
