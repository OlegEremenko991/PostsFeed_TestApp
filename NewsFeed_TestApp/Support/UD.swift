//
//  UD.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//
import Foundation

class UD {
    
    static let shared = UD()
    
    var nextPageCursorKey = "nextPageCursorKey" //key for cursor
    
    var nextPageCursor: String {
        get { return UserDefaults.standard.string(forKey: nextPageCursorKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: nextPageCursorKey) }
    }

}

