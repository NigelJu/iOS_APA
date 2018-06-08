//
//  PetDetailTableCollectionTableViewCell.swift
//  APA
//
//  Created by Nigel on 2018/6/7.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

// 單純放CollectionView的Cell, CollectionView的資料設置由VC完成
class PetDetailImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    

}
