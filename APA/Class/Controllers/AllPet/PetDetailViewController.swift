//
//  PetDetailViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/7.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import SafariServices

class PetDetailViewController: UIViewController {

    var petInfo = PetInfo()
    var detailPetTableVC: PetDetailTableViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for vc in self.childViewControllers where vc is PetDetailTableViewController {
            detailPetTableVC = vc as? PetDetailTableViewController
            detailPetTableVC?.petInfo = petInfo
            self.title = (petInfo.name ?? "") + (petInfo.gender?.setGender() ?? "")
        }
    }
    
    
    // MARK:- IBAction
    @IBAction func adoptButtonDidTap(_ sender: Any) {
        if let petUrl = petInfo.petUrl(),
            let url = URL(string: petUrl) {
            let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func reloadButtonDidTap(_ sender: Any) {
        detailPetTableVC?.reloadCollectionView()
    }
}
