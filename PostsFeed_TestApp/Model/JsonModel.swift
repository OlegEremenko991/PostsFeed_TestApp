//
//  JsonModel.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 11.10.2020.
//

struct PostDict: Codable {
    var data: MainData?
}

struct MainData: Codable {
    var items: [Item]
    var cursor: String?
}

struct Item: Codable {
    var contents: [Content]
    var createdAt: Int
    var author: Author?
}

struct Content: Codable {
    var type: String
    var data: ContentData
}

struct ContentData: Codable {
    var value: String?
    var values: [String]?
}

struct Author: Codable {
    var id: String
    var name: String
    var photo: Photo?
}

struct Photo: Codable {
    var type: ExtraType
    var id: String
    var data: PhotoData
}

enum ExtraType: String, Codable {
    case image = "IMAGE"
    case tags = "TAGS"
    case text = "TEXT"
}

struct PhotoData: Codable {
    var extraSmall: PhotoProperties
    var small: PhotoProperties?
    var original: PhotoProperties
}

struct PhotoProperties: Codable {
    var url: String
}
