//
//  ViewController.swift
//  Calculator
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else {
            display.text = sender.currentTitle!
            userIsInTheMiddleOfTyping = true
        }
    }
    
   private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
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
   
    @IBAction private func performOperation(sender: UIButton) {
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

