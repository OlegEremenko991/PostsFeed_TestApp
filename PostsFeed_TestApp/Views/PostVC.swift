//
//  PostVC.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class PostVC: UIViewController {
    
// MARK: Public properties
    
    var authorImageName = ""
    
// MARK: UI elements
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
// MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
// MARK: Private methods
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Post Details"
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(authorNameLabel)
        containerView.addSubview(authorImageView)
        containerView.addSubview(contentLabel)
        view.addSubview(containerView)
        
        if authorImageName != "" {
            authorImageView.load(url: URL(string: authorImageName)!)
        } else {
            authorImageView.image = UIImage(systemName: "person")
        }
        
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        authorNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        authorNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        authorNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        authorNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        authorImageView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 5).isActive = true
        authorImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        authorImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        authorImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentLabel.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 10).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

}
