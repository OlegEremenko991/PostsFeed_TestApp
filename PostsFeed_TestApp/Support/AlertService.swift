//
//  AlertService.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

import UIKit

final class AlertService {
    static func showAlert(style: UIAlertController.Style, sortType: SortType, actions: [UIAlertAction]) -> UIAlertController {
        
        var title = ""
        let message = "Data source has been loaded from scratch"
        
        switch sortType {
        case .notSorted:
            title = "Not sorted at all"
        case .mostPopular:
            title = "Sorted by popularity"
        case .mostCommented:
            title = "Sorted by number of comments"
        case .createdAt:
            title = "Sorted by creation date"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
}
