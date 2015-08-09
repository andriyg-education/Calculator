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
        
        private init(_ result: Double?, _ calculation: String) {
            self.result = result
            self.calculation = calculation
        }
    }
    
    public static let EMPTY_RESULT = CalculatorBrain.Result(0, " ")
    
    public var variablesValues = [String:Double]()
    
    private enum Operation: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, Double)
        case Variable(String)
        
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
            case .Variable(let symbol):
                return "\(symbol)"
            }
        }
    }
    
    private static func buildKnownOprations() -> [String:Operation] {
        var operations = [String:Operation]()
        func addOperation(o: Operation) {
            operations[o.description] = o
        }
        
        addOperation(.BinaryOperation("+", { $0 + $1 }))
        addOperation(.BinaryOperation("-", { $1 - $0 }))
        addOperation(.BinaryOperation("×", { $0 * $1 }))
        addOperation(.BinaryOperation("÷", { $1 / $0 }))
        
        addOperation(.UnaryOperation("±", { -$0 }))
        addOperation(.UnaryOperation("x²", { $0 * $0 }))
        addOperation(.UnaryOperation("sin", sin))
        addOperation(.UnaryOperation("cos", cos))
        addOperation(.UnaryOperation("√", sqrt))
        
        addOperation(.Constant("π", M_PI))
        
        return operations
    }
    
    private static let knownOperations = CalculatorBrain.buildKnownOprations()

    private let formatter = NSNumberFormatter()
    
    private var stack = [Operation]()
    
    public var program: AnyObject { // Have to be a property List
        get {
            return stack.map { $0.description }
        }
        set (value) {
            if let value = value as? [String] {
                stack = value.map {
                    if let operation = CalculatorBrain.knownOperations[$0] {
                        return operation
                    } else if let operand = formatter.numberFromString($0) {
                        return Operation.Operand(operand.doubleValue)
                    } else {
                        return Operation.Variable($0)
                    }
                }
            }
        }
        
    }
    
    public func pushOperand(value: Double) -> Result {
        stack.append(.Operand(value))
        return evaluate()
    }

    public func pushOperand(symbol: String) -> Result {
        stack.append(.Variable(symbol))
        return evaluate()
    }

    public func performOperation(symbol: String) -> Result {
        if let operation = CalculatorBrain.knownOperations[symbol] {
            stack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(var position: Int) -> (Int, Double?) {
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
            } else {
                return (postion, nil)
            }
            
        case .BinaryOperation(_, let calculation):
            let (position, left) = evaluate(position)
            if let left = left {
                let (position, right) = evaluate(position)
                if let right = right {
                    return (position, calculation(left, right))
                } else {
                    return (position, nil)
                }
            } else {
                return (position, nil)
            }
            
        case .Constant(_, let value):
            return (position, value)
            
        case .Variable(let symbol):
            return (position, variablesValues[symbol])
        }
    }
    
    private func describe(var position: Int) -> (String?, Int, String) {
        if position < 0  || position >= stack.count {
            return (nil, position, "?")
        }
        let operation = stack[position]
        position--
        let description: String
        let bracesCategory: String?
        switch operation {
            
        case .Operand(let value):
            description = "\(value)"
            bracesCategory = nil
            
        case .UnaryOperation(let symbol, _):
            let (_, position1, innerDescr) = describe(position)
            description = "\(symbol)(\(innerDescr))"
            bracesCategory = nil
            position = position1
            
        case .BinaryOperation(let symbol, _):
            var (leftBraces, position1, leftDescr) = describe(position)
            var (rightBraces, position2, rightDescr) = describe(position1)
            bracesCategory = symbol
            
            if leftBraces != nil && bracesCategory != leftBraces {
                leftDescr = "(\(leftDescr))"
            }
            if rightBraces != nil && bracesCategory != rightBraces {
                rightDescr = "(\(rightDescr))"
            }
            description = "\(rightDescr) \(symbol) \(leftDescr)"
            position = position2
            
        case .Constant(let symbol, _):
            description = symbol
            bracesCategory = nil
            
        case .Variable(let symbol):
            description = symbol
            bracesCategory = nil
        }

        return (bracesCategory, position, description)
    }
    
    public func evaluate() -> Result {
        if stack.isEmpty {
            return CalculatorBrain.EMPTY_RESULT
        }
        let (_, value) = evaluate(stack.count - 1)
        var position = stack.count - 1
        var description: String = ""
        repeat {
            let step: String
            (_, position, step) = describe(position)
            if description == "" {
                description = step
            } else {
                description += "; \(step)"
            }
            
        } while position >= 0
        print("\(description) = \(value); \(variablesValues)")
        return Result(value, description)
    }
    
    public var toString: String {
        get {
            return "\(stack)"
        }
    }
    
    public func clean() -> Result {
        stack = []
        variablesValues = [:]
        return CalculatorBrain.EMPTY_RESULT
    }
    
    public func stepBack() -> Result {
        if !stack.isEmpty {
            stack.removeLast()
        }
        return evaluate()
    }
}