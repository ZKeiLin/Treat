//
//  NewTaskTableViewCell.swift
//  Treat
//
//  Created by Liam Brozik on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit

class NewTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var selectedAnswer : Int = -1
    var answerButtons : [UIButton] = []
    @IBOutlet weak var add: UIButton!
    
    
    // Custom Interaction Helper functions
    func updateAnswerSelection(_ answerIdx : Int) {
        for ans in answerButtons { highlightAnswer(ans, highlighted: false) }
        highlightAnswer(answerButtons[answerIdx], highlighted: true)
    }
    
    func highlightAnswer(_ answerButt : UIButton, highlighted : Bool) {
        if highlighted {
            answerButt.backgroundColor = UIColor.lightGray
            answerButt.setTitleColor(UIColor.black, for: .normal)
        } else {
            answerButt.backgroundColor = UIColor.white
            answerButt.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    // Interaction Functions
    @IBAction func buttonPressed (_ sender : UIButton) {
        updateAnswerSelection(sender.tag)
        selectedAnswer = sender.tag
    }
    
    @IBAction func addNewTask(_ sender: Any) {

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerButtons = [button1, button2, button3, button4]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
