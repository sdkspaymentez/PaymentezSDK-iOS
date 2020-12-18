//
//  PmzMenuFragmentVC.swift
//  Alamofire
//
//  Created by Fennoma on 03/12/2020.
//

import Foundation
import XLPagerTabStrip

protocol PmzMenuFragmentDelegate {
    func itemSelected(_ product: PmzProduct)
    func getFilter() -> String
}

class PmzMenuFragmentVC: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, ProductItemDelegate {
    
    static let PMZ_MENU_FRAGMENT = "PmzMenuFragmentVC"
    
    @IBOutlet var tableView: UITableView!
    
    var filter: String = ""
    
    var category: PmzCategory?
    var filteredProducts: [PmzProduct]?
    var delegate: PmzMenuFragmentDelegate?
    
    init() {
        super.init(nibName: PmzMenuFragmentVC.PMZ_MENU_FRAGMENT, bundle: PaymentezSDK.shared.getBundle())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = delegate {
            filter = delegate.getFilter()
            refreshFilter(filter)
        }
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshFilter(_ filter: String) {
        self.filter = filter
        doFilter(filter)
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func doFilter(_ filter: String) {
        filteredProducts = [PmzProduct]()
        if let originalProducts = category?.products {
            for product in originalProducts {
                if let productName = product.name {
                    let loweredName = productName.lowercased()
                    if filter == "" || loweredName.contains(filter.lowercased()) {
                        filteredProducts?.append(product)
                    }
                }
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        doFilter("")
        tableView.register(UINib(nibName: "ProductCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "ProductCellView")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellView") as! ProductCellView
        cell.configure(product: filteredProducts![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func itemSelected(_ product: PmzProduct) {
        delegate?.itemSelected(product)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let title = self.category?.name {
            return IndicatorInfo(title: title)
        } else {
            return IndicatorInfo(title: " ")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let amount = filteredProducts?.count {
            return amount
        } else {
           return 0
        }
    }
    
}
