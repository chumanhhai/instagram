//
//  ViewController.swift
//  Instagram
//
//  Created by Hải Chu on 12/07/2021.
//

import UIKit
import YPImagePicker

class TabBarMainViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configViewControllers()
    }
    
    // MARK: - Functions
    func configViewControllers() {
        let feed = templateViewControllers(image: UIImage(systemName: "house")!,
                                             vc: FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        feed.title = "Feed"
        
        let search = templateViewControllers(image: UIImage(systemName: "magnifyingglass")!,
                                             vc: SearchViewController())
        search.title = "Search"
        
        let imageSelector = createImageSelectorViewcontroller()
        imageSelector.title = "Post"
        
        let notification = templateViewControllers(image: UIImage(systemName: "suit.heart")!,
                                             vc: NotificationViewController())
        notification.title = "Notification"
        
        let profile = templateViewControllers(image: UIImage(systemName: "person.fill")!,
                                             vc: ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        profile.title = "Profile"
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        tabBar.tintColor = .black
        
        // fetch data
        User.fetchCurrentUserAndPosts(context: self)
    }
    
    // MARK: - Functions
    func templateViewControllers(image: UIImage, vc: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem.image = image
        nc.navigationBar.tintColor = .black
        return nc
    }
    
    func createImageSelectorViewcontroller() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.shouldSaveNewPicturesToAlbum = false
        config.library.maxNumberOfItems = 1
        let imageSelector = YPImagePicker(configuration: config)
        imageSelector.tabBarItem.image = UIImage(systemName: "plus.square")!
        imageSelector.navigationBar.tintColor = .black
        imageSelector.didFinishPicking { items, _ in
            if(items.count == 0) { // if cancel
                self.selectedIndex = 0
            } else { // if next
                let vc = UploadPostController()
                vc.image = items.singlePhoto?.image
                vc.delegate = self
                self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }
        return imageSelector
    }

}

// MARK: - UploadPostControllerDelegate
extension TabBarMainViewController: UploadPostControllerDelegate {
    func didFinishedUploadPost(newPost: Post) {
        selectedIndex = 0
        
        // insert into new feed
        let feedNav = viewControllers?.first as! UINavigationController
        let feed = feedNav.viewControllers.first as! FeedViewController
        feed.posts?.insert(newPost, at: 0)
        feed.navigationController?.popToRootViewController(animated: true)
        feed.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        
        // insert into list of owner posts
        Post.insertIntoCurrentPosts(newPost: newPost)
    }
}

