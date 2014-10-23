//
//  ViewController.swift
//  LuaInterp
//
//  Created by Matthew Burke on 10/22/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextView!
    
    let L: LuaState = LuaState()
    

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        var results = self.L.evaluate(self.input.text)
        var currentOutput: String = self.output.text
        var newResults: String = join(" ", results.results)
        
        self.output.text = currentOutput + newResults + "\n"
    }

    
}

