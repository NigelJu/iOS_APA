//
//  AllPetListViewControllerTableViewCell.swift
//  APA
//
//  Created by Nigel on 2018/5/6.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

protocol AllPetListViewControllerTableViewCellDelegate {
    func favoriteButtonDidTap(button: UIButton, petInfo: PetInfo)
    func shareButtonDidTap(button: UIButton, petInfo: PetInfo)
    
}

class AllPetListViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var faviriteButton: UIButton!
    
    var delegate: AllPetListViewControllerTableViewCellDelegate?
    var petInfo = PetInfo()
    
    @IBAction func favoriteButtonDidTap(_ sender: UIButton) {
        delegate?.favoriteButtonDidTap(button: sender, petInfo: petInfo)
    }
    
    @IBAction func shareButtonDidTap(_ sender: UIButton) {
        delegate?.shareButtonDidTap(button: sender, petInfo: petInfo)
    }
    
    deinit {
        print("gg")
    }
    
}
