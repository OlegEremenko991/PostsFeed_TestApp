//
//  SomeData.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

struct SomeData: Codable {
    var items: [Item]
    var cursor: String?
}
