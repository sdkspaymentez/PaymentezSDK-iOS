//
//  FirstController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation
import UIKit

class FirstController: PaymentezViewController {
    
    static let FIRST_CONTROLLER_VIEW_NAME = "FirstController"
    
    @IBOutlet var nextButton: UIView!
    
    init() {
        super.init(nibName: FirstController.FIRST_CONTROLLER_VIEW_NAME, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSecondPage)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToSecondPage() {
        let secondController = SecondController.init()
        PaymentezSDK.shared.pushVC(vc: secondController)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        PaymentezSDK.shared.onSearchCancelled()
    }
}
