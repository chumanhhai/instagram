//
//  FeedViewController.swift
//  Instagram
//
//  Created by Hải Chu on 12/07/2021.
//

import UIKit
import SDWebImage

class SearchViewController: UITableViewController {

    let cellIdentifier = "reuseCell"
    
    let spinning: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        return spinner
    }()
    
    let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }()
    
    var users: [User]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell identifier
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // search bar
        configureSearchBar()
        
        // show no result text
        showNoResultLabel()
    }

    // MARK: - UITableViewDelegateDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users == nil ? 0 : users!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! SearchCell
        
        cell.profileImage.sd_setImage(with: URL(string: user.imageUrl))
        cell.nameLabel.text = user.name
        cell.nicknameLabel.text = user.nickname
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.user = users![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Functions
    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func showSpinner() {
        // add spinning icon in footer
        spinning.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = spinning
        tableView.tableFooterView?.isHidden = false
    }
    
    func showNoResultLabel() {
        noResultLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableFooterView = noResultLabel
        tableView.tableFooterView?.isHidden = false
    }
    
    func hideTableFooter() {
        tableView.tableFooterView?.isHidden = true
    }
}

// MARK: - UISeachBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let nickname = searchBar.text!
        if(!nickname.isEmpty) {
            showSpinner()
            self.users = nil
            UserService.fetchUsers(name: nickname) { users, error in
                if let error = error {
                    self.hideTableFooter()
                    self.showAlert(error.localizedDescription)
                    return
                }
                if(users!.count == 0) {  // if no result
                    self.showNoResultLabel()
                    return
                }
                self.hideTableFooter()
                self.users = users
            }
        }
    }
}
