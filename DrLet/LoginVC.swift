//
//  LoginVC.swift
//  DrLet
//
//  Created by Venkat Madira on 09/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var userDetailsLbl: UILabel!
    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var lastnameLbl: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var postCodeLbl: UILabel!
    @IBOutlet weak var profileImageview: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        emptyLabletxt()
        profileImageview.layer.borderWidth = 1
        profileImageview.layer.masksToBounds = false
        profileImageview.layer.borderColor = UIColor.black.cgColor
        profileImageview.layer.cornerRadius = profileImageview.frame.height/2
        profileImageview.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        SVProgressHUD.show()
        if(Auth.auth().currentUser?.phoneNumber == phoneNumberTxt.text){
            print("login phone correct")
             if Auth.auth().currentUser != nil {
                guard let uid = Auth.auth().currentUser?.uid else {
                     self.displayAlert(title: "Sorry!", message: "Failed to fetch user")
                    return
                }
                Database.database().reference().child("Users").observeSingleEvent(of: .value) { (snapshot) in
                       guard let dictionary = snapshot.value as? [String : Any] else {
                        
                        self.displayAlert(title: "Sorry!", message: "Failed to fetch user")
                        return
                    }
                    
                    for user_child in (snapshot.children) {
                        
                        let user_snap = user_child as! DataSnapshot
                        let dict = user_snap.value as! [String: Any?]
                        
                        self.updateLables(with: dict as Dictionary<String, Any>)
                        
                    }
                    
                    
                   
                }
            }
            
        }else{
            //print("phone number cannot found")
            self.displayAlert(title: "Sorry!", message: "phone number cannot found")
            
        }
    }
    
 
    func emptyLabletxt(){
        userDetailsLbl.isHidden = true
        firstnameLbl.isHidden = true
        lastnameLbl.isHidden = true
        phoneNumLbl.isHidden = true
        emailLbl.isHidden = true
        postCodeLbl.isHidden = true
        profileImageview.isHidden = true
    }
    
    func updateLables(with userDetails: Dictionary<String, Any>) {
        userDetailsLbl.isHidden = false
        firstnameLbl.isHidden = false
        lastnameLbl.isHidden = false
        phoneNumLbl.isHidden = false
        emailLbl.isHidden = false
        postCodeLbl.isHidden = false
        profileImageview.isHidden = false
        
        firstnameLbl.text = "First Name : \(userDetails["FirstName"] as! String)"
        lastnameLbl.text = "Last Name : \(userDetails["LastName"] as! String)"
        phoneNumLbl.text = "Phone Number : \(userDetails["PhoneNum"] as! String)"
        emailLbl.text = "Email : \(userDetails["email"] as! String)"
        postCodeLbl.text = "Postcode : \(userDetails["Location"] as! String)"
        downloadImage(from: URL(string: userDetails["profileImageUrl"] as! String )!)
    }
   
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            SVProgressHUD.dismiss()
            DispatchQueue.main.async() {
                self.phoneNumberTxt.text = ""
                self.profileImageview.image = UIImage(data: data)
            }
        }
    }

    // MARK: -displayAlert
    // Global Alert display
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
