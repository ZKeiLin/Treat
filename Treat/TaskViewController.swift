//
//  TaskViewController.swift
//  Treat
//
//  Created by Liam Brozik on 2/11/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData

class TaskDataSource : NSObject, UITableViewDataSource
{
    var data : [Task] = []
    var completeTasks : [Task] = [Task]()
    
    init(_ elements : [Task]) { data = elements }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            completeTasks.append(data[indexPath.row])
//            self.data.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
            let currData = data[indexPath.row]
            
            cell.name.text = currData.name
            let pointColor : [UIColor] = [UIColor.blue, UIColor(red:0.18, green:0.61, blue:0.58, alpha:1.0), UIColor.orange, UIColor.red]
            switch currData.points {
                case 10: cell.pointIndic.backgroundColor = pointColor[0]
                case 50: cell.pointIndic.backgroundColor = pointColor[1]
                case 100: cell.pointIndic.backgroundColor = pointColor[2]
                default: cell.pointIndic.backgroundColor = pointColor[3]
            }
            return cell
        }
}

class TaskViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var user : User? = nil
    var dataSource : TaskDataSource? = nil
    
    let pointColor : [UIColor] = [UIColor.blue, UIColor(red:0.18, green:0.61, blue:0.58, alpha:1.0), UIColor.orange, UIColor.red]
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var newTaskView: UIView!
    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var selectedAnswer : Int = 0
    var answerButtons : [UIButton] = []
    @IBOutlet weak var add: UIButton!
    var pointAmounts : [Int] = [10, 50, 100, 500]
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let selectedTaskPoint = self.dataSource!.data[editActionsForRowAt.row].points!
        let content:String = "+ \(selectedTaskPoint)"
        let remove = UITableViewRowAction(style: .destructive, title: content) { action, index in
            // IGNORING COMPLETED TASKS FOR NOW
            // self.dataSource?.completeTasks.append((self.dataSource?.data[editActionsForRowAt.row])!)
            //            tableView.deleteRows(at: [editActionsForRowAt], with: .fade)
            self.user!.points += Int32(self.user!.tasks![editActionsForRowAt.row].points)
            self.user!.history!.append(self.user!.tasks![editActionsForRowAt.row])
            self.user!.tasks!.remove(at: editActionsForRowAt.row)
            
            //            self.dataSource?.data.remove(at: editActionsForRowAt.row)
            PersistenceService.saveContext()
            self.reloadData()
            
        }
        switch selectedTaskPoint {
        case 10:
            remove.backgroundColor = pointColor[0]
        case 50:
            remove.backgroundColor = pointColor[1]
        case 100:
            remove.backgroundColor = pointColor[2]
        case 500:
            remove.backgroundColor = pointColor[3]
        default:
            remove.backgroundColor = pointColor[0]
        }
        
        return [remove]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    @IBAction func taskInputChanged(_ sender: Any) {
        if (taskInput.text == nil || taskInput.text == "") {
            add.isEnabled = false
        } else {
            add.isEnabled = true
        }
    }
    
    @IBAction func checkInput(_ sender: Any) {

    }
    
    // Custom Interaction Helper functions
    func updateAnswerSelection(_ answerIdx : Int) {
        for ans in answerButtons { highlightAnswer(ans, highlighted: false) }
        highlightAnswer(answerButtons[answerIdx], highlighted: true)
    }
    
    func highlightAnswer(_ answerButt : UIButton, highlighted : Bool) {
        let color = pointColor[selectedAnswer]
        if highlighted { // highlighted
            answerButt.backgroundColor = color
            answerButt.layer.cornerRadius = 5
            answerButt.layer.borderWidth = 1
            answerButt.layer.borderColor = color.cgColor
            answerButt.setTitleColor(UIColor.white, for: .normal)
        } else { // all other buttons
            answerButt.layer.borderColor = UIColor.white.cgColor
            answerButt.backgroundColor = UIColor.white
            answerButt.setTitleColor(pointColor[answerButt.tag], for: .normal)
        }
    }
    
    // Interaction Functions
    @IBAction func buttonPressed (_ sender : UIButton) {
        selectedAnswer = sender.tag
        updateAnswerSelection(sender.tag)
    }
    
    @IBOutlet weak var tableviewTop: NSLayoutConstraint!
    
    // Function that adds new task to table, user
    @IBAction func addNewCustomTask(_ sender: Any) {
        let input = taskInput.text
        let newTask = Task(name: input!, points: pointAmounts[selectedAnswer])
        
        // Save to user
        self.user!.tasks!.append(newTask)
        PersistenceService.saveContext()
        self.reloadData()

        // Animate back
        if tableviewTop.constant >= 90 { tableviewTop.constant -= 90 }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 0
            self.view.layoutIfNeeded()
        })
    }

    // Animation and visual control updates when adding a new task
    @objc func addNewTask(_ sender: Any) {
        // Reset
        taskInput.text = ""
        selectedAnswer = 0
        updateAnswerSelection(selectedAnswer)
        
        newTaskView.isHidden = false
        if tableviewTop.constant < 90 { tableviewTop.constant += 90 }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        add.isEnabled = false
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.delegate = self
        }
    }
    
    func reloadData() {
        print("\(self.user!.name!) has \(self.user!.points) points")
        print("Tasks")
        for t in self.user!.tasks! {
            print(t.toString())
        }
        print("History")
        print(self.user!.history!)
        
        dataSource = TaskDataSource(self.user!.tasks!) // add code for sorting?
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch Data from Coredata
        self.user = DataFunc.fetchData()
        self.reloadData()
        
        
        //
        // Misc Setup
        // Refresh Code
        refreshControl.addTarget(self, action: #selector(addNewTask(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Add Task View buttons
        answerButtons = [button1, button2, button3, button4]
        
        // Tab code
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
    }
}

// Extension for erasing user data
extension TaskViewController: ProfileViewControllerDelegate {
    func notifyTaskOfReset(sender: ProfileViewController) {
        let alert = DataFunc.createLoadAlert("Erasing all content...")
        present(alert, animated: true, completion: nil)

        self.user = DataFunc.fetchData()
        self.reloadData()
        
        // Dismiss the load after data ia reloaded
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

