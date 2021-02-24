//
//  NewsCell.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class FeedCell: UITableViewCell {
    
    // MARK: - Public properties

    static let cellID = "FeedCellID"
    
    // MARK: - Private properties
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Author"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public methods

    /// Setup dateLabel and authorLabel for the cell
    func setupCell(date: String, author: String) {
        dateLabel.text = date
        authorLabel.text = author
    }

    // MARK: - Private methods
    
    private func setupConstraints() {
        containerView.addSubview(dateLabel)
        containerView.addSubview(authorLabel)
        contentView.addSubview(containerView)

        /// Setup containerView
        NSLayoutConstraint.activate(
            [
                containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            ]
        )

        /// Setup dateLabel
        NSLayoutConstraint.activate(
            [
                dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                dateLabel.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -15),
                dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                dateLabel.widthAnchor.constraint(equalTo: authorLabel.widthAnchor)
            ]
        )

        /// Setup authorLabel
        NSLayoutConstraint.activate(
            [
                authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                authorLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 15),
                authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                authorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
            ]
        )
    }

}
