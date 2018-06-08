//
//  PetDetailTableViewCollectionViewCell.swift
//  APA
//
//  Created by Nigel on 2018/5/7.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

// PetDetailCollectionTableViewCell內的CollectionView
// 裡頭放兩張圖片, 避免萬一圖案不是1:1時會有變形的問題
// imageView: 用於正常顯示(在SB中設定fit)
// blurImageView: 當圖片比例非1:1時, 直接塞滿(fill), 但在SB放了blur圖層, 讓畫面仍然可以被填滿, 但又不會比例壞掉
class PetDetailTableCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurImageView: UIImageView!
    
}
