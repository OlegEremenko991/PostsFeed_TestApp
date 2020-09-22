//
//  UIImageView_Extension.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

import UIKit

extension UIImageView {
    
    // Load image from URL
    
    func load(url: URL) {
        DispatchQueue.main.async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.image = image
                }
            }
        }
    }
}
