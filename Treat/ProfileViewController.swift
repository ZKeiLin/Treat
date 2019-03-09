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

class ProfileViewController: UIViewController {
    // Interface Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var xpBar: UIView!
    @IBOutlet weak var xpBarConstraint: NSLayoutConstraint!
    // Local Variables
    var user : User? = nil
    weak var delegate: ProfileViewControllerDelegate?
    let XP_PER_LEVEL : Float = 500.0 // XP Per level
    
    func getXp() -> Int {
        var returnXp : Int = 0
        for t in user!.history! {
            switch t {
                case is Task: let ta = t as! Task; returnXp += Int(ta.points!)
                default: let tr = t as! Treat; returnXp += Int(tr.points!)
            }
        }
        return returnXp
    }
    
    func getPercentXp() -> Float {
        return Float(getXp()).truncatingRemainder(dividingBy: XP_PER_LEVEL) / XP_PER_LEVEL
    }
    
    func getLevel() -> Int {
        return Int(floor(Float(getXp()) / XP_PER_LEVEL)) + 1 // Default level 1
    }
    
    @IBAction func backPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = DataFunc.fetchData()
        nameLabel.text = self.user?.name
        print("Level: \(getLevel())")
        print("XP: \(getXp())")
        print("\(getPercentXp() * 100)%")

        lvlLabel.text = "Level \(getLevel())"
        pointsLabel.text = "\(self.user!.points) points"
        let currWidth : CGFloat = xpBar.frame.size.width
        xpBarConstraint.constant += currWidth - (CGFloat(getPercentXp() * 100) * ((20.0 + currWidth) / 100.0))
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
