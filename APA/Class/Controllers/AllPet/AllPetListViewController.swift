//
//  AllPetListViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/6.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import Kingfisher

class AllPetListViewController: UIViewController {

    fileprivate let googleSheetManager = GoogleSheetManager()
    fileprivate var petInfos = [PetInfo]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSheetManager.delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        googleSheetManager.startFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let petDetailVC = segue.destination as? PetDetailViewController,
            let petInfo = sender as? PetInfo {
            petDetailVC.petInfo = petInfo
        }
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension AllPetListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petInfos.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as! AllPetListViewControllerTableViewCell
        cell.delegate = self
        let petInfo = petInfos[indexPath.row]
        
        if let name = petInfo.name,
            let gender = petInfo.gender {
            cell.nameLabel.text = name + gender.setGender()
            cell.nameLabel.textColor = gender == .femail ? .red : .blue
        }
        cell.locationLabel.text = petInfo.location
        
        
        let imgUrl = URL(string: petInfo.images?.first ?? "")
        cell.petImageView.kf.setImage(with: imgUrl,
                                      placeholder: nil,
                                      options: [.transition(ImageTransition.fade(1))],
                                      progressBlock: nil,
                                      completionHandler: nil)
      

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "petDetail", sender: petInfos[indexPath.row])
    }
    
    
}

// MARK:- AllPetListViewControllerTableViewCellDelegate
extension AllPetListViewController: AllPetListViewControllerTableViewCellDelegate {
    
    func favoriteButtonDidTap(petInfo: PetInfo) {
        print("favoriteButtonDidTap")
    }
    
    func shareButtonDidTap(petInfo: PetInfo) {
        print("shareButtonDidTap")
        print("fetchTest")
        googleSheetManager.startFetch()
    }
}

// MARK:- GoogleSheetManagerDelegate
extension AllPetListViewController: GoogleSheetManagerDelegate {
    func googleSheetManagerFetchDidFinish(petInfos: [PetInfo], error: NSError?) {
        
        print(petInfos.count)
        self.petInfos = petInfos
        tableView.reloadData()
        
    }
}
