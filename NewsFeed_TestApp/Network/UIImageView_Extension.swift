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
            do {
                let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        self?.image = image
                    }
            } catch {
                print(error)
                self?.image = UIImage(systemName: "person")
            }
        }
    }
}
