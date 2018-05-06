//
//  AllPetListViewControllerTableViewCell.swift
//  APA
//
//  Created by Nigel on 2018/5/6.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

protocol AllPetListViewControllerTableViewCellDelegate {
    func favoriteButtonDidTap(petInfo: PetInfo)
    func shareButtonDidTap(petInfo: PetInfo)
    
}

class AllPetListViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    var delegate: AllPetListViewControllerTableViewCellDelegate?
    
    
    @IBAction func favoriteButtonDidTap(_ sender: Any) {
        delegate?.favoriteButtonDidTap(petInfo: PetInfo())
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        delegate?.shareButtonDidTap(petInfo: PetInfo())
    }
    
}
