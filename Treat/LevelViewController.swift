//
//  LevelViewController.swift
//  Treat
//
//  Created by Kelden Lin on 3/14/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import AudioToolbox

class LevelViewController: UIViewController {
    var user : User? = nil
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var treatLabel: UILabel!
    
    @IBAction func dismissPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioServicesPlaySystemSound(1026)
        
        descLabel.text = String("Congratulations \(self.user!.name!), you're now LEVEL \(DataFunc.getLevel(user))!")
        taskLabel.text = String(DataFunc.getHistoricCount(user, type: "Task"))
        treatLabel.text = String(DataFunc.getHistoricCount(user, type: "Treat"))
    }
}
