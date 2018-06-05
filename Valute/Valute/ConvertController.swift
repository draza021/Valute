//
//  ConvertController.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class ConvertController: UIViewController {
    
    @IBOutlet weak var keypadView: KeypadView!
    @IBOutlet weak var sourceCurrencyBox: CurrencyBox!
    @IBOutlet weak var targetCurrencyBox: CurrencyBox!
    
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var containerBottomEdgeConstraint: NSLayoutConstraint!
    @IBOutlet var panel2UpperEqualHeight: NSLayoutConstraint!
    
    private weak var pickerController: PickerController?
    
    private var sourceCurrencyCode: String = UserDefaults.sourceCC
    private var targetCurrencyCode: String = UserDefaults.targetCC
    var amount: Decimal? {
        didSet {
            if !isViewLoaded { return }
            convert()
        }
    }
    private var rate: Decimal? {
        didSet {
            if !isViewLoaded { return }
            convert()
        }
    }
    
    
    weak var activeCurrencyBox: CurrencyBox?
    
    override func viewDidLoad() {
        keypadView.animationDelegate = self
        keypadView.delegate = self
        hideCurrencyBoxes()
        cleanupUI()
        setupInitialState()
        
        fetchRate()
        convert()
    }
}

private extension ConvertController {
    
    func pickCurrency() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PickerController") as? PickerController {
            vc.delegate = self
            vc.currencies = Locale.commonISOCurrencyCodes
            
            addChildViewController(vc)
            pickerContainerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            
            // setup constraints
            vc.view.topAnchor.constraint(equalTo: pickerContainerView.topAnchor, constant: 0).isActive = true
            vc.view.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor, constant: 0).isActive = true
            let bac = vc.view.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor, constant: 0)
            bac.priority = UILayoutPriority(999)
            bac.isActive = true
            let tac = vc.view.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor, constant: 0)
            tac.priority = UILayoutPriority(999)
            tac.isActive = true
            
            vc.didMove(toParentViewController: self)
            
            pickerController = vc
            
        }
    }
    
    func cleanupUI() {
        sourceCurrencyBox.amount = nil
        targetCurrencyBox.amount = nil
    }
    
    func setupInitialState() {
        sourceCurrencyBox.currencyCode = sourceCurrencyCode
        targetCurrencyBox.currencyCode = targetCurrencyCode
    }
    
    @IBAction func changeCurrency(_ sender: CurrencyBox) {
        if let vc = pickerController {
            collapsePickerController(vc)
            return
        }
        
        activeCurrencyBox = sender
        
        panel2UpperEqualHeight.isActive = true
        containerBottomEdgeConstraint.isActive = true
        containerHeightConstraint.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] isSuccessful in
            if !isSuccessful {
                return
            }
            self?.pickCurrency()
        }
    }
    
    func fetchRate() {
        ExchangeManager.shared.rate(for: targetCurrencyCode, versus: sourceCurrencyCode) {
            [weak self] r, error in
            
            DispatchQueue.main.async {
                [weak self] in
                if let error = error as? ExchangeError {
                    // display error
                    switch error {
                    case .fetchingRates:
                        return
                    case .missingRate:
                        break
                    case .invalidResponse:
                        break
                    case .urlError(let error):
                        break
                    }
                    
                    let alertController = UIAlertController(title: error.title,
                                                            message: error.message,
                                                            preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(alertAction)
                    
                    self?.present(alertController, animated: true)
                    
                    return
                }
                self?.rate = r
            }
        }
    }
    
    func convert() {
        guard let amount = amount,
            let rate = rate else { targetCurrencyBox.amount = nil
                return
        }
        let res = amount * rate
        targetCurrencyBox.amount = NumberFormatter.decimalFormatter.string(for: res)
    }
}

extension ConvertController {
    
    func collapsePickerController(_ vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        if vc.isViewLoaded {
            vc.view.removeFromSuperview()
        }
        vc.removeFromParentViewController()
        
        containerBottomEdgeConstraint.isActive = false
        panel2UpperEqualHeight.isActive = false
        containerHeightConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        pickerController = nil
    }
    
    func hideCurrencyBoxes() {
        let rootViewWidth = self.view.frame.width
        sourceCurrencyBox.transform = CGAffineTransform(translationX: -rootViewWidth, y: 0)
        targetCurrencyBox.transform = CGAffineTransform(translationX: rootViewWidth, y: 0)
    }
    
    func animateCurrencyBoxes() {
        let animDurationSpring = 1.3
        UIView.animate(withDuration: animDurationSpring, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.sourceCurrencyBox.transform = CGAffineTransform(translationX: 0, y: 0)
            self.targetCurrencyBox.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}

extension ConvertController: KeypadViewAnimationDelegate {
    func buttonAnimationCompleted() {
        animateCurrencyBoxes()
    }
}

extension ConvertController: KeypadViewDelegate {
    func keypadView(_ keypad: KeypadView, didChangeValue value: String?) {
        sourceCurrencyBox.amount = value
        amount = keypad.amount
    }
}

extension ConvertController: PickerControllerDelegate {
    func pickerController(_ controller: PickerController, didSelectCurrency cc: String) {
        activeCurrencyBox?.currencyCode = cc
        
        if activeCurrencyBox == sourceCurrencyBox {
            UserDefaults.sourceCC = cc
            sourceCurrencyCode = cc
        } else {
            UserDefaults.targetCC = cc
            targetCurrencyCode = cc
        }
        
        if let vc = pickerController {
            collapsePickerController(vc)
        }
        
        fetchRate()
    }
}









