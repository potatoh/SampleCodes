//
//  SignupVC.swift
//  ClinicSystem(Patient)
//
//  Created by Sherif Ahmed on 2/25/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import SwiftValidator

class SignupVC: BaseViewController ,ValidationDelegate{
    
    @IBOutlet weak var nameTextField: DesignableUITextField!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var numberTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordTextField: DesignableUITextField!
    @IBOutlet weak var datePickerTextField: DesignableUITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var signUp: UIButton!
    
    let picker = UIDatePicker()
    let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        setValidations()
    }
    
    func setValidations() {
        validator.registerField(nameTextField, errorLabel: nil, rules: [RequiredRule()])
        validator.registerField(emailTextField, errorLabel: nil, rules: [RequiredRule(),EmailRule()])
        
        validator.registerField(numberTextField, errorLabel: nil, rules: [RequiredRule(),PhoneNumberRule()])
        validator.registerField(passwordTextField, errorLabel: nil, rules: [RequiredRule(),PasswordRule()])
        validator.registerField(confirmPasswordTextField, errorLabel: nil, rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextField)])
        validator.registerField(datePickerTextField, errorLabel: nil, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        self.sendSignupRequest()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        self.showAlertWithTitle(title: "Failed", message: (errors.first?.1.errorMessage) ?? "")
    }

    func createDatePicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        done.tintColor = appColor
        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = picker
        
        picker.datePickerMode = .date
    }
    
    @objc func  donePressed() {
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        datePickerTextField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    override func getData() {
        self.errorView.isHidden = true
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(self)
    }
    
    @IBAction func signinTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendSignupRequest() {
        activityIndicator.startAnimating()
        RequestManager.defaultManager.signUpWithemail(email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, gender: genderSegment.selectedSegmentIndex, birthday: datePickerTextField.text!, mobile: numberTextField.text!) {(error, _ , recError)  in
            print(error)
            if !error{
                if (recError?.code!) == .Success{
                    let alert = UIAlertController(title: "\((recError?.code!)!)", message: recError?.desc!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.showAlertWithTitle(title: "\((recError?.code!)!)", message: (recError?.desc!)!)
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

