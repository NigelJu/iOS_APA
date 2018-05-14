//
//  Garden.swift
//  APA
//
//  Created by Nigel on 2018/5/14.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

// 順序對應Excel
enum GardenInfoIndex: Int {
    case title
    case alubmUrl
    case visits_url
    case visitors
}

class Garden {
    // 家園名稱
    var title = ""
    // 相簿網址
    var album = ""
    // 探訪網址
    var visits_url = [String]()
    //探訪者
    var visitors = [String]()
}
