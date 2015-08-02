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
    public struct Result {
        public let result: Double?
        public let calculation: String
        
        private init(result: Double?, calculation: String) {
            self.result = result
            self.calculation = calculation
        }
    }
    
    public static let EMPTY_RESULT = CalculatorBrain.Result(result: 0, calculation: "")
    
    private enum Operation: CustomStringConvertible {
        case Operand(value: Double)
        case UnaryOperation(operation: String, calculation: (Double) -> Double)
        case BinaryOperation(operation: String, calculation: (Double, Double) -> Double)
        case Constant(symbol: String, value: Double)
        
        var description : String {
            switch self {
            case .Operand(let value):
                return "\(value)"
            case .UnaryOperation(let operation, _):
                return "\(operation)"
            case .BinaryOperation(let operation, _):
                return "\(operation)"
            case .Constant(let symbol, _):
                return "\(symbol)"
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
        
        addOperation(.UnaryOperation(operation: "±", calculation: { -$0 }))
        addOperation(.UnaryOperation(operation: "x²", calculation: { $0 * $0 }))
        addOperation(.UnaryOperation(operation: "sin", calculation: sin))
        addOperation(.UnaryOperation(operation: "cos", calculation: cos))
        addOperation(.UnaryOperation(operation: "√", calculation: sqrt))
        
        addOperation(.Constant(symbol: "π", value: M_PI))
        
        return operations
    }
    
    private static let knownOperations = CalculatorBrain.buildKnownOprations()

    
    private var stack = [Operation]()
    
    public func pushOperand(value: Double) -> Result {
        stack.append(.Operand(value: value))
        return evaluate()
    }

    public func performOperation(symbol: String) -> Result {
        if let operation = CalculatorBrain.knownOperations[symbol] {
            stack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(var position: Int) -> (Int,String,Double?) {
        if position < 0  || position > stack.count {
            return (position, "", 0)
        }
        let operation = stack[position]
        position--
        switch operation {
            
        case .Operand(let value):
            return (position, "\(value)", value)
            
        case .UnaryOperation(let symbol, let calculation):
            let (postion, calc, value) = evaluate(position)
            let currentCalc = "\(symbol)(\(calc))"
            if let value = value {
                return (postion, currentCalc, calculation(value))
            } else {
                return (postion, currentCalc, nil)
            }
            
        case .BinaryOperation(let symbol, let calculation):
            let (position, leftCalc, left) = evaluate(position)
            if let left = left {
                let (position, rightCalc, right) = evaluate(position)
                let currentCalc = "\(leftCalc) \(symbol) \(rightCalc)"
                if let right = right {
                    return (position, currentCalc, calculation(left, right))
                } else {
                    return (position, currentCalc, nil)
                }
            } else {
                return (position, "\(leftCalc) \(symbol) ???", nil)
            }
            
        case .Constant(let symbol, let value):
            return (position, symbol, value)
        }        
    }
    
    public func evaluate() -> Result {
        let (_, calculation, value) = evaluate(stack.count - 1)
        print("\(calculation) = \(value)")
        return Result(result: value, calculation: calculation)
    }
    
    public var toString: String {
        get {
            return "\(stack)"
        }
    }
    
    public func clean() -> Result {
        stack = []
        return CalculatorBrain.EMPTY_RESULT
    }
    
    public func stepBack() -> Result {
        if !stack.isEmpty {
            stack.removeLast()
        }
        return evaluate()
    }
}