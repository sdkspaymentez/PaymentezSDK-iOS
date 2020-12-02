import Foundation
import UIKit

class PmzStoresViewController: PaymentezViewController {
    
    static let PMZ_STORES_VC = "PmzStoresVC"
    
    var stores: [PmzStore]?
    var menu: PmzMenu?
    
    @IBOutlet var nextButton: UIView!
    
    init() {
        super.init(nibName: PmzStoresViewController.PMZ_STORES_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSecondPage)))
        startSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToSecondPage() {
        /*let secondController = PmzMenuViewController.init()
        PaymentezSDK.shared.pushVC(vc: secondController)*/
        startSession()
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        PaymentezSDK.shared.onSearchCancelled()
    }
    
    func startSession() {
        API.sharedInstance.startSession(session: PaymentezSDK.shared.session!, callback: { [weak self] (token) in
            guard let self = self else { return }
            PaymentezSDK.shared.token = token
            self.getStores()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.goBackToHostApp()
        })
    }
    
    func getStores() {
        API.sharedInstance.getStores(callback: { [weak self] (stores) in
            guard let self = self else { return }
            self.stores = stores
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.goBackToHostApp()
        })
    }
    
    /*func getMenu(storeId: CLong) {
        API.sharedInstance.getMenu(storeId: storeId, callback: { [weak self] (menu) in
            guard let self = self else { return }
            self.menu = menu
            
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                
        })
    }*/
}
