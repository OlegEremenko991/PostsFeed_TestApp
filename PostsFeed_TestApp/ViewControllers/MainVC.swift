//
//  ViewController.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class MainVC: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tView = UITableView(frame: .zero, style: .plain)
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.dataSource = self
        tView.delegate = self
        tView.separatorStyle = .singleLine
        tView.tableFooterView = UIView()
        tView.rowHeight = 60
        tView.keyboardDismissMode = .onDrag
        return tView
    }()
    private var safeArea: UILayoutGuide!
    private var alert: UIAlertController?
    private let activityIndicator = UIActivityIndicatorView()
    private var postsDataSource: [Item] = [] {
        didSet { UserDefaultsService.shared.postsArray = postsDataSource }
    }
    private lazy var sortAction: UIAction = {
        UIAction { [weak self] action in
            self?.sortFunc()
        }
    }()


    /// Current sort order
    private var sortedBy: SortType?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        performInitialPostsLoad()
    }
    
    // MARK: - Private methods
    
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
    
    /// Set data source and sort type from UserDefaults
    private func setupInitialData() {
        postsDataSource = UserDefaultsService.shared.postsArray
        sortedBy = SortType(rawValue: UserDefaultsService.shared.currentSortType)
    }
    
    /// Request posts If data source for tableView is empty
    private func performInitialPostsLoad() {
        if postsDataSource.isEmpty { getPosts() }
    }
    
    private func setupNavigationItem() {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                         primaryAction: sortAction)
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.title = "Posts Feed"
    }
    
    private func setupTableView() {
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellID)

        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }

    private func getPosts(sort: SortType? = nil, loadmore: Bool = false) {
        activityIndicator.startAnimating()
    
        NetworkService.loadPosts(sort: sort, loadMore: loadmore) { result in
            switch result {
            case .success(let data):
                if loadmore {
                    self.postsDataSource.append(contentsOf: data)
                } else {
                    self.postsDataSource = data
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("--- Could not load posts, error: \(error.rawValue)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlertController(message: error.rawValue, error: true)
                }
            }
        }

    }
    
    private func sortFunc() {
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
        UserDefaultsService.shared.currentSortType = sortedBy.rawValue
        showAlertController(error: false)
    }
    
    /// Convert date from UNIX to Date
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
        // Prevent from showing multiple alert controllers
        guard alert == nil else { return }

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
        postsDataSource.isEmpty ? 1 : postsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !postsDataSource.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellID, for: indexPath) as! FeedCell
            let post = postsDataSource[indexPath.row]
            cell.setupCell(date: convertDate(value: post.createdAt, short: true),
                           author: post.author?.name ?? "No name")
            return cell
        } else {
            let defaultCell = UITableViewCell()
            defaultCell.textLabel?.text = "No data to display"
            return defaultCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = postsDataSource.count - 1

        // Load more posts when scrolling down
        if indexPath.row == lastElement {
            getPosts(sort: sortedBy, loadmore: true)
        }
    }
}

// MARK: UITableViewDelegate

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let postVC = PostVC()
        let post = postsDataSource[indexPath.row]
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
