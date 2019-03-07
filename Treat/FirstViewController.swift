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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            completeTasks.append(data[indexPath.row])
            self.data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
            
            cell.textLabel?.text = data[indexPath.row].name
            return cell
    }
}

class FirstViewController: UIViewController, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
//    var user : User = User(context: PersistenceService.context) 
    var dataSource : TaskDataSource? = nil
    
    let pointColor : [UIColor] = [UIColor.blue, UIColor(red:0.18, green:0.61, blue:0.58, alpha:1.0), UIColor.orange, UIColor.red]

    
    @IBOutlet weak var testLabel: UILabel!
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
//            answerButt.backgroundColor = UIColor.lightGray
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
    @IBAction func addNewCustomTask(_ sender: Any) {
        let input = taskInput.text
        let newTask = Task(name: input!, points: pointAmounts[selectedAnswer])
        dataSource?.data.append(newTask)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        if tableviewTop.constant >= 90 {
            tableviewTop.constant -= 90
        }
        
//        self.user.setValue( dataSource?.data, forKey: "tasks")

//        self.user.tasks = dataSource?.data
//        PersistenceService.saveContext()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 0
            self.view.layoutIfNeeded()
        })
        tableView.reloadData()
        taskInput.text = ""
        
    }

    
    //Insert new row into table view with title New Task
    @objc func addNewTask(_ sender: Any) {
        newTaskView.isHidden = false
        if tableviewTop.constant < 90 {
            tableviewTop.constant += 90
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 1
            self.view.layoutIfNeeded()
        })

        add.isEnabled = false
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nibs
//        if self.user.name == nil{
//            self.user.name = "me"
//            self.user.points = 0
//            self.user.tasks = dataSource?.data
//            self.user.history = dataSource?.completeTasks
//            PersistenceService.saveContext()
//        }
//        print("name: \(self.user.name), task: \(self.user.tasks)")
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.isTranslucent = true;
//        self.testLabel.text = self.user.namef
        
        refreshControl.addTarget(self, action: #selector(addNewTask(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        answerButtons = [button1, button2, button3, button4]
        dataSource = TaskDataSource()
        tableView.dataSource = dataSource
        tableView.rowHeight = 90;
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let selectedTaskPoint = self.dataSource!.data[editActionsForRowAt.row].points
        let content:String = "+ \(selectedTaskPoint)"
        let remove = UITableViewRowAction(style: .destructive, title: content) { action, index in            self.dataSource?.completeTasks.append((self.dataSource?.data[editActionsForRowAt.row])!)
            self.dataSource?.data.remove(at: editActionsForRowAt.row)
            tableView.deleteRows(at: [editActionsForRowAt], with: .fade)
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

