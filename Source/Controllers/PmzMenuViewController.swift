//
//  SecondController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class PmzMenuViewController: PaymentezViewController {
    
    static let PMZ_MENU_VC = "PmzMenuVC"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    
    var storeId: CLong?
    
    init() {
        super.init(nibName: PmzMenuViewController.PMZ_MENU_VC, bundle: PaymentezSDK.shared.getBundle())
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
        let vc = PmzProductViewController.init()
        PaymentezSDK.shared.pushVC(vc: vc)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if(storeId != nil) {
            PaymentezSDK.shared.onSearchCancelled()
        }
    }
}
