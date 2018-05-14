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
    func googleSheetManagerFetchPetListDidFinish(response: [PetInfo], error: NSError?)
    func googleSheetManagerFetchGolafuListDidFinish(reponse: [Garden], error: NSError?)
}

// 以此方式作optional的delegate
extension GoogleSheetManagerDelegate {
    func googleSheetManagerFetchPetListDidFinish(response: [PetInfo], error: NSError?){
    }
    
    func googleSheetManagerFetchGolafuListDidFinish(reponse: [Garden], error: NSError?) {
    }
}

class GoogleSheetManager: NSObject {

    var delegate: GoogleSheetManagerDelegate?
    
    private var reachability = Reachability(hostName: "docs.google.com")
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService() 
    private var fetchStartIndex = 2 // 起始從第2筆開始撈, googleSheet從1開始計算, 又第1筆是title
    
    override init() {
        service.apiKey = API_KEY
    }
    
    // 取得你領我養-動物列表
    func startFetchPetList() {
        // 結束位置 = 起始 + 撈取筆數 - 1, -1是因為從始起位置開始撈筆數, 會多拿1筆
        let endRowIndex = fetchStartIndex + MAX_PET_COUNT_PER_PAGE - 1

        let range = SHEET_APA + "A" + String(fetchStartIndex) + ":P" + String(endRowIndex)
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: SPREAD_SHEET_ID, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayPetListResultWithTicket(ticket:finishedWithObject:error:)))
        fetchStartIndex = endRowIndex + 1
    }
    
    // 取得狗來富-幸福花園列表
    func startFetchGolafu() {
        let range = SHEET_GOLAFU + "A2:D"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: SPREAD_SHEET_ID, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayGolafuGardenListResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // 檢查目前網路是否正常
    func isNetWorkReachable() -> Bool {
        if reachability?.currentReachabilityStatus().rawValue == 0 {
            return false
        }else {
            return true
        }
    }
    
    // 將取得的狗來富-幸福花園列表包起來, 等待其它人處理
    @objc func displayGolafuGardenListResultWithTicket(ticket: GTLRServiceTicket,
                                              finishedWithObject result : GTLRSheets_ValueRange,
                                              error : NSError?) {
        var gardens = [Garden]()
        for row in result.values ?? [] {
            if row.count == 1 {
                continue
            }
            let garden = Garden()
            garden.title = row[GardenInfoIndex.title.rawValue] as? String ?? ""
            garden.album = row[GardenInfoIndex.alubmUrl.rawValue] as? String ?? ""
            garden.visits_url = (row[GardenInfoIndex.visits_url.rawValue] as? String ?? "").components(separatedBy: ",")
            garden.visitors = (row[GardenInfoIndex.visitors.rawValue] as? String ?? "").components(separatedBy: ",")
            gardens.append(garden)
        }
        delegate?.googleSheetManagerFetchGolafuListDidFinish(reponse: gardens, error: error)
    }

    // 將取得的寵物列表包起來, 等待其它人處理
    @objc func displayPetListResultWithTicket(ticket: GTLRServiceTicket,
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
  
        delegate?.googleSheetManagerFetchPetListDidFinish(response: pets, error: error)
 
    }
    
  
}
