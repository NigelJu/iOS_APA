//
//  UserDefaultManager.swift
//  APA
//
//  Created by Nigel on 2018/5/8.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class UserDefaultManager {

    static let shareInstance = UserDefaultManager()
    
    func addFavorite(fromID id: String) {
        UserDefaults.standard.set(id, forKey: id)
    }
    
    func removeFavorite(fromID id: String) {
        UserDefaults.standard.removeObject(forKey: id)
    }
    
    func isFavorite(withDogID id: String) -> Bool {
        if let _ =  UserDefaults.standard.value(forKey: id) {
            return true
        }
        return false
    }
    
}
