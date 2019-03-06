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
    
    var treats : [Treat] = []
    var dataSource : TreatOnlineDataSource? = nil
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row at \(indexPath)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = treats[0].category
        
        // Initialize Popular Treat Table
        dataSource = TreatOnlineDataSource(treats)
        print("treats received: \(treats)")
        treatTableView.dataSource = dataSource
        treatTableView.delegate = self
        treatTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }


}
