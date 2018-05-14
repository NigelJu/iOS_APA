//
//  GardenListViewController.swift
//  APA
//
//  Created by Nigel on 2018/5/13.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class GardenListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var googleSheetManager = GoogleSheetManager()
    var gardens = [Garden]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSheetManager.delegate = self
        updateGardenList()
    }
    
    private func updateGardenList(){
        activityIndicatorView.startAnimating()
        if googleSheetManager.isNetWorkReachable() == true {
            googleSheetManager.startFetchGolafu()
        }else {
            UIAlertController.alert(message: NET_WORK_FAIL)
                .show(currentVC: self)
        }
    }
    
    @IBAction func reloadBarButtonDidTap(_ sender: Any) {
        updateGardenList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gardenDetailVC = segue.destination as? GardenDetailListViewController,
            let didSelectIndex = tableView.indexPathForSelectedRow?.row {
            gardenDetailVC.gardenInfo = gardens[didSelectIndex]
        }
    }
}

extension GardenListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gardens.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "garden", for: indexPath)
        cell.textLabel?.text = gardens[indexPath.row].title
        return cell
    }
}

extension GardenListViewController: GoogleSheetManagerDelegate {
    func googleSheetManagerFetchGolafuListDidFinish(reponse: [Garden], error: NSError?) {
        activityIndicatorView.stopAnimating()
        gardens = reponse
        tableView.reloadData()
    }
}
