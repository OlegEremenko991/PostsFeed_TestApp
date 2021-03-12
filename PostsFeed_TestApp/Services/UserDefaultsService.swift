//
//  UD.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

import Foundation

public final class UserDefaultsService {

    // MARK: - Public properties

    static let shared = UserDefaultsService()

    var nextPageCursor: String {
        get { UserDefaults.standard.string(forKey: nextPageCursorKey) ?? "" }
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
    
    // MARK: - Private properties

    /// Cursor
    private let nextPageCursorKey = "nextPageCursorKey"

    /// PostsArray
    private let postsArrayKey = "postsArrayKey"

    /// Current sort type
    private let sortTypeKey = "sortTypeKey"

}

