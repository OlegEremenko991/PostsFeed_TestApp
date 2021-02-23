//
//  ErrorModel.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 11.10.2020.
//

import Foundation

enum ErrorType: String, Error {
    case decodingError = "Could not decode JSON"
    case requestFailed = "The request failed, check your Internet connection"
    case invalidData = "The data is invalid"
    case cursorError = "Cursor is invalid"
}
