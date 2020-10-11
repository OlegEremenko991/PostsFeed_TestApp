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
    private var alert: UIAlertController?
    private let activityIndicator = UIActivityIndicatorView()
    
    private var postData: [Item] = [] { // Data source for tableView
        didSet { UDservice.shared.postsArray = postData }
    }
    
    private var sortedBy: SortType? // current sort order

// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        performInitialPostsLoad()
    }
    
// MARK: Private methods
    
    private func setupView() {

        setupInitialData()
        safeArea = view.layoutMarginsGuide
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        setupNavigationItem()
        setupTableView()
    }
    
    // Set data source and sort type from UserDefaults
    
    private func setupInitialData() {
        postData = UDservice.shared.postsArray
        sortedBy = SortType(rawValue: UDservice.shared.currentSortType)
    }
    
    // If data source for tableView is empty, perform request
    
    private func performInitialPostsLoad() {
        if postData.isEmpty {
            getPosts()
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
        
    private func getPosts(sort: SortType? = nil, loadmore: Bool = false) {
        
        activityIndicator.startAnimating()
    
        NetworkService.loadPosts(sort: sort, loadMore: loadmore) { result in
            switch result {
            case .success(let data):
                if loadmore {
                    self.postData.append(contentsOf: data)
                } else {
                    self.postData = data
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlertController(message: error.rawValue, error: true)
                }
            }
        }
        
    }
    
    @objc private func sortAction() {
        switch sortedBy {
        case .notSorted:
            getPosts(sort: .createdAt)
            sortedBy = .createdAt
        case .createdAt:
            getPosts(sort: .mostPopular)
            sortedBy = .mostPopular
        case .mostPopular:
            getPosts(sort: .mostCommented)
            sortedBy = .mostCommented
        case .mostCommented:
            getPosts(sort: .notSorted)
            sortedBy = .notSorted
        case .none:
            getPosts(sort: .createdAt)
            sortedBy = .createdAt
        }
        
        guard let sortedBy = sortedBy else { return }
        UDservice.shared.currentSortType = sortedBy.rawValue
        showAlertController(error: false)
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
    
    private func showAlertController(message: String? = nil, error: Bool) {
        guard alert == nil else { return } // Prevent from showing multiple alert controllers
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.alert = nil
        }
        
        if error {
            alert = AlertService.showAlert(style: .alert, sortType: nil, message: message, actions: [okAction])
        } else {
            guard let sortedBy = sortedBy else { return }
            alert = AlertService.showAlert(style: .alert, sortType: sortedBy, message: message, actions: [okAction])
        }
        
        guard let alert = alert else { return }
        present(alert, animated: true, completion: nil)
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
        
        // Load more posts when scrolling down
        if indexPath.row == lastElement {
            getPosts(sort: sortedBy, loadmore: true)
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
