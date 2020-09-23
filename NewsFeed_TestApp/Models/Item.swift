//
//  Item.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

struct Item: Codable {
    var contents: [Content]
    var createdAt: Int
    var author: Author?
}
