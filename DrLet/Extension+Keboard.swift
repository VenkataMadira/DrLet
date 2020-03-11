//
//  Extension+Keboard.swift
//  DrLet
//
//  Created by Venkat Madira on 08/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import UIKit
extension UIViewController{
    func hideKeyboardWhenTappedArround(){
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(hideKeyBoard))
        view.addGestureRecognizer(tapGesture)
     
    }
    @objc func hideKeyBoard(){
        view.endEditing(true)
    }
}
