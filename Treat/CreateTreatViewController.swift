//
//  CreateTreatViewController.swift
//  Treat
//
//  Created by Kelden Lin on 3/6/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit

class CreateTreatViewController: UIViewController {
    @IBOutlet weak var treatFieldName: UITextField!
    @IBOutlet weak var treatFieldCategory: UITextField!
    @IBOutlet weak var treatSliderPoints: UISlider!
    @IBOutlet weak var treatLabelPoints: UILabel!

    
    @IBAction func treatSliderChange(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.treatSliderPoints.setValue((round((sender as AnyObject).value / 10) * 10), animated: false)
        })
        
        treatLabelPoints.text = "\(String(Int(treatSliderPoints.value))) pts"
        print(treatSliderPoints.value)
        

    }
    
    @IBAction func addTreat(_ sender: Any) {
        let newTreat = Treat(name: treatFieldName.text!, points: Int(treatSliderPoints.value), category: treatFieldCategory.text!)
        SecondViewController.GlobalVariable.addedTreat = newTreat
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
