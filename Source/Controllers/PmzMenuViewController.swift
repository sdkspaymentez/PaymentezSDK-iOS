import Foundation
import XLPagerTabStrip

class PmzMenuViewController: BaseButtonBarPagerTabStripViewController<CustomTabItemCollectionViewCell>, PmzMenuFragmentDelegate, PmzProductVCDelegate, UISearchBarDelegate {
    
    static let PMZ_MENU_VC = "PmzMenuVC"

    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var storeTitle: UILabel!
    @IBOutlet var storeSubtitle: UILabel!
    @IBOutlet var storeDistance: UILabel!
    @IBOutlet var storeLogo: UIImageView!
    
    @IBOutlet var nextButton: UIView!
    @IBOutlet var container: UIScrollView!
    @IBOutlet var headerBar: UIView!
    @IBOutlet var nextButtonBackground: UIView!
    @IBOutlet var nextButtonText: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerTitle: UILabel!
    
    @IBOutlet var magnifyButton: UIButton!
    @IBOutlet var cartButton: UIButton!
    @IBOutlet var searchBarBackground: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    var storeId: CLong?
    var store: PmzStore?
    var menu: PmzMenu?
    var order: PmzOrder?
    
    var filteredCategories: [PmzCategory]?
    
    var forcedId: Bool = false
    
