//
//  ViewController.swift
//  Calculator
//
//  Created by temp on 4/22/17.
//  Copyright © 2017 Treasure Development. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: -
    // MARK: Outlets

    @IBOutlet private weak var display: UILabel!
    
    // MARK: -
    // MARK: Private Properties
    
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text ?? ""
            display.text = "\(textCurrentlyInDisplay)\(digit)"
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
    // MARK: -
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .bannerColor
    }
}

