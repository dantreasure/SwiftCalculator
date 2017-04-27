//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by temp on 4/23/17.
//  Copyright © 2017 Treasure Development. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // MARK: -
    // MARK: Properties
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    // MARK: -
    // MARK: Methods
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let acc = accumulator {
                    accumulator = function(acc)
                }
            case .binaryOperation(let function):
                if let acc = accumulator {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: acc)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // MARK: -
    // MARK: Private Properties
    
    private var accumulator: Double?
    
    private var operations: [String: CalculatorOperation] = [
        "π" : CalculatorOperation.constant(Double.pi),
        "e" : CalculatorOperation.constant(M_E),
        "√" : CalculatorOperation.unaryOperation(sqrt),
        "cos": CalculatorOperation.unaryOperation(cos),
        "±": CalculatorOperation.unaryOperation { -$0 },
        "×": CalculatorOperation.binaryOperation { $0 * $1 },
        "÷": CalculatorOperation.binaryOperation { $0 / $1 },
        "-": CalculatorOperation.binaryOperation { $0 - $1 },
        "+": CalculatorOperation.binaryOperation { $0 + $1 },
        "=": CalculatorOperation.equals
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // MARK: -
    // MARK: Private Methods
    
    private mutating func performPendingBinaryOperation() {
        if let pbo = pendingBinaryOperation, let acc = accumulator {
            accumulator = pbo.perform(with: acc)
            pendingBinaryOperation = nil
        }
    }
    
    // MARK: -
    // MARK: Private Structures
    
    private enum CalculatorOperation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
}
