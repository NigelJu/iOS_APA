//
//  Pet.swift
//  APA
//
//  Created by Nigel on 2018/5/6.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

enum PetInfoIndex: Int {
    case keepers
    case images
    case pet_id
    case src
    case state
    case body_type
    case location
    case color
    case race
    case feature
    case name
    case view
    case gender
    case personality
    case birthday      
}

enum PetGender: String {
    case femail = "母"
    case male = "公"
    
    func setGender() -> String {
        switch self {
        case .femail:
            return "(♁)"
        case .male:
            return "(♂︎)"
        }
    }
}

class PetInfo {
    
    var keepers: [String]? // 不只一個人在養
    var images: [String]? // 圖最多有3張
    var pet_id: String?
    var src: String?  // 來源, 從哪裡拯救的
    var state: String?    // 狀態
    var body_type: String?    // 動物體型
    var location: String?    // 犬舍位置
    var color: String?    // 毛色
    var race: String?    // 動物類別
    var feature: String?    // 特徵
    var name: String?    // 呼名
    var view: String?    // 外型
    var gender: PetGender?    // 性別
    var personality: String?    // 個性
    var birthday: String?    // 出生年份
    
}
