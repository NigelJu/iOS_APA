//
//  PetDetailViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/7.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher

fileprivate enum PetDetailCellType: String {
    // 值為對應至SB的CellIdentifier
    case images = "detailPetImageCell"
    case baseInfo = "baseInfoCell"
    case keepers = "petKeepersCell"
}

fileprivate struct PetDetailInfo {
    var title: String?   // 標題, 除了基本資訊必有標題, 圖片及飼養者皆無標題(飼養者在SB設定了)
    var content: Any?
    var cellIdtifier = PetDetailCellType.baseInfo
    
    init(title: String?, content: Any?) {
        self.title = title
        self.content = content
    }
    init(title: String?, content: Any?, cellIdtifier : PetDetailCellType) {
        self.title = title
        self.content = content
        self.cellIdtifier = cellIdtifier
    }
}

class PetDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var petInfo = PetInfo()
    
    // 把外部給予的資訊重新調整, 讓列表可以直接用
    fileprivate var detailInfos = [PetDetailInfo]()
    
    fileprivate var petCollectionView: UICollectionView? // tableViewCell內容中的CollectView
    fileprivate var petImagePageControl: UIPageControl? // tableViewCell內容中的pageControl
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 設置title標題
        if let name = petInfo.name,
            let gender = petInfo.gender {
            title = name + gender.setGender()
        }
        
        // 將外部給予的資料, 重新組成需要的格式
        setupDetailInfos()
    
       
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
        tableView.reloadData()
    }
}

fileprivate extension PetDetailViewController {
    // 設置基本資訊
    func setupDetailInfos() {
        // 照片
        detailInfos.append(PetDetailInfo(title: nil, content: petInfo.images, cellIdtifier: PetDetailCellType.images))
        // 基本資訊
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_CHIP_CODE, content: petInfo.pet_id))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_RESOURCE, content: petInfo.src))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_BODY_TYPE, content: petInfo.body_type))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_COLOR, content: petInfo.color))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_FEATURE, content: petInfo.feature))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_VIEW, content: petInfo.view))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_PERSONALITY, content: petInfo.personality))
        detailInfos.append(PetDetailInfo(title: PET_DETAIL_TITLE_BIRTHDAY, content: petInfo.birthday))
        // 照顧人員
        detailInfos.append(PetDetailInfo(title: nil, content: petInfo.keepers, cellIdtifier: PetDetailCellType.keepers))
    }
    
    // 設置圖片的Cell
    func setupImageColectionViewCell(cell: PetDetailImagesTableViewCell) {
        // 不必做事, 因為Delegate已經交由VC去做了
    }
    
    // 設置一般資訊的Cell
    func setupBaseViewCell(cell: PetDetailBaseInfoTableViewCell, petDetailInfo: PetDetailInfo) {
        cell.titleLabel.text = petDetailInfo.title
        cell.detailLabel.text = petDetailInfo.content as? String
    }
    
    // 設置飼養者的Cell
    func setupKeepersViewCell(cell: PetDetailKeepersTableViewCell, keepers: [String]?) {
        
        // 要先清除stackView的資料, 不然會重複新增
        for labelView in cell.keepersStackView.arrangedSubviews {
            cell.keepersStackView.removeArrangedSubview(labelView)
            labelView.removeFromSuperview()
        }
        
        // 飼養者的label用code產生, 而不在SB寫
        for keeper in keepers ?? []{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.keepersStackView.bounds.width, height: 20))
            label.text = keeper
            label.numberOfLines = 0
            cell.keepersStackView.addArrangedSubview(label)
            cell.keepersStackView.layoutIfNeeded()
        }
    }
}


// MARK:- UIScrollViewDelegate
extension PetDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 設置UI資訊
        if petCollectionView == nil || petImagePageControl == nil {
            for collectionViewCell in tableView.visibleCells where collectionViewCell is PetDetailImagesTableViewCell {
                petCollectionView = (collectionViewCell as? PetDetailImagesTableViewCell)?.collectionView
                petImagePageControl = (collectionViewCell as? PetDetailImagesTableViewCell)?.pageControl
                break
            }
        }
        
        guard let currentCell = petCollectionView?.visibleCells.first,
            let indexPath = petCollectionView?.indexPath(for: currentCell)
            else { return }
        petImagePageControl?.currentPage = indexPath.row
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension PetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petDetailInfo = detailInfos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: petDetailInfo.cellIdtifier.rawValue, for: indexPath)
        
        switch petDetailInfo.cellIdtifier {
        case .images:
            setupImageColectionViewCell(cell: cell as! PetDetailImagesTableViewCell)
            return cell
            
        case .baseInfo:
            setupBaseViewCell(cell: cell as! PetDetailBaseInfoTableViewCell, petDetailInfo: petDetailInfo)
            return cell
            
        case .keepers:
            let keepers = petDetailInfo.content as? [String]
            setupKeepersViewCell(cell: cell as! PetDetailKeepersTableViewCell, keepers: keepers)
            return cell
        }
    }
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PetDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (detailInfos.first?.content as? [String])?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "petImagesCell", for: indexPath) as! PetDetailTableCollectionViewCell
        
        
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

