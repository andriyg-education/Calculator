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
    private enum Operation {
        case Operand(value: Double)
        case UnaryOperation(operation: String, calculation: (Double) -> Double)
        case BinaryOperation(operation: String, calculation: (Double, Double) -> Double)
    }
    
    private static func buildKnownOprations() -> [String:Operation] {
        var operations = [String:Operation]()
        
        operations["+"] = Operation.BinaryOperation(operation: "+", calculation: { $0 + $1 })
        operations["-"] = Operation.BinaryOperation(operation: "-", calculation: { $1 - $0 })
        operations["×"] = Operation.BinaryOperation(operation: "×", calculation: { $0 * $1 })
        operations["÷"] = Operation.BinaryOperation(operation: "÷", calculation: { $1 / $0 })
        
        operations["x²"] = Operation.UnaryOperation(operation: "x²", calculation: { $0 * $0 })
        operations["sin"] = Operation.UnaryOperation(operation: "sin", calculation: sin)
        operations["cos"] = Operation.UnaryOperation(operation: "con", calculation: cos)
        operations["√"] = Operation.UnaryOperation(operation: "√", calculation: sqrt)
        return operations
    }
    
    private static let knownOperations = CalculatorBrain.buildKnownOprations()

    
    private var stack = [Operation]()
    
    public func pushOperand(value: Double) {
        stack.append(.Operand(value: value))
    }
    
    public func performOperation(symbol: String) {
        if let operation = CalculatorBrain.knownOperations[symbol] {
            stack.append(operation)
        }
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
        return evaluate(stack.count - 1).1
    }
    
    public var toString: String {
        get {
            return "\(stack)"
        }
    }
}