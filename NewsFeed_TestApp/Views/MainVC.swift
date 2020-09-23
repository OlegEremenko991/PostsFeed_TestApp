//
//  ViewController.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class MainVC: UIViewController {
    
// MARK: Private properties
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    private let activityIndicator = UIActivityIndicatorView()
    private var postData: [Item] = []{ // data source for tableView
        didSet { UDforCache.shared.postsArray = postData }
    }
    private var sortedBy = SortType.notSorted // shows current sort order

// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialData()
        setupView()
        setupTableView()
        performInitialPostsLoad()
    }
    
// MARK: Private methods
    
    private func setupView() {
        safeArea = view.layoutMarginsGuide
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        
        setupNavigationItem()
    }
    
    // Set data source and sort type from UserDefaults
    
    private func setupInitialData() {
        postData = UDforCache.shared.postsArray
        sortedBy = SortType(rawValue: UDforCache.shared.currentSortType)!
        print("UD has sort type: " + "\(UDforCache.shared.currentSortType)")
        print("ViewController has sort type: " + "\(sortedBy)")
    }
    
    // If data source for tableView is empty, perform request
    
    private func performInitialPostsLoad() {
        if postData.isEmpty {
            getPosts(requestType: Request.first, sort: .notSorted)
        }
    }
    
    private func setupNavigationItem() {
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.title = "Posts Feed"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellID)
        
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func getPosts(requestType: Request, sort: SortType, loadmore: Bool = false) {
        
        activityIndicator.startAnimating()
        
        DataLoader.shared.loadPosts(requestType: requestType, sortBy: sort) { (posts) in
            if loadmore {
                self.postData.append(contentsOf: posts)
            } else {
                self.postData = posts
            }
            
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc fileprivate func sortAction() {
        print("Sort button tapped")

        switch sortedBy {
        case .notSorted:
            getPosts(requestType: .sortedByDate, sort: .createdAt)
            sortedBy = .createdAt
        case .createdAt:
            getPosts(requestType: .sortedByPopularity, sort: .mostPopular)
            sortedBy = .mostPopular
        case .mostPopular:
            getPosts(requestType: .sortedByComments, sort: .mostCommented)
            sortedBy = .mostCommented
        case .mostCommented:
            getPosts(requestType: .notSorted, sort: .notSorted)
            sortedBy = .notSorted
        }
        
        print("Sorting by: " + "\(sortedBy)")
        print("VC has sort type: " + "\(sortedBy)")
        
        UDforCache.shared.currentSortType = sortedBy.rawValue
        showAlertController()
    }
    
    // Convert date from UNIX to Date
    
    private func convertDate(value: Int, short: Bool) -> String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(value / 1000))
        let dateFormatter = DateFormatter()
        if short == true {
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.short
        } else if short == false {
            dateFormatter.dateFormat = "HH:mm E, d MMM y"
        }
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
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
        cell.dateLabel.text = convertDate(value: post.createdAt, short: true)
        cell.authorLabel.text = post.author?.name ?? "No name"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = postData.count - 1
        if indexPath.row == lastElement {
            getPosts(requestType: .following, sort: sortedBy, loadmore: true) // Load more posts when scrolling down
        }
    }
}

// MARK: UITableViewDelegate

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let postVC = PostVC()
        
        // Prepare data for PostVC
        
        let post = postData[indexPath.row]
        let content = post.contents
        
        postVC.dateLabel.text = "Created at: " + convertDate(value: post.createdAt, short: false)
        postVC.authorNameLabel.text = "Author name: " + "\(post.author?.name ?? "Unknown")"
        
        if let imageStringURL = post.author?.photo?.data.extraSmall.url {
            postVC.authorImageName = imageStringURL
        }
        
        for x in content {
            if x.type == "TEXT" {
                postVC.contentLabel.text = x.data.value
            }
        }
        
        navigationController?.pushViewController(postVC, animated: true)
    }
}

// MARK: UINavigationControllerDelegate

extension MainVC: UINavigationControllerDelegate {
    func showAlertController() {
        let okAction = UIAlertAction(title: "Ok!", style: .cancel, handler: nil)
        let alert = AlertService.showAlert(style: .alert, sortType: sortedBy, actions: [okAction])
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
