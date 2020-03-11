//
//  ViewController.swift
//  DrLet
//
//  Created by Venkat Madira on 08/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
        }else{
            print("Internet Connection not Available!")
            self.displayAlert(title: "Internet Error", message: "Please check Internet connection.")
        }
    }

    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

