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
        didSet { UDforCache.shared.nextPageCursor = cursor }
    }
    
    private let defaultURL = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
//    private var sortBy = SortType.notSorted
    
// MARK: Main method for loading and parsing data
    
    func loadPosts(requestType: Request, sortBy: SortType, _ completion: @escaping ([Item]) -> Void) {
        var url = URL(string: "")
        var parsedData = [Item]()
        switch requestType {
        case .first:
            url = URL(string: defaultURL)
        case .following:
            if UDforCache.shared.nextPageCursor != "" {
                switch sortBy {
                case .createdAt:
                    url = URL(string: defaultURL + "?orderBy=createdAt" + "&after=" + UDforCache.shared.nextPageCursor)
                case .mostPopular:
                    url = URL(string: defaultURL + "?orderBy=mostPopular" + "&after=" + UDforCache.shared.nextPageCursor)
                case .mostCommented:
                    url = URL(string: defaultURL + "?orderBy=mostCommented" + "&after=" + UDforCache.shared.nextPageCursor)
                case .notSorted:
                    url = URL(string: defaultURL + "?after=" + UDforCache.shared.nextPageCursor)
                }
            } else {
                return
            }
        case .sortedByPopularity:
            cursor = ""
            url = URL(string: defaultURL + "?orderBy=mostPopular")
        case .sortedByComments:
            cursor = ""
            url = URL(string: defaultURL + "?orderBy=mostCommented")
        case .sortedByDate:
            cursor = ""
            url = URL(string: defaultURL + "?orderBy=createdAt")
        case .notSorted:
            cursor = ""
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
                    print("Failed to load posts from URL: " + "\(url!.absoluteURL)")
                    return
                }
                parsedData = dataToConsider.items
                guard let cursor = dataToConsider.cursor else { return }
                self.cursor = cursor.withReplacedCharacters("+", by: "%2B")
                print("Cursor recieved: " + cursor)
            } catch {
                print(error)
                return
            }
            DispatchQueue.main.async {
                completion(parsedData)
            }
            print("JSON data parsed successfully")
        }
        dataTask.resume()
    }
    
// MARK: Support method
    
//    private func supportSetup(sort: SortType) {
//        cursor = "" // clear cursor
//        sortBy = sort // set sort type
//    }

}
