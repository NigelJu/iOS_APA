//
//  ViewController.swift
//  APA
//
//  Created by Nigel on 2018/4/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class ViewController: UIViewController {

    private let SPREAD_SHEET_ID = "1PF0sUjwA2JOlsIu-fvnK2lAopGTN9a6weiNuLtAMhIU"
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    
    private let service = GTLRSheetsService()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMajors()
    }
    
    // Display (in the UITextView) the names and majors of students in a sample
    // spreadsheet:
    // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    func listMajors() {
       
        let spreadsheetId = SPREAD_SHEET_ID
        let range = "SheetAPA!A2:P"
        
        service.apiKey = "AIzaSyDbWthvXPcJ8VVjVqu25lcPVeoVTYckvfg"
        
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRSheets_ValueRange,
                                       error : NSError?) {
        
        
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

