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
    var id : Int = 0
    var data : [Int: (Int, String)] = [Int: (Int, String)]()
    
    override init() {
        data[id] = (0, "New")
        id += 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    // Code for Swipe right to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.data.removeValue(forKey: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            id -= 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        cell.textLabel?.text = data[data.count - 1 - indexPath.row]!.1
        
        return cell
    }
}

class SecondViewController: UIViewController, UITableViewDelegate {
    
    
 
    var dataSource : TreatDataSource? = nil
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row at \(indexPath)")
    }
    
    @IBOutlet weak var tableView: UITableView!
    //Insert new row into table view with title New Task
    func addNewTask(_ sender: Any) {
        dataSource!.data[dataSource!.id] = (0, "New Treat")
        dataSource!.id += 1
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nibs
        
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
        
        dataSource = TreatDataSource()
        tableView.dataSource = dataSource
        tableView.rowHeight = 90;
        tableView.delegate = self
        tableView.reloadData()
    }
    
}


