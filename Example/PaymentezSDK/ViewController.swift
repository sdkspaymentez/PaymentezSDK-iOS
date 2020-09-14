//
//  ViewController.swift
//  PaymentezSDK
//
//  Created by ftamburri on 09/11/2020.
//  Copyright (c) 2020 ftamburri. All rights reserved.
//

import UIKit
import PaymentezSDK

class ViewController: UIViewController, PaymentezCallback, UITextFieldDelegate {
    
    @IBOutlet var backgroundColorInput: UITextField!
    @IBOutlet var textColorInput: UITextField!
    @IBOutlet var buttonColorInput: UITextField!
    
    @IBOutlet var backgroundColorShower: UIView!
    @IBOutlet var textColorShower: UIView!
    @IBOutlet var buttonColorShower: UIView!
    
    @IBOutlet var sdkButton: UIView!
    @IBOutlet var randomizeButton: UIView!
    
    var lastSelectedTextField: UITextField?
    
    var backgroundColorSelected: Color?
    var textColorSelected: Color?
    var buttonColorSelected: Color?
    
    var colors: [Color]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.isNavigationBarHidden = true
        colors = Color.getColors()
        setDelegates()
        self.view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.dismissKeyboard)))
        sdkButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSDK)))
        randomizeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.randomizeColors)))
        randomizeColors()
    }
    
    @objc func randomizeColors() {
        didPickBackgroundColor(colors![getRandom()])
        didPickTextColor(colors![getRandom()])
        didPickButtonColor(colors![getRandom()])
    }
    
    func getRandom() -> Int {
        return Int(arc4random_uniform(UInt32(colors!.count)))
    }
    
    func setDelegates() {
        backgroundColorInput.delegate = self
        textColorInput.delegate = self
        buttonColorInput.delegate = self
    }
    
    @objc func goToSDK() {
        PaymentezSDK.shared.setBackgroundColor(backgroundColor: backgroundColorSelected!.color!)
                .setTextColor(textColor: textColorSelected!.color!)
                .setButtonBackgroundColor(buttonBackgroundColor: buttonColorSelected!.color!)
                .setCallback(callback: self)
                .startSDK(navigationController: navigationController!)
    }
    
    func flowFinishedSuccessfully() {
        showToast(controller: self, message: "Flujo terminado exitosamente.", seconds: 1)
    }
    
    func flowCancelled() {
        showToast(controller: self, message: "Flujo cancelado.", seconds: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        lastSelectedTextField = textField
        if(textField == backgroundColorInput) {
            textField.tintColor = UIColor.clear
            showBackgroundColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        if(textField == textColorInput) {
            textField.tintColor = UIColor.clear
            showTextColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        if(textField == buttonColorInput) {
            textField.tintColor = UIColor.clear
            showButtonColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        lastSelectedTextField?.resignFirstResponder()
    }
    
    func showBackgroundColorPicker() {
        showPicker(title: "Seleccione el color del Fondo", items: colors!, completion: { colorSelected in
            self.didPickBackgroundColor(colorSelected)
        })
    }
    
    func showTextColorPicker() {
        showPicker(title: "Seleccione el color del Texto", items: colors!, completion: { colorSelected in
            self.didPickTextColor(colorSelected)
        })
    }
    
    func showButtonColorPicker() {
        showPicker(title: "Seleccione el color del Botón", items: colors!, completion: { colorSelected in
            self.didPickButtonColor(colorSelected)
        })
    }
    
    func didPickBackgroundColor(_ color: Color) {
        self.backgroundColorSelected = color
        self.backgroundColorInput.text = self.backgroundColorSelected!.name!
        self.backgroundColorShower.backgroundColor = self.backgroundColorSelected!.color!
    }
    
    func didPickTextColor(_ color: Color) {
        self.textColorSelected = color
        self.textColorInput.text = self.textColorSelected!.name!
        self.textColorShower.backgroundColor = self.textColorSelected!.color!
    }
    
    func didPickButtonColor(_ color: Color) {
        self.buttonColorSelected = color
        self.buttonColorInput.text = self.buttonColorSelected!.name!
        self.buttonColorShower.backgroundColor = self.buttonColorSelected!.color!
    }
    
    func showPicker(title: String, items: [Color], completion: @escaping (Color)->()) {
        let sexAlertController = UIAlertController(title: title,
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        for i in (0 ... items.count - 1) {
            let item = items[i]
            sexAlertController.addAction(UIAlertAction(title: item.name,
                                                       style: .default,
                                                       handler: { alert in
                                                completion(item)
            }))
        }
        
        sexAlertController.addAction(UIAlertAction(title: "Cancelar",
                                                   style: .cancel,
                                                   handler: nil))
        self.present(sexAlertController, animated: true, completion: nil)
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}

