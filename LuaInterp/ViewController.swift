//
//  ViewController.swift
//  LuaInterp
//
//  Created by Matthew Burke on 10/22/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//


// Keyboard handling: http://maniacdev.com/2014/10/open-source-ios-library-allowing-you-to-easily-slide-views-automatically-away-from-the-keyboard


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
//        var results = self.L.evaluate(self.input.text)
        var results = self.L.eval(self.input.text)
        var currentOutput: String = self.output.text
        var newResults: String = join(" ", results.results)
        
        self.output.text = currentOutput + newResults + "\n"
    }

    
}

