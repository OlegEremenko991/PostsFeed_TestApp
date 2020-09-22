//
//  DataLoader.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class DataLoader {
    
// MARK: Singleton
    
    static let shared = DataLoader()
    
// MARK: Private properties
    
    private var cursor: String = "" {
        didSet { UD.shared.nextPageCursor = cursor }
    }
    
    private let defaultURL = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
    
// MARK: Main method
    
    func loadPosts(requestType: Request, _ completion: @escaping ([Item]) -> Void) {
        var parsedData = [Item]()
        var url = URL(string: "")
        
        switch requestType {
        case .first:
            url = URL(string: defaultURL)
        case .following:
            if cursor != "" {
                url = URL(string: defaultURL + "?after=" + cursor)
            } else {
                url = URL(string: defaultURL)
            }
        case .sortedByPopularity:
            url = URL(string: defaultURL + "?orderBy=mostPopular")
        case .sortedByComments:
            url = URL(string: defaultURL + "?orderBy=mostCommented")
        case .sortedByDate:
            url = URL(string: defaultURL + "?orderBy=createdAt")
        case .notSorted:
            url = URL(string: defaultURL)
        }
        
        guard let safeURL = url else {
            print("URL is nil")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: safeURL) { (data, response, error) in
            guard let jsonData = data else {
                print("JsonData is nil")
                return
            }
            
            guard let postDict = try? JSONDecoder().decode(PostDict.self, from: jsonData) else {
                print("Failed to load posts from URL: " + "\(url!.absoluteURL)")
                print("Cursor will be reset. Please scroll up and down to get new cursor and try again.")
                self.cursor = ""
                return
            }
            
            parsedData = postDict.data.items
            
            guard let cursor = postDict.data.cursor else { return }
            self.cursor = cursor
            print("Cursor recieved")
            
            DispatchQueue.main.async {
                completion(parsedData)
            }
            print("JSON data parsed successfully")
        }
        dataTask.resume()
    }

}
