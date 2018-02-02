//
//  ViewController.swift
//  Calculator
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var display: UILabel!
    fileprivate var userIsInTheMiddleOfTyping = false
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else {
            display.text = sender.currentTitle!
            userIsInTheMiddleOfTyping = true
        }
    }
    
   fileprivate var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    fileprivate var brain = CalculatorBrain()
    
    var savedPrograme: CalculatorBrain.PropertyList?
    

    @IBAction func save() {
        savedPrograme = brain.program
    }
    
    
    @IBAction func restore() {
        if savedPrograme != nil {
            brain.program = savedPrograme!
            displayValue = brain.result
        }
    }
   
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    

    
    
}

