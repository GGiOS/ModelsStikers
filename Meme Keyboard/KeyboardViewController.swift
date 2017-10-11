//
//  KeyboardViewController.swift
//  Mykeyboard
//
//  Created by Константин on 08.09.15.
//  Copyright © 2015 Константин. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet weak var row2: UIStackView!
    @IBOutlet weak var row3: UIStackView!
    @IBOutlet weak var row4: UIStackView!
    
    @IBOutlet weak var numberSet: UIStackView!
    @IBOutlet weak var charSet: UIStackView!
    
    
    @IBOutlet weak var shiftButton: UIButton!
    var shiftStatus: Int! //0 - off, 1 - on, 2 - caps lock
    
    fileprivate var proxy: UITextDocumentProxy {
        return textDocumentProxy
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Perform custom UI setup here
        
        charSet.isHidden = true
        shiftStatus = 1
        
    }
    
    @IBAction func nextKeyboardPressed(_ sender: UIButton) {
        advanceToNextInputMode()
    }
    
    @IBAction func shiftPressed(_ sender: UIButton) {
        shiftStatus = shiftStatus > 0 ? 0 : 1
        
        shiftChange(row1)
        shiftChange(row2)
        shiftChange(row3)
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        let string = sender.titleLabel!.text
        proxy.insertText("\(string!)")
        
        if shiftStatus == 1 {
            shiftPressed(self.shiftButton)
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            sender.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
            }, completion: { (_) -> Void in
                sender.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) 
    }
    
    @IBAction func charSetPressed(_ sender: UIButton) {
        if sender.titleLabel!.text == "!@#" {
            numberSet.isHidden = true
            charSet.isHidden = false
            sender.setTitle("123", for: UIControlState())
        } else {
            numberSet.isHidden = false
            charSet.isHidden = true
            sender.setTitle("!@#", for: UIControlState())
        }
    }
    
    @IBAction func backSpacePressed(_ sender: UIButton) {
        proxy.deleteBackward()
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        proxy.insertText("\n")
    }
    
    @IBAction func spacePressed(_ sender: UIButton) {
        proxy.insertText(" ")
    }
    
    @IBAction func shiftDoubleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 2
        shiftChange(row1)
        shiftChange(row2)
        shiftChange(row3)
    }
    
    @IBAction func shiftTrippleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 0
        shiftPressed(self.shiftButton)
    }
    
    func shiftChange(_ containerView: UIStackView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if shiftStatus == 0 {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: UIControlState())
                } else {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: UIControlState())
                }
            }
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}
