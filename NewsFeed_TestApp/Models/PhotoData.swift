//
//  PhotoData.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

struct PhotoData: Codable {
    var extraSmall: PhotoProperties
    var small: PhotoProperties?
    var original: PhotoProperties
}
