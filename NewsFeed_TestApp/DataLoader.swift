//
//  DataLoader.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

public class DataLoader {
    
    func loadPosts(_ completion: @escaping ([Item]) -> Void) {
        let jsonDecoder = JSONDecoder()
        var parsedData2 = [Item]()
        
        let url = URL(string: "http://stage.apianon.ru:3000/fs-posts/v1/posts")!
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let jsonData = data {
                do {
                    let dataFromJson = try jsonDecoder.decode(JsonData.self, from: jsonData)
        //            print(dataFromJson.data.items[0].createdAt)
        //            print(dataFromJson.data.items[0].author?.name)
        //            print(dataFromJson.data.items[0].contents)
                    parsedData2 = dataFromJson.data.items
                    print("parsing data method: " + "\(parsedData2.count)")
                    DispatchQueue.main.async {
                        completion(parsedData2)
                    }
                } catch {
                    print(error)
                }
            } else {
                print("Network error!")
            }
        }
        dataTask.resume()
    }

}

// MARK: - Welcome
struct JsonData: Codable {
    var data: SomeData
}

// MARK: - SomeData
struct SomeData: Codable {
    var items: [Item]
    var cursor: String?
}

// MARK: - Item
struct Item: Codable {
    var contents: [Content]
    var createdAt, updatedAt: Int
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

// MARK: - Author
struct Author: Codable {
    var name: String
}

//enum BannerType: String, Codable {
//    case image = "IMAGE"
//    case tags = "TAGS"
//    case text = "TEXT"
//}
