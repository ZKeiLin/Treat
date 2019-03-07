//
//  TreatCategoryViewController.swift
//  Treat
//
//  Created by Kelden Lin on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit

class TreatCategoryViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var treatTableView: UITableView!
    
    var userTreats : [Treat] = []
    var treats : [Treat] = []
    var dataSource : TreatOnlineDataSource? = nil
    
    @IBAction func addTreat (_ sender : UIButton) {
        SecondViewController.GlobalVariable.addedTreat = treats[sender.tag]
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = treats[0].category
        
        // Initialize Popular Treat Table
        dataSource = TreatOnlineDataSource(treats)
        dataSource?.userTreats = userTreats
        treatTableView.dataSource = dataSource
        treatTableView.delegate = self
        treatTableView.reloadData()
    }
}
