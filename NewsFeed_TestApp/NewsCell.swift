//
//  NewsCell.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

class NewsCell: UITableViewCell {

    static let cellID = "NewsCellID"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(authorLabel)
        contentView.addSubview(containerView)
        
        containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -15).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: authorLabel.widthAnchor).isActive = true

        authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 15).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
