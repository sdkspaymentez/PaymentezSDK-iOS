//
//  ThirdController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class ThirdController: PaymentezViewController {
    
    static let THIRD_CONTROLLER_VIEW_NAME = "ThirdController"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    init() {
        super.init(nibName: ThirdController.THIRD_CONTROLLER_VIEW_NAME, bundle: PaymentezSDK.shared.getBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToFourthPage)))
        innerBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backDidPressed)))
    }
    
    @objc func goToFourthPage() {
        let vc = FourthController.init()
        PaymentezSDK.shared.pushVC(vc: vc)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
