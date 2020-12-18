import Foundation
import UIKit


class PmzStoresViewController: PaymentezViewController, UITableViewDelegate, UITableViewDataSource, StoreDelegate, UISearchBarDelegate {
    
    static let PMZ_STORES_VC = "PmzStoresVC"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var magnifyingButton: UIButton!
    @IBOutlet var searchBarBackground: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    var stores: [PmzStore]?
    var filteredStores: [PmzStore]?
    var menu: PmzMenu?
    
    var filter: String = ""
    
    @IBOutlet var nextButton: UIView!
    
    init() {
        super.init(nibName: PmzStoresViewController.PMZ_STORES_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StoreCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "StoreCellView")
        setSearchBar()
        setColors()
        startSession()
    }
    
    func setSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshFilter(searchText)
    }
    
    func setColors() {
        searchBar.backgroundImage = UIImage()
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            searchBar.backgroundColor = buttonColor
        }
        if let textColor = PaymentezSDK.shared.style?.buttonTextColor {
            magnifyingButton.tintColor = textColor
            if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
                textFieldInsideSearchBar.textColor = textColor
                if let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView.tintColor = textColor
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        if searchBar.isHidden {
           self.navigationController?.popViewController(animated: true)
           PaymentezSDK.shared.onSearchCancelled()
        } else {
           searchBar.text = ""
           refreshFilter("")
           searchBarBackground.isHidden = true
           searchBar.isHidden = true
        }
    }
    
    func refreshFilter(_ filter: String) {
        self.filter = filter
        doFilter(filter)
        tableView.reloadData()
    }
    
    func doFilter(_ filter: String) {
        filteredStores = [PmzStore]()
        if let stores = stores {
            for store in stores {
                if let storeName = store.name {
                    let loweredName = storeName.lowercased()
                    if filter == "" || loweredName.contains(filter.lowercased()) {
                        filteredStores?.append(store)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStores != nil ? filteredStores!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCellView") as! StoreCellView
        cell.configure(store: filteredStores![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func itemSelected(_ store: PmzStore) {
        let secondController = PmzMenuViewController.init()
        secondController.store = store
        PaymentezSDK.shared.pushVC(vc: secondController)
    }
    
    @IBAction func onSearchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBarBackground.isHidden = false
    }
    
    func startSession() {
        showLoading()
        API.sharedInstance.startSession(session: PaymentezSDK.shared.session!, callback: { [weak self] (token) in
            guard let self = self else { return }
            PaymentezSDK.shared.token = token
            self.getStores()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.goBackToHostApp()
        })
    }
    
    func getStores() {
        API.sharedInstance.getStores(callback: { [weak self] (stores) in
            guard let self = self else { return }
            self.dismissPmzLoading()
            self.stores = stores
            self.doFilter("")
            self.tableView.reloadData()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.goBackToHostApp()
        })
    }
}
