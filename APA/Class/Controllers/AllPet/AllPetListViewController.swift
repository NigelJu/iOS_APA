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
        
        self.googleSheetManager.startFetch()
        
        // 滾到底觸發拉資料
        tableView.addInfiniteScroll { [weak self] (tableView) -> Void in
            if self?.googleSheetManager.isNetWorkReachable() == true {
                self?.googleSheetManager.startFetch()
                tableView.finishInfiniteScroll()
            }else {
                UIAlertController.alert(message: NET_WORK_FAIL)
                    .show(currentVC: self)
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        cell.petInfo = petInfo
        
        if let name = petInfo.name,
            let gender = petInfo.gender {
            cell.nameLabel.text = name + gender.setGender()
            cell.nameLabel.textColor = gender == .femail ? .red : .blue
        }
        cell.locationLabel.text = petInfo.location
        cell.faviriteButton.isSelected = UserDefaultManager.shareInstance.isFavorite(withDogID: (petInfo.pet_id ?? ""))
        
        
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
    
    func favoriteButtonDidTap(button: UIButton, petInfo: PetInfo) {
        guard let petID = petInfo.pet_id else { return }
        let isFavorite = UserDefaultManager.shareInstance.isFavorite(withDogID: petID)
        if isFavorite {
            UserDefaultManager.shareInstance.removeFavorite(fromID: petID)
        }else {
            UserDefaultManager.shareInstance.addFavorite(fromID: petID)
        }
        
        button.isSelected = !isFavorite
        
        print("favoriteButtonDidTap")
    }
    
    func shareButtonDidTap(button: UIButton, petInfo: PetInfo) {
        print("shareButtonDidTap")
        print("fetchTest")
        
    }
}

// MARK:- GoogleSheetManagerDelegate
extension AllPetListViewController: GoogleSheetManagerDelegate {
    func googleSheetManagerFetchDidFinish(response: [PetInfo], error: NSError?) {
        
        let startPetIndex = self.petInfos.count
        let (start, end) = (startPetIndex, response.count + startPetIndex)
        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
        
        self.petInfos += response
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()

    }
}
