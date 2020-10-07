//
//  FourthController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class PmzSummaryViewController: PaymentezViewController {
    
    static let PMZ_SUMMARY_VC = "PmzSummaryVC"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    
    var order: PmzOrder?
    var justSummary: Bool = false
    
    init() {
        super.init(nibName: PmzSummaryViewController.PMZ_SUMMARY_VC, bundle: PaymentezSDK.shared.getBundle())
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
        if justSummary {
            PaymentezSDK.shared.onSearchCancelled()
        }
    }
}
