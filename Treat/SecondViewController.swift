//
//  FirstViewController.swift
//  Treat
//
//  Created by Liam Brozik on 2/11/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit


class TreatDataSource : NSObject, UITableViewDataSource
{
    var data : [Treat] = []
    init(_ elements : [Treat]) { data = elements }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreatOnlineCell") as! TreatOnlineCell
        let currData = data[indexPath.row]
        
        cell.name.text = currData.name
        cell.category.text = currData.category
        cell.pointsButton.setTitle(String(currData.points), for: .normal)
        cell.pointsButton.tag = indexPath.row
        
        return cell
    }
}

class SecondViewController: UIViewController, UITableViewDelegate {
    struct GlobalVariable{
        static var addedTreat : Treat? = nil
    }
    
    var treats : [Treat] = []
    var dataSource : TreatDataSource? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    func reloadData() {
        dataSource = TreatDataSource(treats)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nibs
        
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
        
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let newTreat = GlobalVariable.addedTreat
        if newTreat != nil {
            treats.append(newTreat!)
            GlobalVariable.addedTreat = nil
            self.reloadData()
        }
    }
    
}


