//
//  UIImageView_Extension.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

import UIKit

extension UIImageView {
    
    // Load image from URL on background thread
    
    func load(url: URL) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "person")
                }
            }
        }
    }
}
