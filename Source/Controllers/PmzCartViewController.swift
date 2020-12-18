//
//  PmzCartViewController.swift
//  Alamofire
//
//  Created by Fennoma on 16/12/2020.
//

import Foundation

class PmzCartViewController: PaymentezViewController, UITableViewDelegate, UITableViewDataSource, CartHeaderDelegate {
    
    static let PMZ_CART_VC = "PmzCartVC"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIView!
    var footerView: CartFooterView?
    
    var store: PmzStore?
    var order: PmzOrder?
    
    var orderModified: Bool = false
    
    init() {
        super.init(nibName: PmzCartViewController.PMZ_CART_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.finishFlow)))
        setTableView()
    }
    
    func setTableView() {
        tableView.register(UINib(nibName: "CartItemCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "CartItemCellView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 404
        
        let headerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("CartHeaderView", owner: self, options: nil)!.first as! CartHeaderView
        headerView.configure(store: store)
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        // 3.
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        // 4.
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        
        footerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("CartFooterView", owner: self, options: nil)!.first as? CartFooterView
        footerView?.initialize()
        footerView!.setPrice(price: calculatePrice())
        tableView.tableFooterView = footerView
        // 3.
        footerView!.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        footerView!.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        footerView!.topAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        // 4.
        self.tableView.tableFooterView?.layoutIfNeeded()
        self.tableView.tableFooterView = self.tableView.tableFooterView
    }
    
    func calculatePrice() -> Double {
        var result: Double = 0
        if let items = order?.items {
            for item in items {
                var amount: Double = 1
                if let realAmount = item.quantity {
                    amount = Double(realAmount)
                }
                var priceToMultiply: Double = 0
                if let pricePerUnit = item.totalAmount {
                    priceToMultiply = pricePerUnit
                }
                result += priceToMultiply * amount
            }
        }
        return result
    }
    
    func refreshPrice() {
        footerView?.setPrice(price: calculatePrice())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = order?.items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            self.tryToRemoveItem(indexPath: indexPath)
        })

        deleteAction.image = UIImage(named: "remove_item_bin", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil)
        deleteAction.backgroundColor = UIColor(named: "remove_item_background", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tryToRemoveItem(indexPath: IndexPath) {
        var message = "¿Seguro que desea borrar el item?"
        if let productName = self.order?.items?[indexPath.row].productName {
            message = "¿Seguro que desea borrar el item \(productName)?"
        }
        let alert = UIAlertController(title: "Borrar item", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: {(alert: UIAlertAction!) in
            let itemToRemove = self.order!.items![indexPath.row]
            self.removeItem(itemToRemove)
            self.order!.items!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.refreshPrice()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alert: UIAlertAction!) in
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func removeItem(_ item: PmzItem) {
        showLoading()
        API.sharedInstance.deleteItem(item: item, callback: { [weak self] (order) in
            guard let self = self else { return }
            self.order = order.mergeData(self.order!)
            self.orderModified = true
            self.dismissPmzLoading()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.showGenericError()
        })
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            order!.items!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshPrice()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCellView") as! CartItemCellView
        if let item = order?.items?[indexPath.row] {
            cell.configure(item: item)
        }
        //cell.delegate = self
        return cell
    }
    
    @objc func finishFlow() {
        order?.store = store
        PaymentezSDK.shared.onSearchFinished(order: order!)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onKeepBuyingPressed() {
        backDidPressed(self)
    }
}
