//
//  AllPetListViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/6.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class AllPetListViewController: UIViewController {

    fileprivate let MAX_PET_COUNT_PER_PAGE = 20
    fileprivate let googleSheetManager = GoogleSheetManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        GoogleSheetManager.sharedInstance().getAnimalInfos(withCount: MAX_PET_COUNT_PER_PAGE)
        
        
        
        googleSheetManager.getAnimalInfos(withCount: 20)
        googleSheetManager.didFinish = { [weak self] petInfos in
            
            print("hihi")
            print(petInfos)
            
        }
        
        
    }

    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension AllPetListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MAX_PET_COUNT_PER_PAGE
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as! AllPetListViewControllerTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
}

// MARK:- AllPetListViewControllerTableViewCellDelegate
extension AllPetListViewController: AllPetListViewControllerTableViewCellDelegate {
    
    func favoriteButtonDidTap(petInfo: PetInfo) {
        print("favoriteButtonDidTap")
    }
    
    func shareButtonDidTap(petInfo: PetInfo) {
        print("shareButtonDidTap")
    }
}
