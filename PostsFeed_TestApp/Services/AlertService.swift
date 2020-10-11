//
//  AlertService.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

import UIKit

final class AlertService {

    static func showAlert(style: UIAlertController.Style, sortType: SortType?, message: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        
        let sortComment = "Data source has been loaded from scratch"
        var textMessage: String {
            guard let message = message else { return sortComment }
            return message
        }
        
        var title = ""
        
        switch sortType {
        case .notSorted:
            title = "Not sorted at all"
        case .mostPopular:
            title = "Sorted by popularity"
        case .mostCommented:
            title = "Sorted by number of comments"
        case .createdAt:
            title = "Sorted by creation date"
        case .none:
            title = "Error"
        }
        
        let alert = UIAlertController(title: title, message: textMessage, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
}
