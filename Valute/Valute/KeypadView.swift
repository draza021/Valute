//
//  KeypadView.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

protocol KeypadViewDelegate: class {
    func buttonAnimationCompleted()
}

final class KeypadView: UIView {
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operatorButtons: [UIButton]!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    weak var delegate: KeypadViewDelegate?
    
    var allButtons: [UIButton] {
        return digitButtons + operatorButtons + [dotButton] + [clearButton]
    }
    
    //MARK:- Data model
    var firstOperand: Double?
    var secondOperand: Double?
    var operation: Operation?
    let operatorCaptions: [String] = ["+", "-", "×", "÷"]
    
    enum Operation {
        case add, subtract, divide, multiply
        case equal
    }
    
}

// MARK:- IBActions
extension KeypadView {
    @IBAction func didTapDigit(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapDot(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapOperator(_ sender: UIButton) {
        
    }
    
}

//MARK:- Operation functions
extension KeypadView {
    
    func add() -> Double? {
        if let firstOperand = firstOperand, let secondOperand = secondOperand {
            return firstOperand + secondOperand
        }
        return nil
    }
    
    func subtract() -> Double? {
        if let firstOperand = firstOperand, let secondOperand = secondOperand {
            return firstOperand - secondOperand
        }
        return nil
    }
    
    func divide() -> Double? {
        if let firstOperand = firstOperand, let secondOperand = secondOperand {
            return firstOperand / secondOperand
        }
        return nil
    }
    
    func multiply() -> Double? {
        if let firstOperand = firstOperand, let secondOperand = secondOperand {
            return firstOperand * secondOperand
        }
        return nil
    }
}

//MARK:- Functions
extension KeypadView {
    
    func extractOperationFromSender(with caption: String?) -> Operation? {
        if let caption = caption {
            switch caption {
            case "+":
                return .add
            case "-":
                return .subtract
            case "÷":
                return .divide
            case "×":
                return .multiply
            case "=":
                return .equal
            default:
                break
            }
        }
        return nil
    }
    
    func setupDigitButtonTaps() {
        for button in digitButtons {
            button.addTarget(self, action: #selector(self.didTapDigit), for: .touchUpInside)
        }
    }
    
    func setupOperatorButtonTaps() {
        for button in operatorButtons {
            button.addTarget(self, action: #selector(self.didTapOperator), for: .touchUpInside)
        }
    }
    
    func resetOperation() {
        firstOperand = nil
        secondOperand = nil
        self.operation = nil
    }
}

extension KeypadView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideButtons()
        animateButtons()
        
    }
    
    private func hideButtons() {
        let rootViewWidth = self.layer.frame.width
        for button in allButtons {
            button.transform = CGAffineTransform(translationX: -rootViewWidth, y: 0)
        }
    }
    
    private func animateButtons() {
        let animDurationSpring = 0.1
        for (index, view) in allButtons.enumerated() {
            //view.frame.origin.y += 30.0
            UIView.animate(withDuration: animDurationSpring, delay: animDurationSpring * Double(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { _ in
                self.delegate?.buttonAnimationCompleted()
            })
        }
    }
}










