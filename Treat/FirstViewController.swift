//
//  FirstViewController.swift
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
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            completeTasks.append(data[indexPath.row])
//            self.data.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
            
            cell.textLabel?.text = data[indexPath.row].name
            return cell
    }
}

class FirstViewController: UIViewController, UITableViewDelegate {
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

        taskInput.text = ""
    }

    
    // Animation and visual control updates whne adding a new task
    @objc func addNewTask(_ sender: Any) {
        newTaskView.isHidden = false
        if tableviewTop.constant < 90 { tableviewTop.constant += 90 }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        add.isEnabled = false
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        print("\(self.user!.name) has \(self.user!.points) points")
        print("Tasks")
        for t in self.user!.tasks! {
            print(t.toString())
        }
        print("History")
        print(self.user!.history)
        
        dataSource = TaskDataSource(self.user!.tasks!) // add code for sorting?
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch Data from Coredata
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            var result = try PersistenceService.context.fetch(fetchRequest)
            print("THERE ARE \(result.count) USER PROFILES")
            
            if result.count == 0 { // No user profile is found
                print("Creating initial user")
                let userProfile : UserProfile = UserProfile(name: "Me") // Default Data, would change to a field user can enter information
                user = User(context: PersistenceService.context)
                self.user!.name = userProfile.name
                self.user!.points = Int32(userProfile.points)
                self.user!.history = userProfile.history
                self.user!.tasks = userProfile.tasks
                self.user!.treats = userProfile.treats
                PersistenceService.saveContext()
                result = try PersistenceService.context.fetch(fetchRequest)
            }
            
            for data in result{
                print(data.name)
                for t in data.tasks! {
                    print(t.toString())
                }
            }
            
            self.user = result[0]
            dataSource = TaskDataSource(self.user!.tasks!)
        } catch {
            print("FATAL: Couldn't fetch Coredta")
        }
    

        // Tab code
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
        
        // Refresh Code
        refreshControl.addTarget(self, action: #selector(addNewTask(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Add Task View
        answerButtons = [button1, button2, button3, button4]
       
        // Tableview Setup
        self.reloadData()
    }
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

