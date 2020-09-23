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
    private var sortBy = SortType.notSorted
    
// MARK: Load posts
    
    func loadPosts(requestType: Request, _ completion: @escaping ([Item]) -> Void) {
        var url = URL(string: "")
        var parsedData = [Item]()
        switch requestType {
        case .first:
            url = URL(string: defaultURL)
        case .following:
            if cursor != "" {
                switch sortBy {
                case .createdAt:
                    url = URL(string: defaultURL + "?orderBy=createdAt" + "&after=" + cursor)
                case .mostPopular:
                    url = URL(string: defaultURL + "?orderBy=mostPopular" + "&after=" + cursor)
                case .mostCommented:
                    url = URL(string: defaultURL + "?orderBy=mostCommented" + "&after=" + cursor)
                case .notSorted:
                    url = URL(string: defaultURL + "?after=" + cursor)
                }
            } else {
                url = URL(string: defaultURL)
            }
        case .sortedByPopularity:
            cursor = ""
            sortBy = .mostPopular
            url = URL(string: defaultURL + "?orderBy=mostPopular")
        case .sortedByComments:
            cursor = ""
            sortBy = .mostCommented
            url = URL(string: defaultURL + "?orderBy=mostCommented")
        case .sortedByDate:
            cursor = ""
            sortBy = .createdAt
            url = URL(string: defaultURL + "?orderBy=createdAt")
        case .notSorted:
            cursor = ""
            sortBy = .notSorted
            url = URL(string: defaultURL)
        }
        
        guard let safeURL = url else { return }
        
        let dataTask = URLSession.shared.dataTask(with: safeURL) { (data, response, error) in
            guard let jsonData = data, error == nil else {
                print("JSON data is nil")
                return
            }
            
            do {
                let postDict = try JSONDecoder().decode(PostDict.self, from: jsonData)
                guard let dataToConsider = postDict.data else {
                    print("Could not decode JSON")
                    return
                }
                parsedData = dataToConsider.items
                guard let cursor = dataToConsider.cursor else { return }
                self.cursor = cursor.withReplacedCharacters("+", by: "%2B")
                print("Cursor recieved: " + cursor)
            } catch {
                print(error)
                print("Failed to load posts from URL: " + "\(url!.absoluteURL)")
                print("Cursor will be reset. Please scroll up and down to get new cursor and try again.")
                self.cursor = ""
                parsedData = []
                return
            }
            DispatchQueue.main.async {
                completion(parsedData)
            }
            print("JSON data parsed successfully")
        }
        dataTask.resume()
    }

}
