//
//  topTextFieldDelegate.swift
//  TempFile
//
//  Created by Macbook on 10/26/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    

//clear text field if top
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let oldText = textField.text
        if (oldText == "TOP" || oldText == "BOTTOM"){
            textField.text = ""
        }
    }
    //return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
