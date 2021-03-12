//
//  DataLoader.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

public final class NetworkService {

    /// Loads posts with chosen sortType
    static func loadPosts(sort: SortType? = nil, loadMore: Bool? = nil, completion: @escaping (Result<[Item], ErrorType>) -> ()) {
        let defaultURL = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
        var requestURL: URL?
        
        if loadMore == false { UserDefaultsService.shared.nextPageCursor = "" }
        
        switch sort {
        case .mostPopular:
            requestURL = RequestType.sortedByPopularity(defaultURL, UserDefaultsService.shared.nextPageCursor).url
        case .mostCommented:
            requestURL = RequestType.sortedByComments(defaultURL, UserDefaultsService.shared.nextPageCursor).url
        case .createdAt:
            requestURL = RequestType.sortedByDate(defaultURL, UserDefaultsService.shared.nextPageCursor).url
        case .notSorted:
            requestURL = RequestType.defaultRequest(defaultURL, UserDefaultsService.shared.nextPageCursor).url
        case .none:
            requestURL = RequestType.firstRequest(defaultURL).url
        }
        
        let task = URLSession.shared.dataTask(with: requestURL!) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            do {
                let postDict = try JSONDecoder().decode(PostDict?.self, from: data)
                guard let mainData = postDict?.data else {
                    completion(.failure(.invalidData))
                    return
                }
                var parsedData = [Item]()
                parsedData = mainData.items
    
                guard let cursor = mainData.cursor else {
                    completion(.failure(.cursorError))
                    return
                }
                UserDefaultsService.shared.nextPageCursor = cursor.replacingOccurrences(of: "+", with: "%2B")
                completion(.success(parsedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

}
