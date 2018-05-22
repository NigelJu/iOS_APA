//
//  Array+Codable.swift
//  APA
//
//  Created by Nigel on 2018/5/21.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

extension Array where Element: Codable {
    func initWithJsonFile(fileName: String) -> [Element]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil}
        let decoder = JSONDecoder()
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode([Element].self, from: data)
    }
}

extension Array where Element: Equatable {
    mutating func remove(_ obj: Element) {
        self = self.filter { $0 != obj }
    }
}
