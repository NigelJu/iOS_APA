//
//  About.swift
//  APA
//
//  Created by Nigel on 2018/5/21.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class About: Codable {
    // 標題
    var headTitle: String?
    // 詳細內容
    var detail: [AboutDetail]?
    // 需要展開的index
    var expands: [Int]?
}


class AboutDetail: Codable {
    // 標題
    var title: String?
    // 內容
    var content: String?
    // 動作類型
    var action: ActionStyle?
    // 可伸展
    var isExpand: Bool?
}



enum ActionStyle: String, Codable {
    case link       // 網址
    case pdf        // 文件
    case expand     // 伸展型, 內容用伸展的Cell實作
    case comment    // 幫App評價
    case other
}
