//
//  KeypadView.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

protocol KeypadViewAnimationDelegate: class {
    func buttonAnimationCompleted()
}

protocol KeypadViewDelegate: class {
    func keypadView(_ keypad: KeypadView, didChangeValue value: String?)
}

final class KeypadView: UIView {
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operatorButtons: [UIButton]!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var equalsButton: UIButton!
    
    @IBOutlet private var plusHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var equalsHeightConstraint: NSLayoutConstraint!
    
    weak var animationDelegate: KeypadViewAnimationDelegate?
    weak var delegate: KeypadViewDelegate?
   
    
    //MARK:- Data model
    private var originalBackgroundColor: UIColor?
    private var firstOperand: Decimal?
    private var secondOperand: Decimal?
    private var operation: Operation?
    
    private(set) var stringAmount: String? {
        didSet {
            delegate?.keypadView(self, didChangeValue: stringAmount)
        }
    }
    
    var amount: Decimal? {
        guard let str = stringAmount else { return nil }
        return NumberFormatter.decimalFormatter.number(from: str)?.decimalValue
    }
    
    enum Operation {
        case add, subtract, divide, multiply
    }
}


extension KeypadView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideButtons()
        animateButtons()
        setupButtonsTouch()
        setupButtonsUntouch()
        setupButtonsTap()
        configureDecimalButton()
        
        
    }
}
private extension KeypadView {
    var allButtons: [UIButton] {
        return digitButtons + operatorButtons + [equalsButton, dotButton, clearButton]
    }
    
    ///    Sets up target-action pattern for the TouchUpInside event
    func setupButtonsTap() {
        for btn in digitButtons {
            btn.addTarget(self, action: #selector(KeypadView.addDigit), for: .touchUpInside)
        }
        
        for btn in operatorButtons {
            btn.addTarget(self, action: #selector(KeypadView.chooseOperation), for: .touchUpInside)
        }
    }
    
    @objc func addDigit(_ sender: UIButton) {
        guard let numString = sender.caption else {
            didUntouchButton(sender)
            return
        }
        
        var value = stringAmount ?? ""
        value += numString
        stringAmount = value
        
        didUntouchButton(sender)
    }
    
    @objc func chooseOperation(_ sender: UIButton) {
        if operation == nil {
            firstOperand = extractOperand()
            stringAmount = nil
        }
        
        if let caption = sender.caption {
            switch caption {
            case "+":
                operation = .add
            case "−":
                operation = .subtract
            case "×":
                operation = .multiply
            case "÷":
                operation = .divide
            default:
                break
            }
            //    hide operators, reveal Equals
            switchOperatorsUI(true)
        }
        
        didUntouchButton(sender)
    }
    
    func extractOperand() -> Decimal? {
        guard let s = stringAmount else { return nil }
        let num = NumberFormatter.decimalFormatter.number(from: s)?.decimalValue
        return num
    }
    
    func switchOperatorsUI(_ showEquals: Bool) {
        plusHeightConstraint.isActive = showEquals
        equalsHeightConstraint.isActive = !showEquals
        UIView.animate(withDuration: 0.3) {
            [weak self] in self?.layoutIfNeeded()
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        secondOperand = extractOperand()
        
        guard
            let operation = operation,
            let firstOperand = firstOperand,
            let secondOperand = secondOperand
            else {
                didUntouchButton(sender)
                return
        }
        
        let result: Decimal
        switch operation {
        case .add:
            result = firstOperand + secondOperand
        case .subtract:
            result = firstOperand - secondOperand
        case .divide:
            result = firstOperand / secondOperand
        case .multiply:
            result = firstOperand * secondOperand
        }
        
        if let s = NumberFormatter.decimalFormatter.string(for: result) {
            stringAmount = s
        }
        
        //    cleanup
        self.firstOperand = nil
        self.secondOperand = nil
        self.operation = nil
        
        didUntouchButton(sender)
        
        //    hide equals, reveal operators
        switchOperatorsUI(false)
    }
    
    @IBAction func deleteDigit(_ sender: UIButton) {
        guard let str = stringAmount, str.count > 0 else {
            didUntouchButton(sender)
            return
        }
        
        let s = String(str.dropLast())
        stringAmount = s
        
        didUntouchButton(sender)
    }
    
    @IBAction func addDot(_ sender: UIButton) {
        guard let str = sender.caption else {
            didUntouchButton(sender)
            return
        }
        
        var value = stringAmount ?? ""
        if !value.contains(str) {
            value += str
            stringAmount = value
        }
        
        didUntouchButton(sender)
    }
}

private extension KeypadView {
    //    MARK: visuals
    func setupButtonsTouch() {
        for btn in allButtons {
            btn.addTarget(self, action: #selector(KeypadView.didTouchButton), for: .touchDown)
        }
    }
    
    @objc func didTouchButton(_ sender: UIButton) {
        originalBackgroundColor = sender.backgroundColor
        
        //    since buttons already have transparent background and
        //    some of them have transparent background,
        //    we need to be careful when altering the background
        
        //    first, if there is no bg color, then use very transparent black
        guard let _ = sender.backgroundColor else {
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return
        }
        
        //    Since buttons backgrounds are already partially transparent,
        //    we need to increase the alpha components, in order to visualize tapping
        //    (larger alpha == less transparent, more opacity)
        
        //    here's a way to extract RGBA components from the UIColor
        //    setup default (black)
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        //    and use 20% opacity
        var a : CGFloat = 0.2
        //    this method will populate the components above using given UIColor value
        guard let _ = sender.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            //    if extraction fails, then fall back to black, as above
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return
        }
        //    if it worked, then setup new color using doubled value of original alpha
        sender.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a*2)
    }
    
    ///    Sets up target-action pattern for the TouchCancel, TouchUpOutside event on all the buttons.
    func setupButtonsUntouch() {
        for btn in allButtons {
            btn.addTarget(self, action: #selector(KeypadView.didUntouchButton), for: .touchCancel)
            btn.addTarget(self, action: #selector(KeypadView.didUntouchButton), for: .touchUpOutside)
        }
    }
    
    
    ///    This restores the original background color of the button, after touch event ends.
    ///    Called when touch is cancelled or ended either inside or outside the button
    @objc func didUntouchButton(_ sender: UIButton) {
        sender.backgroundColor = originalBackgroundColor
        originalBackgroundColor = nil
    }
    
    ///    Displays proper decimalSeparator, based on current Locale
    func configureDecimalButton() {
        dotButton.setTitle(Locale.current.decimalSeparator, for: .normal)
    }
}



// MARK: - Animation functions
extension KeypadView {
    
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
                self.animationDelegate?.buttonAnimationCompleted()
            })
        }
    }
}







