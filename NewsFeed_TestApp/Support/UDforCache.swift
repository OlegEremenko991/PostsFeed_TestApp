//
//  UD.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//
import Foundation

final class UDforCache {

    static let shared = UDforCache()
    
    private let nextPageCursorKey = "nextPageCursorKey" //key for cursor
    private let postsArrayKey = "postsArrayKey" // key for posts array
    private let sortTypeKey = "sortTypeKey" // key for current sort type
    
    var nextPageCursor: String {
        get { return UserDefaults.standard.string(forKey: nextPageCursorKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: nextPageCursorKey) }
    }
    
    var postsArray: [Item] {
        get {
            guard let encodedData = UserDefaults.standard.array(forKey: postsArrayKey) as? [Data] else {
                return []
            }
            return encodedData.map { try! JSONDecoder().decode(Item.self, from: $0) }
        }
        
        set {
            let data = newValue.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: postsArrayKey)
        }
    }
    
    var currentSortType: String {
        get {
            guard let sortTypeRawValue = UserDefaults.standard.string(forKey: sortTypeKey) else { return "notSorted" }
            return SortType(rawValue: sortTypeRawValue)!.rawValue
        }
        set { UserDefaults.standard.set(newValue, forKey: sortTypeKey) }
    }

}

