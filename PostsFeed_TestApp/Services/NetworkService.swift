//
//  DataLoader.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class NetworkService {
    
// MARK: Singleton
    
    static let shared = NetworkService()
    
// MARK: Private properties
    
    private var cursor: String = "" {
        didSet { UDservice.shared.nextPageCursor = cursor }
    }
    private var requestURL: URL?
    private let defaultURL = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
    
// MARK: Main method for loading and parsing data
    
    func loadPosts(sort: SortType? = nil, loadMore: Bool? = nil, completion: @escaping (Result<[Item], ErrorModel>) -> ()) {
        var parsedData = [Item]()
        
        if loadMore == false { cursor = "" }
        switch sort {
        case .mostPopular:
            requestURL = RequestType.sortedByPopularity(defaultURL, UDservice.shared.nextPageCursor).url
        case .mostCommented:
            requestURL = RequestType.sortedByComments(defaultURL, UDservice.shared.nextPageCursor).url
        case .createdAt:
            requestURL = RequestType.sortedByDate(defaultURL, UDservice.shared.nextPageCursor).url
        case .notSorted:
            requestURL = RequestType.defaultRequest(defaultURL, UDservice.shared.nextPageCursor).url
        case .none:
            requestURL = RequestType.firstRequest(defaultURL).url
        }
        
        guard let requestURL = requestURL else { return }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            do {
                let postDict = try JSONDecoder().decode(PostDict?.self, from: data)
                print(requestURL)
                guard let dataToConsider = postDict?.data else {
                    completion(.failure(.invalidData))
                    return
                }
                parsedData = dataToConsider.items
                guard let cursor = dataToConsider.cursor else {
                    completion(.failure(.cursorError))
                    return
                }
                self.cursor = cursor.replacingOccurrences(of: "+", with: "%2B")
                
                completion(.success(parsedData))
                print("JSON data parsed successfully")
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

}
