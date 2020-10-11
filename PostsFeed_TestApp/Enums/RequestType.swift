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
        return URL(string: stringURL)
    }
    
    var stringURL: String {
        switch self {
        case .firstRequest(let defaultURL):
            return defaultURL
        case .sortedByDate(let defaultURL, let cursor):
            if cursor != "" {
                return defaultURL + "?orderBy=createdAt" + "&after=" + cursor
            } else {
                return defaultURL + "?orderBy=createdAt"
            }
        case .sortedByPopularity(let defaultURL, let cursor):
            if cursor != "" {
                return defaultURL + "?orderBy=mostPopular" + "&after=" + cursor
            } else {
                return defaultURL + "?orderBy=mostPopular"
            }
        case .sortedByComments(let defaultURL, let cursor):
            if cursor != "" {
                return defaultURL + "?orderBy=mostCommented" + "&after=" + cursor
            } else {
                return defaultURL + "?orderBy=mostCommented"
            }
        case .defaultRequest(let defaultURL, let cursor):
            if cursor != "" {
                return defaultURL + "?after=" + cursor
            } else {
                return defaultURL
            }
        }
    }

}
