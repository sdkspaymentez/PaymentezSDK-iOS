import Foundation

class PmzPayAndPlaceViewController: PaymentezViewController {
    static let PMZ_PAY_AND_PLACE_VC = "PmzPayAndPlaceVC"
    
    @IBOutlet var paymentErrorButton: UIView!
    @IBOutlet var placeErrorButton: UIView!
    @IBOutlet var successButton: UIView!
    @IBOutlet var paymentErrorText: UILabel!
    @IBOutlet var placeErrorText: UILabel!
    @IBOutlet var successText: UILabel!
    
    var order: PmzOrder?
    var orders: [PmzOrder]?
    var paymentData: PmzPaymentData?
    var skipSummary: Bool = false
    
    init() {
        super.init(nibName: PmzPayAndPlaceViewController.PMZ_PAY_AND_PLACE_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonColors()
        paymentErrorButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onPaymentError)))
        placeErrorButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onPlaceError)))
        successButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onSuccess)))
    }
    
    func setButtonColors(){
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            paymentErrorButton.backgroundColor = buttonColor
            placeErrorButton.backgroundColor = buttonColor
            successButton.backgroundColor = buttonColor
        } else {
            paymentErrorButton.backgroundColor = UIColor(named: "orange")
            placeErrorButton.backgroundColor = UIColor(named: "orange")
            successButton.backgroundColor = UIColor(named: "orange")
        }
        if let buttonTextColor = PaymentezSDK.shared.style?.buttonTextColor {
            paymentErrorText.textColor = buttonTextColor
            placeErrorText.textColor = buttonTextColor
            successText.textColor = buttonTextColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onPaymentError() {
        if order != nil {
            PaymentezSDK.shared.onPaymentCheckingError(order: order!, error: PmzError(type: PmzError.PAYMENT_ERROR_KEY))
        } else if orders != nil {
            PaymentezSDK.shared.onPaymentCheckingError(orders: orders!, error: PmzError(type: PmzError.PAYMENT_ERROR_KEY))
        }
    }
    
    @objc func onPlaceError() {
        if order != nil {
            PaymentezSDK.shared.onPaymentCheckingError(order: order!, error: PmzError(type: PmzError.PLACE_ERROR_KEY))
        } else if orders != nil {
            PaymentezSDK.shared.onPaymentCheckingError(orders: orders!, error: PmzError(type: PmzError.PLACE_ERROR_KEY))
        }
    }
    
    @objc func onSuccess() {
        if skipSummary {
            if order != nil {
                PaymentezSDK.shared.onPaymentCheckingFinished(order: order!)
            } else if orders != nil {
                PaymentezSDK.shared.onPaymentCheckingFinished(orders: orders!)
            }
        } else {
            let paymentDetailController = PmzResultViewController.init()
            paymentDetailController.order = order
            paymentDetailController.orders = orders
            PaymentezSDK.shared.pushVC(vc: paymentDetailController)
        }
    }
    
}
