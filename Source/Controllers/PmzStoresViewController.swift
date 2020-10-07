//
//  FirstController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation
import UIKit

class PmzStoresViewController: PaymentezViewController {
    
    static let PMZ_STORES_VC = "PmzStoresVC"
    
    @IBOutlet var nextButton: UIView!
    
    var searchFilter: String?
    
    init() {
        super.init(nibName: PmzStoresViewController.PMZ_STORES_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSecondPage)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToSecondPage() {
        let secondController = PmzMenuViewController.init()
        PaymentezSDK.shared.pushVC(vc: secondController)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        PaymentezSDK.shared.onSearchCancelled()
    }
}
