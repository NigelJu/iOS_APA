//
//  AboutListViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/21.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class AboutListViewController: UIViewController {
    
    var abouts: [About]?
    fileprivate let unexpandCellIdentifier = "titleCell"
    fileprivate let expandCellIdentifier = "contentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abouts = [About]().initWithJsonFile(fileName: ABOUT_JSON_FILE_NAME)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfUsingWebViewVC = segue.destination as? PdfUsingWebViewViewController,
            let (title, fileName) = sender as? (String, String) {
            pdfUsingWebViewVC.title = title
            pdfUsingWebViewVC.fileName = fileName
        }
    }
}

// MARK:- fileprivate
fileprivate extension AboutListViewController {
    // 給App評分, 10.3+版本才有內評
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }else {
            guard let url = URL(string: APA_DOWNLOAD),
                UIApplication().canOpenURL(url) else { return }
            UIApplication().open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openLink(link: String?) {
        if let link = link,
            let url = URL(string: link) {
            let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension AboutListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return abouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abouts?[section].detail?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = abouts?[indexPath.section].expands?.contains(indexPath.row) == true ?
            expandCellIdentifier : unexpandCellIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AboutTableViewCell
        let aboutSection = abouts?[indexPath.section]
        cell.titleLabel.text = aboutSection?.detail?[indexPath.row].title
        if identifier == expandCellIdentifier {
            cell.contentLabel.text = aboutSection?.detail?[indexPath.row].content
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return abouts?[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let didSelectItem = abouts?[indexPath.section].detail?[indexPath.row] else { return }
        
        switch didSelectItem.action {
        case .comment?:
            rateApp()
        case .pdf?:
            let info = (didSelectItem.title, didSelectItem.content)
            performSegue(withIdentifier: "pdfSegue", sender: info)
        case .link?:
            openLink(link: didSelectItem.content)
        case .expand?:
            if abouts?[indexPath.section].expands?.contains(indexPath.row) == true {
               abouts?[indexPath.section].expands?.remove(indexPath.row)
            }else {
                abouts?[indexPath.section].expands?.append(indexPath.row)
            }
            let indexSet = IndexSet(integer: indexPath.section)
            tableView.reloadSections(indexSet, with: .automatic)
        default:
            break
        }
        
        
        
        
        
        
        
    }
}
