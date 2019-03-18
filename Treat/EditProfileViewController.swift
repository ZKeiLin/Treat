//
//  EditProfileViewController.swift
//  Treat
//
//  Created by Charlene on 3/14/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class EditProfileViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var fakeNavBar: UIView!
    @IBOutlet weak var getStartedLabel: UILabel!
    @IBOutlet weak var getStartedTopConst: NSLayoutConstraint!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var newUserSetup = false
    var user : User? = nil
    var imagePicker : UIImagePickerController = UIImagePickerController()
    var viewTitle : String = "Edit Profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newUserSetup {
            getStartedLabel.isHidden = false
            fakeNavBar.isHidden = true
            getStartedTopConst.constant = 60
            chooseButton.setTitle("Add Profile Photo", for: .normal)
            saveButton.setTitle("Create Profile", for: .normal)
        }
        
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
            imagePicker.allowsEditing = true

            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)

            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.imagePicker.sourceType = .camera
                // Check for camera access
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch (status)
                {
                case .authorized:
                    self.present(self.imagePicker, animated: true, completion: nil)

                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                        if (granted)
                        {
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                        else
                        {
                            DispatchQueue.main.async
                                {
                                    var alertText = "It looks like your privacy settings are preventing us from accessing your camera to take a profile picture. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
                                    
                                    var alertButton = "OK"
                                    var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                                    
                                    if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                                    {
                                        alertText = "It looks like your privacy settings are preventing us from accessing your camera to take a profile picture. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                                        
                                        alertButton = "Go"
                                        
                                        goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                        })
                                    }
                                    
                                    let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
                                    alert.addAction(goAction)
                                    self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                case .denied:
                    DispatchQueue.main.async
                        {
                            var alertText = "It looks like your privacy settings are preventing us from accessing your camera to take a profile picture. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
                            
                            var alertButton = "OK"
                            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                            
                            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                            {
                                alertText = "It looks like your privacy settings are preventing us from accessing your camera to take a profile picture. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                                
                                alertButton = "Go"
                                
                                goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                })
                            }
                            
                            let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
                            alert.addAction(goAction)
                            self.present(alert, animated: true, completion: nil)
                    }
                case .restricted:
                    let alert = UIAlertController(title: "Restricted",
                                                  message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in return }
            
            // Add the actions to your actionSheet
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(libraryAction)
            actionSheet.addAction(cancelAction)

            
            // Present the controller
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.contentMode = .scaleAspectFill

        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func save(_ sender: Any) {
        if nameField.text?.trimmingCharacters(in: .whitespaces) != "" {
            self.user?.name = nameField.text
            self.user?.img = self.imageView.image?.pngData()
            PersistenceService.saveContext()
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        // User left the name blank
        else {
            let alert = UIAlertController(title: "No name entered", message: "Please enter a valid name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in return }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
