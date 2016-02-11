    //
//  Calculator.swift
//  Calculator
//
//  Created by Waleed Amer on 2/10/16.
//  Copyright © 2016 Amer Software. All rights reserved.
//

import Foundation

enum InputType {
    case Digit
    case Operator
    case Point
    case Equal
    case Clear
    case Answer
    case Delete
}

enum CalculatorState {
    case Start
    case Partial_Int
    case Partial_Double
    case After_Operator
}

class Calculator {
    var state: CalculatorState = .Start
    var string: String = "0"
    
    var pendingValue: Double? = nil
    var pendingOperator: Character? = nil
    var lastAnswer: Double? = nil
    
    func handleInput(InputType type: InputType, input: Character? = nil) -> (output: String, error: Bool) {
        // Get initial state so that we can tell if the state changed at the end (For debug purposes)
        let initialState = state
        
        // If there's an error within this function, error will be set to true before the function returns
        var error = false
        
        // Check which type of input the button press was
        switch type {
            
            // MARK: Digit
            case .Digit:
                switch (state) {
                    
                    case .Start:
                        if let digit = input {
                            if pendingOperator == nil {
                                if digit != "0" {
                                    string = String(digit)
                                    state = .Partial_Int
                                }
                            }
                            else {
                                if digit != "0" {
                                    string = String(digit)
                                    state = .Partial_Int
                                }
                            }
                        }
                        break
                    
                    case .Partial_Int:
                        if let digit = input {
                            string = string + String(digit)
                        }
                        break
                    
                    case .Partial_Double:
                        if let digit = input {
                            string = string + String(digit)
                        }
                        break
                    
                    case .After_Operator:
                        if let digit = input {
                            string = String(digit)
                            state = .Partial_Int
                        }
                        break
                    
                    default:
                        break
                    
                }
                break
            
            // MARK: Operator
            case .Operator:
                switch (state) {
                    
                    case .Start:
                        error = true
                        break
                    
                    case .Partial_Int:
                        if pendingOperator == nil {
                            if let op = input {
                                pendingOperator = op
                                pendingValue = Double(string)
                                state = .After_Operator
                            }
                            else {
                                error = true
                            }
                        }
                        break
                    
                    case .Partial_Double:
                        if pendingOperator == nil {
                            if let op = input {
                                pendingOperator = op
                                pendingValue = Double(string)
                                state = .After_Operator
                            }
                            else {
                                error = true
                            }
                        }
                        break
                    
                    case .After_Operator:
                        error = true
                        break
                    
                    default:
                        break
                }
                break
            
            // MARK: Point
            case .Point:
                switch (state) {
                    
                    case .Start:
                        string = string + "."
                        state = .Partial_Double
                        break
                    
                    case .Partial_Int:
                        string = string + "."
                        state = .Partial_Double
                        break
                    
                    case .Partial_Double:
                        error = true
                        break
                    
                    case .After_Operator:
                        string = "0."
                        state = .Partial_Double
                    
                    default:
                        break
                    
                }
                break
            
            // MARK: Equal
            case .Equal:
                switch (state) {
                    
                    case .Start:
                        break
                    
                    case .Partial_Int:
                        if let val1 = pendingValue {
                            if let val2 = Double(string) {
                                
                                let answer: Double
                                if pendingOperator == "+" {
                                    answer = val1 + val2
                                }
                                else if pendingOperator == "-" {
                                    answer = val1 - val2
                                }
                                else if pendingOperator == "x" {
                                    answer = val1 * val2
                                }
                                else if pendingOperator == "÷" {
                                    answer = val1 / val2
                                }
                                else {
                                    answer = 0
                                    error = true
                                }
                                
                                if (isInteger(answer)) {
                                    string = String(Int(floor(answer)))
                                    state = .Partial_Int
                                }
                                else {
                                    string = String(answer)
                                    state = .Partial_Double
                                }
                                
                                lastAnswer = answer
                                pendingOperator = nil
                                pendingValue = nil
                            }
                        }
                        break
                    
                    case .Partial_Double:
                        if let val1 = pendingValue {
                            if let val2 = Double(string) {
                                
                                let answer: Double
                                if pendingOperator == "+" {
                                    answer = val1 + val2
                                }
                                else if pendingOperator == "-" {
                                    answer = val1 - val2
                                }
                                else if pendingOperator == "x" {
                                    answer = val1 * val2
                                }
                                else if pendingOperator == "÷" {
                                    answer = val1 / val2
                                }
                                else {
                                    answer = 0
                                    error = true
                                }
                                
                                if (floor(answer) == answer) {
                                    string = String(Int(floor(answer)))
                                }
                                else {
                                    string = String(answer)
                                }
                                
                                lastAnswer = answer
                                pendingOperator = nil
                                pendingValue = nil
                            }
                        }
                        break
                    
                    default:
                        break
                    
                }
                break
            
            // MARK: Answer
            case .Answer:
                if let last = lastAnswer {
                    switch state {
                        
                        case .Start:
                            if (isInteger(last)) {
                                string = String(Int(floor(last)))
                                state = .Partial_Int
                            }
                            else {
                                string = String(last)
                                state = .Partial_Double
                            }
                            break
                        
                        case .After_Operator:
                            if (isInteger(last)) {
                                string = String(Int(floor(last)))
                                state = .Partial_Int
                            }
                            else {
                                string = String(last)
                                state = .Partial_Double
                            }
                            
                        default:
                            break
                        
                    }
                }
                else {
                    error = true
                    break
                }
                
                break
            
            // MARK: Clear
            case .Clear:
                if state == .Start {
                    error = true
                    break
                }
                string = "0"
                state = .Start
                pendingValue = nil
                pendingOperator = nil
                break
            
            // MARK: Delete
            case .Delete:
                switch state {
        
                    case .Start:
                        error = true
                        break
                    
                    case .Partial_Int:
                        if (string.characters.count == 1) {
                            string = "0"
                            state = .Start
                            break
                        }
                        
                        string.removeAtIndex(string.endIndex.predecessor())
                        break
                    
                    case .Partial_Double:
                        let lastChar: Character = string[string.endIndex.predecessor()]
                        
                        if (lastChar == ".") {
                            state = .Partial_Int
                        }
                        
                        string.removeAtIndex(string.endIndex.predecessor())
                        break
                    
                    case .After_Operator:
                        pendingOperator = nil
                        if isInteger(string) {
                            state = .Partial_Int
                        }
                        else {
                            state = .Partial_Double
                        }
                        break
                    
                    default:
                        break
                }
                break
            
            // MARK: Default
            default:
                break
        }
        
        if state != initialState {
            print("Switched to state: \(state)")
        }
        
        return (string, error)
    }
    
    func isInteger(number: String) -> Bool {
        if let val: Double = Double(string) {
            return isInteger(val)
        }
        else {
            return false
        }
    }
    
    func isInteger(answer: Double) -> Bool {
        if (floor(answer) == answer) {
            return true
        }
        else {
            return false
        }
    }
}
