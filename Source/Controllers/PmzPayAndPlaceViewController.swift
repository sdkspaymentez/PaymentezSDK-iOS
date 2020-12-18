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
    var paymentData: PmzPaymentData?
    var paymentsData: [PmzPaymentData]?
    var skipSummary: Bool = false
    
    var multiPayment: Bool = false
    
    var currentPayment: PmzPaymentData?
    var currentIndex = 0
    var orderResult: PmzOrder?
    
    init() {
        super.init(nibName: PmzPayAndPlaceViewController.PMZ_PAY_AND_PLACE_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PaymentezSDK.shared.token != nil && PaymentezSDK.shared.token != "" {
            decideFlow()
        } else {
            startSession()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSession() {
        API.sharedInstance.startSession(session: PaymentezSDK.shared.session!, callback: { [weak self] (token) in
            guard let self = self else { return }
            PaymentezSDK.shared.token = token
            self.decideFlow()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.goBackToHostApp()
        })
    }
    
    func decideFlow() {
        if paymentsData != nil {
            multiPayment = true
            handlePayments()
        } else {
            currentPayment = paymentData
            doPayment()
        }
    }
    
    func handlePayments() {
        if currentIndex == 0 {
            if paymentsData != nil && paymentsData!.count > 0 {
                currentPayment = paymentsData![0]
                currentIndex = 1
            } else {
                currentPayment = paymentData
                currentIndex = -1
            }
            doPayment()
        } else if(currentIndex == -1 || paymentsData!.count <= currentIndex){
            doPlace()
        } else {
            currentPayment = paymentsData![currentIndex]
            currentIndex += 1
            doPayment()
        }
    }
    
    func doPayment() {
        if let currentPayment = currentPayment, let orderId = order?.id {
            API.sharedInstance.pay(paymentData: currentPayment, orderId: orderId, callback: { [weak self] (order) in
                guard let self = self else { return }
                self.orderResult = order.mergeData(self.order!)
                self.handlePayments()
                }, failure: { [weak self] (error) in
                    guard let self = self else { return }
                    self.onPaymentError()
            })
        } else {
            goBackToHostApp()
        }
    }
    
    func doPlace() {
        API.sharedInstance.placeOrder(order: orderResult!, callback: { [weak self] (order) in
            guard let self = self else { return }
            self.orderResult = order.mergeData(self.order!)
            self.showSummary()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.onPlaceError()
        })
    }
    
    func showSummary() {
        if !skipSummary {
            let summaryVC = PmzSummaryViewController.init()
            summaryVC.order = orderResult
            summaryVC.fromPayment = true
            PaymentezSDK.shared.pushVC(vc: summaryVC)
        }
    }
    
    @objc func onPaymentError() {
        PaymentezSDK.shared.onPaymentCheckingError(order: order!, error: PmzError(PmzError.PAYMENT_ERROR_KEY))
    }
    
    @objc func onPlaceError() {
        PaymentezSDK.shared.onPaymentCheckingError(order: order!, error: PmzError(PmzError.PLACE_ERROR_KEY))
    }
    
    @objc func onSuccess() {
        
    }
    
}
