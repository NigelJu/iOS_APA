//
//  GardenDetailListViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/13.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import SafariServices

class GardenDetailListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var gardenInfo = Garden()
    

    
    @IBAction func albumBarButtonDidTap(_ sender: Any) {
        if let url = URL(string: gardenInfo.album) {
            let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(safariVC, animated: true, completion: nil)
        }else {
            UIAlertController.alert(title: ALERT_CONTROLLER_ERROR,
                                    message: ALERT_CONTROLLER_ERROR_WITH_GARDEN_ALBUM)
                .otherHandle(alertAction: nil)
                .show(currentVC: self)
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension GardenDetailListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gardenInfo.visits_url.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitorCell", for: indexPath)
        cell.textLabel?.text = gardenInfo.visitors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var visitLink = gardenInfo.visits_url[indexPath.row]
        if !visitLink.contains(GOLAFU_GARDEN_DETAIL_URL_PREFFIX) {
            visitLink = GOLAFU_GARDEN_DETAIL_URL_PREFFIX + visitLink
        }
        if let url = URL(string: visitLink) {
            let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}
