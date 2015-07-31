//
//  ViewController.swift
//  Calculator
//
//  Created by Andriy Gushuley on 29/07/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        if let textLabel = sender.currentTitle {
            if userInMiddleOfTyping {
                display.text = (display.text ?? "") + textLabel
            } else {
                display.text = textLabel
                userInMiddleOfTyping = true
            }
        }
    }
    
    private var userInMiddleOfTyping: Bool = false
    
    private let formatter = NSNumberFormatter()
    
    private var displayInDouble: Double? {
        get {
            if let text = display.text,
                number = formatter.numberFromString(text)
            {
                return number.doubleValue
            } else {
                return 0
            }
        }
        set (value) {
            let print: Double
            if let value = value {
                print = value
            } else {
                print = Double.NaN
            }
            display.text = "\(print)"
        }
    }
    
    private let brain = CalculatorBrain()
    
    @IBAction
    private func enter() {
        displayInDouble = brain.pushOperand(displayInDouble!)
        userInMiddleOfTyping = false
    }

    @IBAction func operation(sender: UIButton) {
        if userInMiddleOfTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            print("Operation: \(operation)")
            displayInDouble = brain.performOperation(operation)
        }
    }
}

