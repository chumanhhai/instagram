//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Hải Chu on 12/07/2021.
//

import UIKit

class NotificationViewController: UITableViewController {

    let cellIdentifier = "reuseCell"
    
    var notifications: [Notification]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // refresh function
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(fetchNotifications), for: .valueChanged)
        tableView.refreshControl = refresher
        
        // fetch data
        fetchNotifications()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NotificationCell
        cell.contentView.isUserInteractionEnabled = false
        cell.notification = notifications![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications![indexPath.row]
        if notification.type == .follow { // if follow
            showNotificationMaker(makerUid: notification.makerUid)
        } else { // if like or comment
            let spinner = createSpinner()
            PostService.fetchSinglePost(uid: notification.postUid) { post, error in
                spinner.dismiss()
                if let error = error {
                    self.showAlert(error.localizedDescription)
                    return
                }
                let vc = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
                vc.singlePost = post
                self.navigationController?.pushViewController(vc, animated: true )
            }
        }
    }
    
    // MARK: - Functions
    @objc func fetchNotifications() {
        tableView.refreshControl?.beginRefreshing()
        NotificationService.fetchNotification { notifications, error in
            self.tableView.refreshControl?.endRefreshing()
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            self.notifications = notifications
        }
    }

}

// MARK: - NotificationCellDelegate
extension NotificationViewController: NotificationCellDelegate {
    func showNotificationMaker(makerUid: String) {
        let spinner = createSpinner()
        UserService.fetchUser(uid: makerUid) { user, error in
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
