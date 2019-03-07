//
//  CreateTreatViewController.swift
//  Treat
//
//  Created by Kelden Lin on 3/6/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit

class CreateTreatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var treatFieldName: UITextField!
    @IBOutlet weak var treatFieldCategory: UITextField!
    @IBOutlet weak var treatSliderPoints: UISlider!
    @IBOutlet weak var treatLabelPoints: UILabel!
    
    var categoryList : [String] = []
    
    // Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {   return categoryList.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(categoryList[row])
        print("add compoenent")
        return categoryList[row]
    }
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        treatFieldCategory.text = categoryList[row]
    }
    
    
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
        let categoryPicker = UIPickerView()
        treatFieldCategory.inputView = categoryPicker
        
        categoryPicker.delegate = self
//        print(categoryList)
    }

}
