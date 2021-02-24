//
//  RequestType.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 11.10.2020.
//

import Foundation

enum RequestType {
    case firstRequest(String)
    case sortedByPopularity(String, String)
    case sortedByComments(String, String)
    case sortedByDate(String, String)
    case defaultRequest(String, String)
    
    // MARK: Public properties
    
    var url: URL? {
        URL(string: stringURL)
    }

    // MARK: - Private properties

    private var stringURL: String {
        switch self {
        case .firstRequest(let defaultURL):
            return defaultURL
        case .sortedByDate(let defaultURL, let cursor):
            return cursor != "" ? defaultURL + "?orderBy=createdAt" + "&after=" + cursor
                                : defaultURL + "?orderBy=createdAt"
        case .sortedByPopularity(let defaultURL, let cursor):
            return cursor != "" ? defaultURL + "?orderBy=mostPopular" + "&after=" + cursor
                                : defaultURL + "?orderBy=mostPopular"
        case .sortedByComments(let defaultURL, let cursor):
            return cursor != "" ? defaultURL + "?orderBy=mostCommented" + "&after=" + cursor
                                : defaultURL + "?orderBy=mostCommented"
        case .defaultRequest(let defaultURL, let cursor):
            return cursor != "" ? defaultURL + "?after=" + cursor
                                : defaultURL
        }
    }

}
