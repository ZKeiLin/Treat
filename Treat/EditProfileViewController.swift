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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = DataFunc.fetchData()
        imageView.image = UIImage(data:(self.user?.img!)!)

        // Do any additional setup after loading the view.
    }
    @IBAction func btnClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = pickedImage
            user = DataFunc.fetchData()
            self.user?.img = pickedImage.pngData()
            PersistenceService.saveContext()
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        self.user?.name = nameField.text
        PersistenceService.saveContext()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
