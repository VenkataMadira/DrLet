//
//  RegisterVC.swift
//  DrLet
//
//  Created by Venkat Madira on 08/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterVC: UIViewController {
    
    @IBOutlet weak var otpTxt: UITextField!
    @IBOutlet weak var mobileNumTxt: UITextField!
    @IBOutlet weak var otpBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        otpTxt.isUserInteractionEnabled = false
        otpBtn.isUserInteractionEnabled = false
    }
    
    
    @IBAction func verifyOTPPressed(_ sender: Any) {
        SVProgressHUD.show()
        guard let otpCode = otpTxt.text else {
            return
        }
        
        guard let veifyID = defaults.string(forKey: "verificationID") else{return}
            
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: veifyID, verificationCode: otpCode)
        
        Auth.auth().signIn(with: credentials) { (success, error) in
            if error == nil{
                 SVProgressHUD.dismiss()
                
                print("succes")
            }else{
                 SVProgressHUD.dismiss()
                print("error"+(error?.localizedDescription)!)
            }
        }
        
    }
    
    @IBAction func registerMobilePressed(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            print("already registerd please login ")
           
        }else{
        
        SVProgressHUD.show()
        guard let phoneNum = mobileNumTxt.text else {
            return
        }
        SVProgressHUD.dismiss()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            if(error == nil){
                 self.otpTxt.isUserInteractionEnabled = true
                self.otpBtn.isUserInteractionEnabled = true
                
                print(verificationID as Any)
                guard let verifyID = verificationID else{return}
                self.defaults.set(verifyID, forKey: "verificationID")
                self.defaults.synchronize()
                
            }else{
                 SVProgressHUD.dismiss()
                print(error!.localizedDescription)
            }
            }
       }
    }
    
    
   
}
