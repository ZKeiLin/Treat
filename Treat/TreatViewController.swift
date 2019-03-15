//
//  TreatViewController.swift
//  Treat
//
//  Created by Liam Brozik on 2/11/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData

class TreatDataSource : NSObject, UITableViewDataSource
{
    var data : [Treat] = []
    var userPts : Int = 0
    var user: User? = nil
    
    init(_ elements : [Treat]) { data = elements }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            user = DataFunc.fetchData()
            self.user?.treats? = data
            PersistenceService.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade
            )
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreatOnlineCell") as! TreatOnlineCell
        let currData = data[indexPath.row]
        
        cell.name.text = currData.name
        cell.category.text = currData.category
        
        var color : UIColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
        var buttEnabled : Bool = true
        if userPts < currData.points { // If you can't redeem, disabled button
            color = UIColor.gray
            buttEnabled = false
        }
        
        cell.pointsButton.setTitleColor(color, for: .normal)
        cell.pointsButton.isEnabled = buttEnabled
        cell.pointsButton.setTitle(String(currData.points), for: .normal)
        cell.pointsButton.tag = indexPath.row
        
        return cell
    }
}

class TreatViewController: UIViewController, UITableViewDelegate {
    struct GlobalVariable{
        static var addedTreat : Treat? = nil
    }
    
    var user : User? = nil
    var dataSource : TreatDataSource? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTreatAvailable: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "treatAddSegue" {
            let treatAddViewNav = segue.destination as! UINavigationController
            let treatAddView = treatAddViewNav.topViewController as! AddTreatViewController
            treatAddView.userTreats = user!.treats!
            print("User Treats: \(treatAddView.userTreats)")
        }
        else if segue.identifier == "treatLevelSegue" {
            let levelViewController = segue.destination as! LevelViewController
            levelViewController.user = self.user
        }
    }
    
    func useTreat(_ treat : Treat) {
        if self.user!.points - Int32(treat.points) >= 0 {
            self.user!.points -= Int32(treat.points)
            self.user!.history?.append(treat)
        }
    }
    
    @IBAction func completeTreat (_ sender : UIButton) {
        let currLevel = DataFunc.getLevel(user)
        useTreat(user!.treats![sender.tag])
        PersistenceService.saveContext()
        self.reloadData()
        
        // Check for levelup
        let newLevel = DataFunc.getLevel(self.user)
        if newLevel != currLevel { self.performSegue(withIdentifier: "treatLevelSegue", sender: nil) }
    }
    
    func reloadData() {
        // Print current status
        print("\(self.user!.name!) has \(self.user!.points) points")
        print("Treats")
        for t in self.user!.treats! {
            print(t.toString())
        }
        print("History")
        print(self.user!.history!)
        
        userPointsLabel.text = "\(String(self.user!.points)) pts"
        noTreatAvailable.isHidden = self.user!.treats!.count == 0 ? false : true
        self.user!.treats = self.user!.treats?.sorted(by: {$0.points < $1.points})
        
        dataSource = TreatDataSource(self.user!.treats!)
        dataSource?.userPts = Int(self.user!.points)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = DataFunc.fetchData()
        self.reloadData()
        
        
        //
        // Misc Setup
        // Tab Code
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Update the points when moving from Tasks to Treats
        self.user = DataFunc.fetchData()
        self.reloadData()
        
        let newTreat = GlobalVariable.addedTreat
        if newTreat != nil {
            self.user?.treats?.append(newTreat!)
            GlobalVariable.addedTreat = nil
            
            PersistenceService.saveContext()
            self.reloadData()
        }
    }
}
