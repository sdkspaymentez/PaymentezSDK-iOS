//
//  FourthController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class FourthController: PaymentezViewController {
    
    static let FOURTH_CONTROLLER_VIEW_NAME = "FourthController"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    init() {
        super.init(nibName: FourthController.FOURTH_CONTROLLER_VIEW_NAME, bundle: PaymentezSDK.shared.getBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.finishFlow)))
        innerBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backDidPressed)))
    }
    
    @objc func finishFlow() {
        PaymentezSDK.shared.onSearchFinished()
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
