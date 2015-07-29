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
    
    private var displayInDouble: Double {
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
            display.text = "\(value)"
        }
    }
    
    private var operandsStack: [Double] = [Double]()

    @IBAction func enter() {
        print("Stack: \(operandsStack)")
        operandsStack.append(displayInDouble)
        userInMiddleOfTyping = false
    }

    @IBAction func operation(sender: UIButton) {
        if operandsStack.count < 2 {
            return
        }
        let left = operandsStack[operandsStack.count - 1]
        let right = operandsStack[operandsStack.count - 2]
        operandsStack.removeRange(Range(start: operandsStack.count - 2, end: operandsStack.count))
        
        let result: Double
        if let operation = sender.currentTitle {
            switch operation {
                case "+":
                    result = left + right
                case "−":
                    result = left - right
                case "×":
                    result = left * right
                case "÷":
                    result = left / right
                default:
                    return
            }
        } else {
            return
        }
        
        print("Stack: \(operandsStack)")
        operandsStack.append(result)
        displayInDouble = result
    }
}

