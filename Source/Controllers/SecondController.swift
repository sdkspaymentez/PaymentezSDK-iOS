//
//  SecondController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class SecondController: PaymentezViewController {
    
    static let SECOND_CONTROLLER_VIEW_NAME = "SecondController"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    
    init() {
        super.init(nibName: SecondController.SECOND_CONTROLLER_VIEW_NAME, bundle: PaymentezSDK.shared.getBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToThirdPage)))
        innerBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backDidPressed)))
    }
    
    @objc func goToThirdPage() {
        let vc = ThirdController.init()
        PaymentezSDK.shared.pushVC(vc: vc)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
