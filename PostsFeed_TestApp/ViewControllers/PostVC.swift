//
//  PostVC.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class PostVC: UIViewController {
    
    // MARK: - Private properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Public methods

    func setupVC(dateString: String, authorName: String, authorImageString: String?, contentText: String?) {
        dateLabel.text = dateString
        authorNameLabel.text = authorName
        setupAuthorImageView(imageName: authorImageString)
        contentLabel.text = contentText
    }

    // MARK: - Private methods

    private func setupAuthorImageView(imageName: String?) {
        if let imageString = imageName,
           imageString != "",
           let authorImageURL = URL(string: imageString) {
            authorImageView.load(url: authorImageURL)
        } else {
            authorImageView.image = UIImage(systemName: "person")
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Post Details"
    }

    private func setupSubviews() {
        [dateLabel, authorNameLabel, authorImageView, contentLabel].forEach {
            containerView.addSubview($0)
        }
        view.addSubview(containerView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                dateLabel.heightAnchor.constraint(equalToConstant: 30)
            ]
        )

        NSLayoutConstraint.activate(
            [
                authorNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
                authorNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                authorNameLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
                authorNameLabel.heightAnchor.constraint(equalToConstant: 50)
            ]
        )

        NSLayoutConstraint.activate(
            [
                authorImageView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 5),
                authorImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                authorImageView.heightAnchor.constraint(equalToConstant: 100),
                authorImageView.widthAnchor.constraint(equalTo: authorImageView.heightAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                contentLabel.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 10),
                contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ]
        )
    }

}
