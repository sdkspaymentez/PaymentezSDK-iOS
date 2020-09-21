//
//  PaymentDetailViewController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 21/09/2020.
//

import Foundation

class PaymentDetailViewController: PaymentezViewController {
    
    static let PAYMENT_DETAIL_CONTROLLER_VIEW_NAME = "PaymentDetailController"
    
    @IBOutlet var nextButton: UIView!
    
    var order: PmzOrder?
    
    init() {
        super.init(nibName: PaymentDetailViewController.PAYMENT_DETAIL_CONTROLLER_VIEW_NAME, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.finishDetail)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func finishDetail() {
        PaymentezSDK.shared.onPaymentCheckingFinished(order: order!)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        PaymentezSDK.shared.onPaymentCheckingFinished(order: order!)
    }
}
