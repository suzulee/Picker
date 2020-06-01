//
//  ViewController.swift
//  Picker
//
//  Created by Richard Zheng on 2/19/20.
//  Copyright © 2020 Richard Zheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var choice1: UITextField!
  @IBOutlet weak var choice2: UITextField!
  @IBOutlet weak var choice3: UITextField!
  @IBOutlet weak var choice4: UITextField!
  @IBOutlet weak var choice5: UITextField!
  @IBOutlet weak var pickButton: UIButton!
  @IBOutlet weak var chosen: UILabel!
  @IBOutlet weak var clear: UIButton!
  @IBOutlet weak var yesno: UIButton!
  
  @IBOutlet weak var add: UIStepper!

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var content: UIView!
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
    
    
    let tFArray: [UITextField] = [choice1, choice2, choice3, choice4]
    
    for textField in tFArray {
      textField.delegate = self
      textField.modifyClearButton()
    }
    
    
    pickButton.frame = CGRect(x: pickButton.frame.origin.x, y: pickButton.frame.origin.y, width: 90, height: 90)
    pickButton.layer.cornerRadius = 0.5 * pickButton.bounds.size.width
    
    
    yesno.frame.origin.y = choice3.frame.origin.y
    add.frame.origin.y = choice3.frame.origin.y
    
    clear.frame.origin.y = 245
    
     NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       
       NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else {
      // if keyboard size is not available for some reason, dont do anything
      return
    }

    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    // reset back the content inset to zero after keyboard is gone
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     return true
  }
  
  
  @IBAction func stepping(_ sender: UIStepper) {
    let stepValue = sender.value
    
    if stepValue == 3 {
      choice3.isHidden = false
      choice4.isHidden = true
      choice5.isHidden = true
      choice4.text = ""
      choice5.text = ""
      yesno.frame.origin.y = choice4.frame.origin.y
      add.frame.origin.y = choice4.frame.origin.y
    } else if stepValue == 4 {
      choice4.isHidden = false
      choice5.isHidden = true
      choice5.text = ""
      yesno.frame.origin.y = choice5.frame.origin.y
      add.frame.origin.y = choice5.frame.origin.y
    } else if stepValue == 5 {
      choice5.isHidden = false
      yesno.frame.origin.y = choice5.frame.origin.y + 60
      add.frame.origin.y = choice5.frame.origin.y + 60
    } else {
      reset()
    }
  }
  
  
  
  func reset() {
    add.value = 2
    choice3.isHidden = true
    choice4.isHidden = true
    choice5.isHidden = true
    choice3.text = ""
    choice4.text = ""
    choice5.text = ""
    yesno.frame.origin.y = choice3.frame.origin.y
    add.frame.origin.y = choice3.frame.origin.y

  }
  
  
  
  @IBAction func picking(_ sender: Any) {
    var choices: [String] = []
    
    //if entry options aren't empty, add them to my array
    if choice1.text != "" {
      choices.append(choice1.text!)
    }
    if choice2.text != "" {
      choices.append(choice2.text!)
    }
    if choice3.text != "" {
      choices.append(choice3.text!)
    }
    if choice4.text != "" {
      choices.append(choice4.text!)
    }
    if choice5.text != "" {
      choices.append(choice5.text!)
    }
    
    
    let rand = choices.randomElement()
    
    if choices.count == 0 {
      UIView.transition(with: chosen,
           duration: 0.5,
            options: .transitionFlipFromTop,
         animations: { [weak self] in
             self?.chosen.text = "No Choices Made 🙁"
      }, completion: nil)
    } else {
      UIView.transition(with: chosen,
           duration: 0.5,
            options: .transitionFlipFromTop,
         animations: { [weak self] in
             self?.chosen.text = rand
      }, completion: nil)
    }
    
    

  }
  
  @IBAction func clearAll(_ sender: Any) {
    choice1.text = ""
    choice2.text = ""
    reset()
    chosen.text = "PICK!"
  }

  @IBAction func yesnoClick(_ sender: Any) {
    let yesOrNo = ["Yes", "No"]
    
    let yayNay = yesOrNo.randomElement()
    choice1.text = "Yes"
    choice2.text = "No"
    reset()
    
    
    UIView.transition(with: chosen,
         duration: 0.5,
          options: .transitionFlipFromTop,
       animations: { [weak self] in
           self?.chosen.text = yayNay
    }, completion: nil)
  }
  
}

extension UITextField {
  func modifyClearButton() {
      let clearButton = UIButton(type: .custom)
      clearButton.setImage(UIImage(named: "clear.png"), for: .normal)
      clearButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16
    )
      clearButton.contentMode = .scaleAspectFit
      clearButton.addTarget(self, action: #selector(UITextField.clear(sender:) ), for: .touchUpInside)
      self.rightView = clearButton
      self.rightViewMode = .whileEditing
  }
  

  @objc func clear(sender : AnyObject) {
      self.text = ""
  }
}
