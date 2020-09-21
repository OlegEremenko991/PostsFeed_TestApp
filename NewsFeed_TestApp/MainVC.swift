//
//  ViewController.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

class MainVC: UIViewController {


// MARK: Private properties
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    private let dataArray = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    

// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
// MARK: Private methods
    
    private func setupView() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide // setup safe area
        
        navigationItem.title = "Posts Feed"
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
        navigationItem.rightBarButtonItem = sortButton
        
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func sortAction() {
         print("sort button tapped")
        tableView.reloadData()
    }


}

// MARK: UITableViewDataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellID, for: indexPath) as! FeedCell
        let post = dataArray[indexPath.row]
        cell.dateLabel.text = "Some date"
        cell.authorLabel.text = post
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
        
        let post = dataArray[indexPath.row]
        postVC.dateLabel.text = "Date: Some date"
        postVC.authorLabel.text = "Author: " + post
        postVC.contentLabel.text = "Content: " + "\(arc4random()) some text"
        
        navigationController?.pushViewController(postVC, animated: true)
    }
}

