import Foundation

class PmzProductViewController: PaymentezViewController {
    
    static let PMZ_PRODUCT_VC = "PmzProductVC"
    
    @IBOutlet var innerBackButton: UIView!
    @IBOutlet var nextButton: UIView!
    init() {
        super.init(nibName: PmzProductViewController.PMZ_PRODUCT_VC, bundle: PaymentezSDK.shared.getBundle())
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
        let vc = PmzSummaryViewController.init()
        PaymentezSDK.shared.pushVC(vc: vc)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
