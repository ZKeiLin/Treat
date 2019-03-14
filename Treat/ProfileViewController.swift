//
//  ProfileViewController.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileViewControllerDelegate: class {
    func notifyTaskOfReset(sender: ProfileViewController)
}

class HistoryDataSource : NSObject, UITableViewDataSource
{
    var data : [Any] = []
    
    init(_ elements : [Any]) { data = elements }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        let currData = data[indexPath.row]

//
//        for t in user!.history! {
//            switch t {
//            case is Task: let ta = t as! Task; returnXp += Int(ta.points!)
//            default: let tr = t as! Treat; returnXp += Int(tr.points!)
//            }
//        }
//
        if currData is Task {
            let convertedData = currData as? Task
            cell.name.text = convertedData!.name
            cell.historyType.text = "Completed Task"
            cell.points.textColor = #colorLiteral(red: 0.4392156863, green: 0.1529411765, blue: 0.8156862745, alpha: 1)
            cell.points.text = "+ \(convertedData!.points!)"
        } else { // Treat
            let convertedData = currData as? Treat
            cell.name.text = convertedData!.name
            cell.historyType.text = "Redeemed Treat"
            cell.points.textColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
            cell.points.text = "- \(convertedData!.points!)"
        }
        
        return cell
    }
}

class ProfileViewController: UIViewController, UITableViewDelegate {
    // Interface Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var xpBar: UIView!
    @IBOutlet weak var xpBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    
    // Local Variables
    var user : User? = nil
    var dataSource : HistoryDataSource? = nil

    weak var delegate: ProfileViewControllerDelegate?
    
    @IBAction func backPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func reloadData() {
        print("\(self.user!.name!) has \(self.user!.points) points")
        print("Tasks")
        for t in self.user!.tasks! {
            print(t.toString())
        }
        print("History")
        print(self.user!.history!)
        
        dataSource = HistoryDataSource(self.user!.history!.reversed()) // add code for sorting?
        historyTableView.dataSource = dataSource
        historyTableView.delegate = self
        historyTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = DataFunc.fetchData()
        self.reloadData()
        
        nameLabel.text = self.user?.name
        print("Level: \(DataFunc.getLevel(user))")
        print("XP: \(DataFunc.getXp(user))")
        print("\(DataFunc.getPercentXp(user) * 100)%")

        lvlLabel.text = "Level \(DataFunc.getLevel(user))"
        pointsLabel.text = "\(self.user!.points) points"
        let currWidth : CGFloat = xpBar.frame.size.width
        xpBarConstraint.constant += currWidth - (CGFloat(DataFunc.getPercentXp(user) * 100) * ((20.0 + currWidth) / 100.0))
        // widthFor100%  - (currentPercent * widthFor1%)
        // width is 374
        // sides are 20
        // total width is 414
        
        // 0% = + (20 + 373)
        // 1% = + (20 + width) / 100
        // 100% = - 0
    }
    
    @IBAction func resetUser(_ sender: Any) {
        // Create you actionsheet - preferredStyle: .actionSheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create your actions - take a look at different style attributes
        let eraseAction = UIAlertAction(title: "Erase data", style: .destructive) { (action) in
            // Erase the data
            DataFunc.eraseData()
            self.dismiss(animated: true) {
                self.delegate?.notifyTaskOfReset(sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        // Add the actions to your actionSheet
        actionSheet.addAction(eraseAction)
        actionSheet.addAction(cancelAction)
        
        // Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
}
