//
//  TaskViewController.swift
//  Treat
//
//  Created by Liam Brozik on 2/11/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox


class TaskDataSource : NSObject, UITableViewDataSource
{
    var data : [Task] = []
    var completeTasks : [Task] = [Task]()
    
    init(_ elements : [Task]) { data = elements }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
            let currData = data[indexPath.row]
            
            cell.name.text = currData.name
            switch currData.points {
                case 10:  cell.pointIndic.backgroundColor = taskColor[0]
                case 50:  cell.pointIndic.backgroundColor = taskColor[1]
                case 100: cell.pointIndic.backgroundColor = taskColor[2]
                default:  cell.pointIndic.backgroundColor = taskColor[3]
            }
            return cell
        }
}

class TaskViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var user : User? = nil
    var dataSource : TaskDataSource? = nil
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var newTaskView: UIView!
    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var noTaskAvailable: UILabel!
    
    var selectedAnswer : Int = 0
    var answerButtons : [UIButton] = []
    @IBOutlet weak var add: UIButton!
    var pointAmounts : [Int] = [10, 50, 100, 500]
    
    // Complete task swipe function
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTaskPoint = self.dataSource?.data[indexPath.row].points!
        let title = NSLocalizedString("+\(selectedTaskPoint!)", comment: "Point value")
        
        let action = UIContextualAction(style: .destructive, title: title,
            handler: { (action, view, completionHandler) in
                // Get current level to compare
                let currLevel = DataFunc.getLevel(self.user)
                
                // Update user data
                self.user!.points += Int32(self.user!.tasks![indexPath.row].points)
                self.user!.history!.append(self.user!.tasks![indexPath.row])
                self.user!.tasks!.remove(at: indexPath.row)
                PersistenceService.saveContext()
                
                // Animate changes
                self.dataSource?.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                AudioServicesPlaySystemSound(1114)
                
                // Check if 0 tasks left
                self.noTaskAvailable.isHidden = self.user!.tasks!.count == 0 ? false : true
                
                // Check for levelup (after a small delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let newLevel = DataFunc.getLevel(self.user)
                    if newLevel != currLevel { self.performSegue(withIdentifier: "taskLevelSegue", sender: nil) }
                }
                
                completionHandler(true)
        })
            
        switch selectedTaskPoint {
            case 10:
                action.backgroundColor = taskColor[0]
            case 50:
                action.backgroundColor = taskColor[1]
            case 100:
                action.backgroundColor = taskColor[2]
            case 500:
                action.backgroundColor = taskColor[3]
            default:
                action.backgroundColor = taskColor[0]
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    // Delete swipe function
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            // Update user data
            self.user!.tasks!.remove(at: editActionsForRowAt.row)
            PersistenceService.saveContext()

            // Animate changes
            self.dataSource?.data.remove(at: editActionsForRowAt.row)
            tableView.deleteRows(at: [editActionsForRowAt], with: .fade)

            // Check if 0 tasks left
            self.noTaskAvailable.isHidden = self.user!.tasks!.count == 0 ? false : true
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
    
    
    @IBAction func dismissInputView(_ sender: Any) {
        if tableviewTop.constant >= 70 {
            tableviewTop.constant -= 90
            newTaskTop.constant -= 90
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { res in self.newTaskTop.constant = 120 })
        
        refreshControl.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3882352941, blue: 0.9019607843, alpha: 1) // Reset refresh control background
    }
    
    
    // Custom Interaction Helper functions
    func updateAnswerSelection(_ answerIdx : Int) {
        for ans in answerButtons { highlightAnswer(ans, highlighted: false) }
        highlightAnswer(answerButtons[answerIdx], highlighted: true)
    }
    
    func highlightAnswer(_ answerButt : UIButton, highlighted : Bool) {
        let color = taskColor[selectedAnswer]
        if highlighted { // highlighted
            answerButt.backgroundColor = color
            answerButt.layer.cornerRadius = 5
            answerButt.layer.borderWidth = 1
            answerButt.layer.borderColor = color.cgColor
            answerButt.setTitleColor(UIColor.white, for: .normal)
        } else { // all other buttons
            answerButt.layer.borderColor = UIColor.white.cgColor
            answerButt.backgroundColor = UIColor.white
            answerButt.setTitleColor(taskColor[answerButt.tag], for: .normal)
        }
    }
    
    // Interaction Functions
    @IBAction func buttonPressed (_ sender : UIButton) {
        selectedAnswer = sender.tag
        updateAnswerSelection(sender.tag)
    }
    
    @IBOutlet weak var tableviewTop: NSLayoutConstraint!
    @IBOutlet weak var newTaskTop: NSLayoutConstraint!
    
    // Function that adds new task to table, user
    @IBAction func addNewCustomTask(_ sender: Any) {
        let input = taskInput.text
        let newTask = Task(name: input!, points: pointAmounts[selectedAnswer])
        
        // Save to user
        self.user!.tasks!.append(newTask)
        PersistenceService.saveContext()
        self.reloadData()

        // Animate back
        if tableviewTop.constant >= 70 {
            tableviewTop.constant -= 90
            newTaskTop.constant -= 90
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut,animations: {
            self.newTaskView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { res in self.newTaskTop.constant = 120 })
        
        refreshControl.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3882352941, blue: 0.9019607843, alpha: 1) // Reset refresh control background
    }

    // Animation and visual control updates when adding a new task
    @objc func addNewTask(_ sender: Any) {
        // Reset
        taskInput.text = ""
        selectedAnswer = 0
        updateAnswerSelection(selectedAnswer)
        
        newTaskView.isHidden = false
        taskInput.becomeFirstResponder()
        if tableviewTop.constant < 70 {
            tableviewTop.constant += 90
            newTaskTop.constant -= 120
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.newTaskView.alpha = 1
            self.view.layoutIfNeeded()
        })
        
        refreshControl.endRefreshing()
        refreshControl.backgroundColor = .white
        add.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "profileSegue" {
//            let profileNavViewController = segue.destination as! UINavigationController
//            let profileViewController = profileNavViewController.topViewController as! ProfileViewController
//            profileViewController.delegate = self
//        }
        if segue.identifier == "taskLevelSegue" {
            let levelViewController = segue.destination as! LevelViewController
            levelViewController.user = self.user
        }
        else if segue.identifier == "newUserSegue" {
            let profileViewController = segue.destination as! EditProfileViewController
            profileViewController.newUserSetup = true
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
        
        noTaskAvailable.isHidden = self.user!.tasks!.count == 0 ? false : true

        dataSource = TaskDataSource(self.user!.tasks!) // .reversed()
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
        // Hiding Keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        // Custom refresh control
        refreshControl.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3882352941, blue: 0.9019607843, alpha: 1)
        refreshControl.tintColor = .clear
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to create task", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        // Refresh Code
        refreshControl.addTarget(self, action: #selector(addNewTask(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Add Task View buttons
        answerButtons = [button1, button2, button3, button4]
        
        // Profile button styling
        profileButton.setImage(UIImage(data: (self.user?.img)!), for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.layer.cornerRadius = 20
        profileButton.layer.masksToBounds = true
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.layer.borderWidth = 2
        
        // tab style
        self.tabBarController!.tabBar.layer.borderColor = UIColor(red:0.35, green:0.00, blue:0.68, alpha:0.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
        self.user = DataFunc.fetchData()
        self.reloadData()
        profileButton.setImage(UIImage(data: (self.user?.img)!), for: .normal)

        if self.user?.name == "" {
            print("perform segue")
            self.performSegue(withIdentifier: "newUserSegue", sender: self)
        }
    }
}

// Extension for erasing user data
//extension TaskViewController: ProfileViewControllerDelegate {
//    func notifyTaskOfReset(sender: ProfileViewController) {
//        let alert = DataFunc.createLoadAlert("Erasing all content...")
//        present(alert, animated: true, completion: nil)
//
//        self.user = DataFunc.fetchData()
//        self.reloadData()
//
//        // Dismiss the load after data ia reloaded
//        DispatchQueue.main.async {
//            self.dismiss(animated: false, completion: nil)
//        }
//    }
//}