    var vcs: [PmzMenuFragmentVC]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPropperColors()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToCart)))
        
        changeCurrentIndexProgressive = { (oldCell: CustomTabItemCollectionViewCell?, newCell: CustomTabItemCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            if let textColor = PaymentezSDK.shared.style?.textColor {
                oldCell?.label.textColor = textColor.withAlphaComponent(0.6)
                newCell?.label.textColor = textColor
            }
        }
        setSearchBar()
        
        if let store = store {
            self.storeId = store.id!
            getMenu(storeId: store.id!)
            setStoreData()
        } else if storeId != nil {
            forcedId = true
            startSession()
        } else {
            goBackToHostApp("No se ha podido cargar la pantalla.")
        }
    }
    
    init() {
        super.init(nibName: PmzMenuViewController.PMZ_MENU_VC, bundle: PaymentezSDK.shared.getBundle())
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "VirtualCardTabView",
                                                      bundle: PaymentezSDK.shared.getBundle(),
                                                      width: { _ in
                                                        return 140.0
        })
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarHeight = 2
        
        if let barColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            settings.style.selectedBarBackgroundColor = barColor
            settings.style.buttonBarItemBackgroundColor = barColor
        }
    }
    
    func getFilter() -> String {
        if let filter = searchBar.text {
            return filter
        }
        return ""
    }
    
    func setSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshFilter(filter: searchText)
    }
    
    func setPropperColors() {
        searchBar.backgroundImage = UIImage()
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            headerBar?.backgroundColor = buttonColor
            searchBar.backgroundColor = buttonColor
        }
        if let buttonTextColor = PaymentezSDK.shared.style?.buttonTextColor {
            nextButtonText?.textColor = buttonTextColor
            backButton?.imageView?.tintColor = buttonTextColor
            headerTitle?.textColor = buttonTextColor
            magnifyButton.tintColor = buttonTextColor
            cartButton.tintColor = buttonTextColor
        
            if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
                textFieldInsideSearchBar.textColor = buttonTextColor
                if let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView.tintColor = buttonTextColor
                }
                if let clearButton = textFieldInsideSearchBar.value(forKey: "_clearButton")as? UIButton {
                    clearButton.isHidden = true
                    /*if let img3 = clearButton.image(for: .normal) {
                        clearButton.isHidden = false
                        let tintedClearImage = img3.withRenderingMode(.alwaysTemplate)
                        clearButton.setImage(tintedClearImage, for: .normal)
                        clearButton.setImage(tintedClearImage, for: .highlighted)
                        clearButton.tintColor = buttonTextColor
                    }else{
                       clearButton.isHidden = true
                    }*/
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(cell: CustomTabItemCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.label.text = indicatorInfo.title?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if(vcs != nil) {
            return vcs!
        }
        return [PmzMenuFragmentVC()]
    }
    
    func setStoreData() {
        if let store = self.store {
            PmzImageUtils.loadImage(store.imageUrl, imageView: headerImage)
            PmzImageUtils.loadImage(store.imageUrl, imageView: storeLogo)
            
            storeLogo.layer.borderWidth = 5
            storeLogo.layer.borderColor = UIColor.white.cgColor
            
            storeTitle.text = store.name
            storeSubtitle.text = store.commerceName
            
            if let style = PaymentezSDK.shared.style, let textColor = style.textColor {
                storeTitle.textColor = textColor
                storeSubtitle.textColor = textColor
            }
        }
    }
    
    @objc func goToCart() {
        if let items = order?.items, items.count > 0 {
            let vc = PmzCartViewController.init()
            vc.order = order
            vc.store = store
            PaymentezSDK.shared.pushVC(vc: vc)
        }
    }
    
    func showError(_ error: String? = "Ha ocurrido un error inesperado.") {
        let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func itemSelected(_ product: PmzProduct) {
        if let orderId = order?.id {
            let vc = PmzProductViewController.init()
            vc.order = order
            vc.orderId = orderId
            vc.product = product
            vc.delegate = self
            PaymentezSDK.shared.pushVC(vc: vc)
        }
    }
    
    func onItemAddedToOrder(order: PmzOrder) {
        self.order = order
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        if searchBar.isHidden {
            if forcedId {
                PaymentezSDK.shared.onSearchCancelled()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            searchBar.text = ""
            refreshFilter(filter: "")
            searchBarBackground.isHidden = true
            searchBar.isHidden = true
        }
    }
    
    func startSession() {
        showLoading()
        API.sharedInstance.startSession(session: PaymentezSDK.shared.session!, callback: { [weak self] (token) in
            guard let self = self else { return }
            PaymentezSDK.shared.token = token
            self.getStore()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.goBackToHostApp()
        })
    }
    
    func getStore() {
        API.sharedInstance.getStores(callback: { [weak self] (stores) in
            guard let self = self else { return }
            self.dismissPmzLoading()
            self.findStore(stores: stores)
            self.setStoreData()
            self.getMenu(storeId: self.storeId!)
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.goBackToHostApp()
        })
    }
    
    func findStore(stores: [PmzStore]) {
        for store in stores {
            if let storeId = store.id, storeId == self.storeId! {
                self.store = store
            }
        }
    }
    
    func getMenu(storeId: CLong) {
        if !forcedId {
            showLoading()
        }
        API.sharedInstance.getMenu(storeId: storeId, callback: { [weak self] (menu) in
            guard let self = self else { return }
            self.menu = menu
            self.initFragments()
            self.startOrder()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.backDidPressed(self)
        })
    }
    
    func refreshFilter(filter: String) {
        if vcs != nil {
            for vc in vcs! {
                vc.refreshFilter(filter)
            }
        }
    }
    
    func startOrder() {
        let orderStarter = PmzOrder(buyer: PaymentezSDK.shared.buyer!, appOrderReference: PaymentezSDK.shared.appOrderReference!, storeId: storeId!)
        API.sharedInstance.startOrder(order: orderStarter, callback: { [weak self] (order) in
            guard let self = self else { return }
            self.order = order
            self.dismissPmzLoading()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.backDidPressed(self)
        })
    }
    
    func initFragments() {
        vcs = [PmzMenuFragmentVC]()
        if let categories = menu?.categories {
            for category in categories {
                let vc = PmzMenuFragmentVC.init()
                vc.delegate = self
                vc.category = category
                vcs!.append(vc)
            }
            reloadPagerTabStripView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = order?.items, items.count > 0 {
            if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
                nextButtonBackground?.backgroundColor = buttonColor
            } else {
                nextButtonBackground?.backgroundColor = UIColor(named: "orange")
            }
        } else {
            nextButtonBackground?.backgroundColor = UIColor(named: "disabled_button", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil)
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBarBackground.isHidden = false
    }
    
    @IBAction func cartMenuPressed(_ sender: Any) {
        if let items = order?.items, items.count > 0 {
            goToCart()
        } else {
            showError("Tu carrito está vacío.")
        }
    }
    
    func goBackToHostApp(_ error: String? = "Ha ocurrido un error inesperado.") {
        let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: {(alert: UIAlertAction!) in
            PaymentezSDK.shared.goBackWithServiceError()
        }))
        present(alert, animated: true, completion: nil)
    }
}
