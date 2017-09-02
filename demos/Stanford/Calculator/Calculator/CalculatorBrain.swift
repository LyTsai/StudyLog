//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by iMac on 16/7/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

func multiply(_ a1 : Double, b1 : Double) -> Double {
    return a1 * b1
}

class CalculatorBrain {
    
    fileprivate var accumulator = 0.0
    fileprivate var internalProgram = [AnyObject]()
    
    func setOperand(_ operand : Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    fileprivate var operations : Dictionary<String, Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "✕" : Operation.binaryOperation({$0 * $1 }),
        "÷" : Operation.binaryOperation({$0 / $1 }),
        "+" : Operation.binaryOperation({$0 + $1 }),
        "-" : Operation.binaryOperation({$0 - $1 }),
        "=" : Operation.equals
    ]
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(_ symbol : String) {
        internalProgram.append(symbol as AnyObject)
        if  let operation = operations[symbol] {
            switch operation {
            case .constant(let value) :
                accumulator = value
            case .unaryOperation(let foo):
                accumulator = foo(accumulator)
            case .binaryOperation(let function):
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    fileprivate func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    fileprivate var pending: PendingBinaryOperationInfo?
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    }else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
    
}
