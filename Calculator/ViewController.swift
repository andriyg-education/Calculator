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
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var calculationsLabel: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        if let textLabel = sender.currentTitle {
            if userInMiddleOfTyping {
                displayLabel.text = (displayLabel.text ?? "") + textLabel
            } else {
                displayLabel.text = textLabel
                userInMiddleOfTyping = true
            }
        }
    }
    
    @IBAction func appendDot() {
        if userInMiddleOfTyping {
            if displayText.rangeOfString(".") == .None {
                displayLabel.text = displayText + "."
            }
        } else {
            displayLabel.text = "0."
            userInMiddleOfTyping = true
        }
    }
    
    @IBAction func changeSign() {
        if userInMiddleOfTyping {
            if displayText.rangeOfString("-") == .None {
                displayText = "-" + displayText
            } else {
                displayText = displayText.substringFromIndex(displayText.startIndex.successor())
            }
        } else {
            display = brain.performOperation("±")
        }
    }
    
    @IBAction
    func clear(sender: UIButton) {
        userInMiddleOfTyping = false
        display = brain.clean()
    }
    
    @IBAction
    func stepBack() {
        if userInMiddleOfTyping {
            if displayText.isEmpty {
                displayText = "0"
                userInMiddleOfTyping = false
            } else {
                displayText.removeAtIndex(displayText.endIndex.predecessor())
                if displayText.isEmpty {
                    displayText = "0"
                    userInMiddleOfTyping = false
                }
            }
        } else {
            display = brain.stepBack()
        }
    }
    
    private var userInMiddleOfTyping: Bool = false
    
    private let formatter = NSNumberFormatter()
    
    private var displayInDouble: Double {
        if let text = displayLabel.text,
            number = formatter.numberFromString(text)
        {
            return number.doubleValue
        } else {
            return 0
        }
    }
    
    private var display: CalculatorBrain.Result {
        get {
            return CalculatorBrain.EMPTY_RESULT
        }
        set (value) {
            let print: Double
            if let value = value.result {
                print = value
            } else {
                print = Double.NaN
            }
            displayLabel.text = "\(print)="
            calculationsLabel.text = value.calculation
        }
    }
    
    private var displayText: String {
        get {
            return displayLabel.text ?? ""
        }
        set (value) {
            displayLabel.text = value
        }
    }
    
    private let brain = CalculatorBrain()
    
    @IBAction
    private func enter() {
        if displayText.hasSuffix("=") {
            displayText.removeAtIndex(displayText.endIndex.predecessor())
        }
        display = brain.pushOperand(displayInDouble)
        userInMiddleOfTyping = false
    }

    @IBAction
    private func operation(sender: UIButton) {
        if userInMiddleOfTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            print("Operation: \(operation)")
            display = brain.performOperation(operation)
        }
    }
}

