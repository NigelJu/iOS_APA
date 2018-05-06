//
//  GoogleSheetManager.swift
//  APA
//
//  Created by Nigel on 2018/4/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

// manager google sheet
// provide fetch google sheet info
class GoogleSheetManager: NSObject {

    
    var didFinish: ((_ petInfo: PetInfo) -> Void)?
    
    
    
    private let SPREAD_SHEET_ID = "1PF0sUjwA2JOlsIu-fvnK2lAopGTN9a6weiNuLtAMhIU"
    private let API_KEY = "AIzaSyDbWthvXPcJ8VVjVqu25lcPVeoVTYckvfg"
    private let SHEET_NAME = "SheetAPA!"
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    
    
    /*
    private static var sheetManager: GoogleSheetManager?
    
    static func sharedInstance() -> GoogleSheetManager {
        if sheetManager == nil {
            sheetManager = GoogleSheetManager()
        }
        return sheetManager!
    }
    */
    
    override init() {
        print("init")
        service.apiKey = API_KEY
    }
    
    func getAnimalInfos(withCount count: Int) {
        let range = SHEET_NAME + "A2:P" + "20"
        
        
        print("go")
        
        
        
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: SPREAD_SHEET_ID, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))

    }
  

    
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRSheets_ValueRange,
                                       error : NSError?) {
        
        let pet = PetInfo()
        didFinish?(pet)
        
        var majorsString = ""
        let rows = result.values!
        
        
        
        
        majorsString += "Name, Major:\n"
        for row in rows {
            let name = row[0]
            let major = row[4]
            
            majorsString += "\(name), \(major)\n"
            print(majorsString)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
}
