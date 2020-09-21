//
//  ViewController.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

class MainVC: UIViewController {
    
// MARK: Private properties
    
    private var postData = [Item]()
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    private let activityIndicator = UIActivityIndicatorView()

// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getPosts()
    }
    
// MARK: Private methods
    
    private func setupView() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        
        navigationItem.title = "Posts Feed"
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
        navigationItem.rightBarButtonItem = sortButton
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        
        activityIndicator.startAnimating()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellID)
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func getPosts() {
        DataLoader().loadPosts { (posts) in
            self.postData = posts
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func sortAction() {
        print("sort button tapped")
        activityIndicator.startAnimating()
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

// MARK: UITableViewDataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellID, for: indexPath) as! FeedCell

        let post = postData[indexPath.row]
        cell.dateLabel.text = "\(post.createdAt)"
        cell.authorLabel.text = "\(post.author?.name ?? "Unknown")"
        return cell
    }
    
    
}

// MARK: UITableViewDelegate

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: Prepare data for PostVC
        
        let postVC = PostVC()
        
        let post = postData[indexPath.row]
        let contents = post.contents
        
        postVC.dateLabel.text = "\(post.createdAt)"
        postVC.authorLabel.text = "\(post.author?.name ?? "Unknown")"
        
        for x in contents {
            if x.type == "TEXT" {
                postVC.contentLabel.text = x.data.value
            }
        }
        
        navigationController?.pushViewController(postVC, animated: true)
    }
}

