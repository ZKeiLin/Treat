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
    var userPts : Int = 0
    
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
        if userPts < currData.points {
            cell.pointsButton.setTitleColor(UIColor.gray, for: .normal)
        }
        cell.pointsButton.tag = indexPath.row
        
        return cell
    }
}

class SecondViewController: UIViewController, UITableViewDelegate {
    struct GlobalVariable{
        static var addedTreat : Treat? = nil
    }
    
    var user : UserProfile = UserProfile(name: "Me") // SAMPLE DATA -> REMOVE THIS
    var dataSource : TreatDataSource? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTreatAvailable: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    func reloadData() {
        noTreatAvailable.isHidden = user.treats.count == 0 ? false : true
        
        dataSource = TreatDataSource(user.treats.sorted(by: {$0.points < $1.points}))
        dataSource?.userPts = user.points
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tab Code
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
        
        // Initializing user
        user.addPoints(150) // lets give poor bob 150 points for testing
        userPointsLabel.text = "\(String(user.points)) pts"
        
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let newTreat = GlobalVariable.addedTreat
        if newTreat != nil {
            user.treats.append(newTreat!)
            GlobalVariable.addedTreat = nil
            self.reloadData()
        }
    }
}


