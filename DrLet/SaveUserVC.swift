//
//  SaveUserVC.swift
//  DrLet
//
//  Created by Venkat Madira on 08/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD

class SaveUserVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var phoneNumTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var postCodeTxt: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    var imageDataStr: String?
    var isImageselected = false
    
    var ref: DatabaseReference!
    
    let storeRef = Storage.storage().reference()
   
    
    // let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // let storeRef = store.reference()
        self.imagePreview.layer.cornerRadius = imagePreview.frame.height/2
        self.imagePreview.clipsToBounds = true
      
        // Do any additional setup after loading the view.
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveUserDetailsPressed(_ sender: Any) {
        SVProgressHUD.show()
        if(isImageselected){
            
            
            let fileName = UUID().uuidString
            let userDB = ref.child("Users")
            
            print(Auth.auth().currentUser?.phoneNumber as Any)
            
            if let phoneNum = Auth.auth().currentUser?.phoneNumber, let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let email = emailTxt.text, let locationPostcode = postCodeTxt.text,let profileImageUploadData = (self.imagePreview.image)?.jpegData(compressionQuality: 0.3) {
                let imagereference =  storeRef.child("profileImages").child(fileName)
                imagereference.putData(profileImageUploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        //print("Failed to save user with error: \(err)")
                        self.displayAlert(title: "Error Save User", message: "Failed to save user with error: \(err)")
                        return
                    }
                    
                    // Metadata contains file metadata such as size, content-type.
                    // let size = metadata.size
                    
                    imagereference.downloadURL(completion: { (url, err) in
                        print(url as Any)
                        guard let urlString = url?.absoluteString else{
                            print("error in URL string ")
                            self.displayAlert(title: "URL Error", message: "Error in URL string")
                            return
                        }
                        let messageDictionary = ["FirstName": firstName,"LastName": lastName, "PhoneNum":phoneNum,"email":email,"Location":locationPostcode,"profileImageUrl":urlString] as [String : Any]
                        
                        let curentUserID = Auth.auth().currentUser?.uid
                        let values = [curentUserID : messageDictionary]
                            userDB.updateChildValues(values, withCompletionBlock: { (error, dataRef) in
                                if let error = error{
                                    self.displayAlert(title: "Failed to save data", message: "User data saved failed\(error.localizedDescription)")
                                    return
                                }
                                self.displayAlert(title: "Success!", message: "Message saved successfully")
                                //UI Update
                                DispatchQueue.main.async {
                                    self.resetTextfeilds()
                                    
                                }
                                
                                
                            })
                            
                       
                    })
                    
                    
                }
                
            }
            
        }
    }
    
    
    // MARK: - ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            // let image = self.loadOrGenerateAnImage()
            // Bounce back to the main thread to update the UI
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.isImageselected = true
                DispatchQueue.main.async {
                    self.imagePreview.image = image
                }
                
            }
            else {
                self.isImageselected = false
                print("There was a problem getting the image")
                
                self.displayAlert(title: "Image Problem", message: "There was a problem getting the image")
                
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isImageselected = false
        dismiss(animated: true, completion:nil)
    }
    
    func resetTextfeilds(){
        self.firstNameTxt.text = ""
        self.lastNameTxt.text = ""
        self.phoneNumTxt.text = ""
        self.emailTxt.text = ""
        self.postCodeTxt.text = ""
        SVProgressHUD.dismiss()
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
