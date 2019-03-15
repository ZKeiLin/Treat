//
//  EditProfileViewController.swift
//  Treat
//
//  Created by Charlene on 3/14/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    
    var user : User? = nil
    var imagePicker : UIImagePickerController = UIImagePickerController()
    var viewTitle : String = "Edit Profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewTitle

        self.user = DataFunc.fetchData()
        imageView.image = UIImage(data:(self.user?.img!)!)
        nameField.text = self.user?.name
        
        //
        // Misc Setup
        // Hiding Keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func btnClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        self.user?.name = nameField.text
        self.user?.img = self.imageView.image?.pngData()
        PersistenceService.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}
