//
//  PhoneVerifyView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/19/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import Parse

enum PhoneVerifyViewMode {
    case EnterPhoneNumber
    case EnterVerificationCode
}

class PhoneVerifyView: UIView, UITextFieldDelegate {
    
    var onVerified:((phone:String)->Void)?
    var onSend:(()->Void)?
    
    var mode:PhoneVerifyViewMode = .EnterPhoneNumber
    var userPhoneNumber:String = ""
    var userVerificationCode:String = ""
    
    let VerifyFieldPlaceholder:String = "Verification Code"
    let SendFieldPlaceholder:String = "Mobile Number"
    let SendCodeMessage:String = "To help us protect against spammers and to keep our members safe, please verify your phone number."
    let VerifyCodeMessage:String = "Enter your verification code."
    let VerificationCode:String = "+1"
    
    @IBOutlet weak var shareMessage: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func onSendCode(sender: AnyObject) {
        send()
    }
    
    @IBOutlet weak var backBtn: UIButton!
    @IBAction func onBack(sender: AnyObject) {
        reset()
    }
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var field: TextField!
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBAction func onResend(sender: AnyObject) {
        generateAndSendVerificationCode()
    }
    
    func clear() {
        reset()
    }
    
    func generateAndSendVerificationCode() {
        let code_left = Int.random(100...999)
        let code_right = Int.random(100...999)
        let code  = "\(code_left) \(code_right)"
        userVerificationCode = "\(code_left)\(code_right)"
        let stringArray = field.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let phoneNumber = stringArray.joinWithSeparator("")
        PFCloud.callFunctionInBackground("sendSMS", withParameters: ["message": "Your verification code is \(code)", "number": "\(VerificationCode)\(phoneNumber)"]) { (response, error) in
        }
    }
    
    func send() {
        generateAndSendVerificationCode()
        hideKeyboard()
        backBtn.hidden = false
        resendBtn.hidden = false
        message.text = VerifyCodeMessage
        field.placeholder = VerifyFieldPlaceholder
        field.keyboardType = UIKeyboardType.NumberPad
        field.text = ""
        shareMessage.hidden = true
        sendBtn.hidden = true
        mode = .EnterVerificationCode
        onSend?()
    }
    
    func reset() {
        hideKeyboard()
        userPhoneNumber = ""
        userVerificationCode = ""
        backBtn.hidden = true
        resendBtn.hidden = true
        sendBtn.hidden = false
        shareMessage.hidden = false
        message.text = SendCodeMessage
        field.placeholder = SendFieldPlaceholder
        field.keyboardType = UIKeyboardType.PhonePad
        field.text = ""
        mode = .EnterPhoneNumber
    }
    
    func hideKeyboard() {
        field.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if mode == .EnterPhoneNumber {
            let formatter = ECPhoneNumberFormatter()
            textField.text = formatter.stringForObjectValue(text)
            return false
        }
        else if mode == .EnterVerificationCode {
            if text == userVerificationCode {
                hideKeyboard()
                onVerified?(phone: userPhoneNumber)
            }
        }
        
        return true
    }
    
    func configureUI() {
        reset()
        field.delegate = self
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    static func loadFromXib() -> PhoneVerifyView {
        let instance = NSBundle.mainBundle().loadNibNamed("PhoneVerifyView", owner: self, options: nil)!.first as! PhoneVerifyView
        instance.frame = UIScreen.mainScreen().bounds
        instance.layoutIfNeeded()
        instance.configureUI()
        return instance
    }
    
}


















