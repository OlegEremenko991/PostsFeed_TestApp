//
//  String_Extension.swift
//  PostsFeed_TestApp
//
//  Created by Олег Еременко on 22.09.2020.
//

extension String {
    func withReplacedCharacters(_ oldChar: String, by newChar: String) -> String {
        let newStr = self.replacingOccurrences(of: oldChar, with: newChar, options: .literal, range: nil)
        return newStr
    }
}
