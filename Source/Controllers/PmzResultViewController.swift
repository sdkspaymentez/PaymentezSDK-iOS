import Foundation

class PmzResultViewController: PaymentezViewController {
    
    static let PMZ_RESULT_VC = "PmzResultVC"
    
    @IBOutlet var nextButton: UIView!
    
    var order: PmzOrder?
    var orders: [PmzOrder]?
    
    init() {
        super.init(nibName: PmzResultViewController.PMZ_RESULT_VC, bundle: PaymentezSDK.shared.getBundle())
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
