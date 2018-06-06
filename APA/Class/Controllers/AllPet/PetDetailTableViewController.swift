//
//  PetDetailTableViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/7.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import Kingfisher

class PetDetailTableViewController: UITableViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var keeperStackView: UIStackView!
    
    @IBOutlet weak var petCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var petInfo = PetInfo() {
        didSet {
            setupPetInfo()
        }
    }
    
    func reloadCollectionView(){
        petCollectionView.reloadData()
    }

    fileprivate func setupPetInfo() {
        idLabel.text = petInfo.pet_id
        sourceLabel.text = petInfo.src
        bodyLabel.text = petInfo.body_type
        locationLabel.text = petInfo.location
        colorLabel.text = petInfo.color
        featureLabel.text = petInfo.feature
        viewLabel.text = petInfo.view
        personalityLabel.text = petInfo.personality
        birthdayLabel.text = petInfo.birthday
        
        pageControl.numberOfPages = petInfo.images?.count ?? 0
        
        guard let keepers = petInfo.keepers else { return }

        // 飼養者的label用code產生, 而不在SB寫
        for keeper in keepers {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            label.text = keeper
            label.numberOfLines = 0
            keeperStackView.addArrangedSubview(label)
            keeperStackView.layoutIfNeeded()
        }
    }
    
}

// MARK:- UIScrollViewDelegate
extension PetDetailTableViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let currentCell = petCollectionView.visibleCells.first,
            let indexPath = petCollectionView.indexPath(for: currentCell)
            else { return }
        pageControl.currentPage = indexPath.row
    }
}



// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PetDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petInfo.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "petImages", for: indexPath) as! PetDetailTableViewCollectionViewCell
        
       
        if let imgLink = petInfo.images?[indexPath.row],
            let url = URL(string: imgLink) {
            let placeHolder = UIImage(named: "img_loading_place_holder")
            let resource = ImageResource(downloadURL: url, cacheKey: imgLink)
            cell.blurImageView.kf.setImage(with: resource)
            cell.imageView.kf.setImage(with: resource,
                                          placeholder: placeHolder,
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
