//
//  GoogleSheetManager.swift
//  APA
//
//  Created by Nigel on 2018/4/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

/*
 提供googleSheet的撈取資料功能
 
 1. 使用fetch去驅動撈資料的動作
 2. 使用delegate操作所撈下的寵物資料
 
*/

protocol GoogleSheetManagerDelegate {
    func googleSheetManagerFetchDidFinish(petInfos: [PetInfo], error: NSError?)
}

class GoogleSheetManager: NSObject {

    var delegate: GoogleSheetManagerDelegate?
    
    
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService() 
    private var fetchStartIndex = 20 // 起始從第2筆開始撈, googleSheet從1開始計算, 又第1筆是title
    private var fetchCount = 0  // 撈取的次數
    
    override init() {
        service.apiKey = API_KEY
    }
    
    func startFetch() {
        // 起始位置 = 沒撈過資料則為預設值, 如果撈過資料就(撈的次數 * 最大筆數 + 1)
        let startRowIndex = fetchCount == 0 ?
            fetchStartIndex : fetchCount * MAX_PET_COUNT_PER_PAGE + 1
        
        // 結束位置 = 起始 + 撈取筆數
        let endRowIndex = startRowIndex + MAX_PET_COUNT_PER_PAGE
        
        let range = SHEET_NAME + "A" + String(startRowIndex) + ":P" + String(endRowIndex)
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: SPREAD_SHEET_ID, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        
        fetchCount += 1

    }
  

    
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRSheets_ValueRange,
                                       error : NSError?) {
        
       
        var pets = [PetInfo]()
        
        for row in result.values ?? [] {
            let pet = PetInfo()
            pet.keepers = (row[PetInfoIndex.keepers.rawValue] as? String)?.components(separatedBy: ",")
            pet.images = (row[PetInfoIndex.images.rawValue] as? String)?.components(separatedBy: ",")
            pet.pet_id = row[PetInfoIndex.pet_id.rawValue] as? String
            pet.src = row[PetInfoIndex.src.rawValue] as? String
            pet.state = row[PetInfoIndex.state.rawValue] as? String
            pet.body_type = row[PetInfoIndex.body_type.rawValue] as? String
            pet.location = row[PetInfoIndex.location.rawValue] as? String
            pet.color = row[PetInfoIndex.color.rawValue] as? String
            pet.race = row[PetInfoIndex.race.rawValue] as? String
            pet.feature = row[PetInfoIndex.feature.rawValue] as? String
            pet.name = row[PetInfoIndex.name.rawValue] as? String
            pet.view = row[PetInfoIndex.view.rawValue] as? String
            let gender = row[PetInfoIndex.gender.rawValue] as? String
            pet.gender = PetGender(rawValue: gender ?? "")
            pet.personality = row[PetInfoIndex.personality.rawValue] as? String
            pet.birthday = row[PetInfoIndex.birthday.rawValue] as? String
            
            pets.append(pet)
        }
  
        delegate?.googleSheetManagerFetchDidFinish(petInfos: pets, error: error)
 
    }
    
  
}
