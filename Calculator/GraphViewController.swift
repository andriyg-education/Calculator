//
//  GraphViewController.swift
//  Calculator
//
//  Created by Andriy Gushuley on 13/09/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    var brain: CalculatorBrain? {
        didSet {
            navigationItem.title = brain?.evaluateCalculation()
        }
    }
    
    override func viewDidLoad() {
        navigationItem.title = brain?.evaluateCalculation()
    }
    
    func function(x: Double) -> Double? {
        var memory = [String:Double]()
        memory["M"] = x
        return brain?.evaluateValue(memory)
    }
    
    @IBOutlet weak var graphView: GraphView?
    
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
