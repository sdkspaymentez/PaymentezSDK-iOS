import Foundation

class PaymentezViewController: UIViewController {
    @IBOutlet var backButton: UIButton?
    @IBOutlet var headerBar: UIView?
    @IBOutlet var mainText: UILabel?
    @IBOutlet var headerTitle: UILabel?
    @IBOutlet var mainView: UIView?
    @IBOutlet var nextButtonBackground: UIView?
    @IBOutlet var nextButtonTextColor: UILabel?
    @IBOutlet var backTextColor: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPropperColors()
        //headerBar.addBottomShadow()
    }
    
    func setPropperColors() {
        if let bgColor = PaymentezSDK.shared.style?.backgroundColor {
            mainView?.backgroundColor = bgColor
        }
        if let textColor = PaymentezSDK.shared.style?.textColor {
            mainText?.textColor = textColor
            backTextColor?.textColor = textColor
        }
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            headerBar?.backgroundColor = buttonColor
            nextButtonBackground?.backgroundColor = buttonColor
        } else {
            nextButtonTextColor?.backgroundColor = UIColor(named: "orange")
        }
        if let buttonTextColor = PaymentezSDK.shared.style?.buttonTextColor {
            nextButtonTextColor?.textColor = buttonTextColor
            backButton?.imageView?.tintColor = buttonTextColor
            headerTitle?.textColor = buttonTextColor
        }
    }
}
