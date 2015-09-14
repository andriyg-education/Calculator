//
//  GraphViewController.swift
//  Calculator
//
//  Created by Andriy Gushuley on 13/09/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    @IBOutlet weak var functionNameLabel: UILabel?
    
    private func updateFunctionName() {
        if let brain = brain {
            functionNameLabel?.text = "f(M) = \(brain.evaluateCalculation())"
        } else {
            functionNameLabel?.text = "f(M) = M"
        }
    }
    
    var brain: CalculatorBrain? {
        didSet {
            updateFunctionName()
        }
    }
    
    override func viewDidLoad() {
        updateFunctionName()
        graphView?.function = function
    }
    
    func function(x: Double) -> Double? {
        if let brain = brain {
            var memory = [String:Double]()
            memory["M"] = x
            return brain.evaluateValue(memory)
        } else {
            return x
        }
    }
    
    @IBOutlet weak var graphView: GraphView? {
        didSet {
            graphView?.function = function
        }
    }
    
    @IBAction func pitch(sender: UIPinchGestureRecognizer) {
        print("pitch \(sender.scale * 100)%")
        graphView?.scale /= sender.scale
        sender.scale = 1
    }
    
    @IBAction func pan(sender: UIPanGestureRecognizer) {
        let point = sender.translationInView(graphView)
        switch sender.state {
        case .Changed:
            print("pan changed for \(point)!")
            graphView?.moveCenterFor(point)
            break
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, inView: graphView)
    }
}
