//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andriy Gushuley on 30/07/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import Foundation

public class CalculatorBrain
{
    private enum Operation: CustomStringConvertible {
        case Operand(value: Double)
        case UnaryOperation(operation: String, calculation: (Double) -> Double)
        case BinaryOperation(operation: String, calculation: (Double, Double) -> Double)
        
        var description : String {
            switch self {
            case .Operand(let value):
                return "\(value)"
            case .UnaryOperation(let operation, _):
                return "\(operation)"
            case .BinaryOperation(let operation, _):
                return "\(operation)"
            }
        }
    }
    
    private static func buildKnownOprations() -> [String:Operation] {
        var operations = [String:Operation]()
        func addOperation(o: Operation) {
            operations[o.description] = o
        }
        
        addOperation(.BinaryOperation(operation: "+", calculation: { $0 + $1 }))
        addOperation(.BinaryOperation(operation: "-", calculation: { $1 - $0 }))
        addOperation(.BinaryOperation(operation: "×", calculation: { $0 * $1 }))
        addOperation(.BinaryOperation(operation: "÷", calculation: { $1 / $0 }))
        
        addOperation(.UnaryOperation(operation: "x²", calculation: { $0 * $0 }))
        addOperation(.UnaryOperation(operation: "sin", calculation: sin))
        addOperation(.UnaryOperation(operation: "con", calculation: cos))
        addOperation(.UnaryOperation(operation: "√", calculation: sqrt))
        return operations
    }
    
    private static let knownOperations = CalculatorBrain.buildKnownOprations()

    
    private var stack = [Operation]()
    
    public func pushOperand(value: Double) -> Double? {
        stack.append(.Operand(value: value))
        return evaluate()
    }
    
    public func performOperation(symbol: String) -> Double? {
        if let operation = CalculatorBrain.knownOperations[symbol] {
            stack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(var position: Int) -> (Int,Double?) {
        if position < 0  || position > stack.count {
            return (position, nil)
        }
        let operation = stack[position]
        position--
        switch operation {
            
        case .Operand(let value):
            return (position, value)
            
        case .UnaryOperation(_, let calculation):
            let (postion, value) = evaluate(position)
            if let value = value {
                return (postion, calculation(value))
            }
            
        case .BinaryOperation(_, let calculation):
            let (position, left) = evaluate(position)
            if let left = left {
                let (position, right) = evaluate(position)
                if let right = right {
                    return (position, calculation(left, right))
                }
            }
        }
        return (position, nil)
    }
    
    public func evaluate() -> Double? {
        let (_, value) = evaluate(stack.count - 1)
        print("\(stack) = \(value)")
        return value
    }
    
    public var toString: String {
        get {
            return "\(stack)"
        }
    }
}