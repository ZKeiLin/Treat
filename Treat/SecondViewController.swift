//
//  FirstViewController.swift
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
            cell.pointsButton.isEnabled = false
        }
        cell.pointsButton.tag = indexPath.row
        
        return cell
    }
}

class SecondViewController: UIViewController, UITableViewDelegate {
    struct GlobalVariable{
        static var addedTreat : Treat? = nil
    }
    
    var user : User? = nil
    var dataSource : TreatDataSource? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTreatAvailable: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check which cell is pressed, and send over data
        if segue.identifier == "treatAddSegue" {
            let treatAddViewNav = segue.destination as! UINavigationController
            let treatAddView = treatAddViewNav.topViewController as! AddTreatViewController
            treatAddView.userTreats = user!.treats!
            print("User Treats: \(treatAddView.userTreats)")
        }
    }
    
    func useTreat(_ treat : Treat) {
        if self.user!.points - Int32(treat.points) >= 0 {
            self.user!.points -= Int32(treat.points)
            self.user!.history?.append(treat)
        }
    }
    
    @IBAction func completeTreat (_ sender : UIButton) {
        useTreat(user!.treats![sender.tag])
        PersistenceService.saveContext()
        print("complete!")
        self.reloadData()
    }
    
    func reloadData() {
//        userPointsLabel.text = "\(String(user.points)) pts"
//        noTreatAvailable.isHidden = user.treats.count == 0 ? false : true
//
//        dataSource = TreatDataSource(user.treats.sorted(by: {$0.points < $1.points}))
//        dataSource?.userPts = user.points
//        tableView.dataSource = dataSource
//        tableView.delegate = self
//        tableView.reloadData()
        // Print current status
        print("\(self.user!.name) has \(self.user!.points) points")
        print("Treats")
        for t in self.user!.treats! {
            print(t.toString())
        }
        print("History")
        print(self.user!.history)
        
        userPointsLabel.text = "\(String(self.user!.points)) pts"
        noTreatAvailable.isHidden = self.user!.treats!.count == 0 ? false : true
        self.user!.treats = self.user!.treats?.sorted(by: {$0.points < $1.points})
        
        dataSource = TreatDataSource(self.user!.treats!) // add code for sorting?
        dataSource?.userPts = Int(self.user!.points)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEW DID LOAD RAN")
        // Fetch Data from Coredata
//        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
//        do {
//            var result = try PersistenceService.context.fetch(fetchRequest)
//            print("THERE ARE \(result.count) USER PROFILES")
//
//            for data in result{
//                print(data.name)
//                for t in data.tasks! {
//                    print(t.toString())
//                }
//            }
//
//            self.user = result[0]
//            dataSource = TreatDataSource(self.user!.treats!)
//        } catch {
//            print("FATAL: Couldn't fetch Coredta")
//        }
        
        self.user = DataFunc.fetchData()
        dataSource = TreatDataSource(self.user!.treats!)
        self.reloadData()
        
        // Tab Code
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Update the points when moving from Tasks to Treats
        self.user = DataFunc.fetchData()
        dataSource = TreatDataSource(self.user!.treats!)
        self.reloadData()
        
        let newTreat = GlobalVariable.addedTreat
        if newTreat != nil {
//            user.treats.append(newTreat!)
            self.user?.treats?.append(newTreat!)
            GlobalVariable.addedTreat = nil
            
            PersistenceService.saveContext()
            self.reloadData()
        }
    }
}


