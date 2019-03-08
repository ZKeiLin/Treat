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
    weak var delegate: ProfileViewControllerDelegate?
    
    @IBAction func backPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetUser(_ sender: Any) {
        DataFunc.eraseData()
        dismiss(animated: true) {
            self.delegate?.notifyTaskOfReset(sender: self)
        }
    }
}
