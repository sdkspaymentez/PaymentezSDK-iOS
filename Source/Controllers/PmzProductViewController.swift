import Foundation

protocol PmzProductVCDelegate {
    func onItemAddedToOrder(order: PmzOrder)
}

class PmzProductViewController: PaymentezViewController, UITableViewDelegate, UITableViewDataSource, ProductConfigurationItemDelegate, ProductFooterDelegate {
    
    public static let TITLE_INDEX = 0
    public static let ITEM_INDEX = 1
    static let PMZ_PRODUCT_VC = "PmzProductVC"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIView!
    var footerView: ProductFooterView?
    
    var organizer: PmzProductOrganizer
    var product: PmzProduct?
    var orderId: CLong?
    var order: PmzOrder?
    var item: PmzItem?
    
    var delegate: PmzProductVCDelegate?
    
    init() {
        self.organizer = PmzProductOrganizer()
        super.init(nibName: PmzProductViewController.PMZ_PRODUCT_VC, bundle: PaymentezSDK.shared.getBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToFourthPage)))
        
        organizer.setProduct(product: product)
        setTableView()
        item = PmzItem(product: product!, orderId: orderId!)
    }
    
    func onQuantityChanged(quantity: Int) {
        item?.quantity = quantity
    }
    
    func setTableView() {
        tableView.register(UINib(nibName: "TitleCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "TitleCellView")
        tableView.register(UINib(nibName: "ProductConfigurationItemCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "ProductConfigurationItemCellView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("ProductHeaderView", owner: self, options: nil)!.first as! ProductHeaderView
        headerView.configure(product: product)
        tableView.tableHeaderView = headerView
        // 3.
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        // 4.
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        
        footerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("ProductFooterView", owner: self, options: nil)!.first as? ProductFooterView
        footerView?.initialize()
        footerView?.delegate = self
        if let price = product?.currentPrice {
            footerView!.setCurrentPrice(price: price)
        }
        tableView.tableFooterView = footerView
        footerView!.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        footerView!.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        footerView!.topAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        // 4.
        self.tableView.tableFooterView?.layoutIfNeeded()
        self.tableView.tableFooterView = self.tableView.tableFooterView
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizer.size()
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = organizer.getItem(position: indexPath.row)
        if let type = item?.getType(), type == PmzProductViewController.ITEM_INDEX {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductConfigurationItemCellView") as! ProductConfigurationItemCellView
            cell.configure(item: item as! PmzProductConfiguration, position: indexPath.row)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCellView") as! TitleCellView
            if item != nil {
                cell.configure(title: item as! PmzTitleItem)
            }
            return cell
        }
    }
    
    func onItemSelected(product: PmzProductConfiguration, cell: ProductConfigurationItemCellView, position: Int) {
        if product.checked {
            if(organizer.canUnselect(position: position)) {
                product.checked = !product.checked
                cell.setPropperImage(product.checked)
                organizer.addSelection(config: product, position: position)
                let itemsToRefresh = organizer.onItemClicked(position: position)
                refreshItems(ids: itemsToRefresh)
            }
        } else {
            product.checked = !product.checked
            cell.setPropperImage(product.checked)
            organizer.addSelection(config: product, position: position)
            let itemsToRefresh = organizer.onItemClicked(position: position)
            refreshItems(ids: itemsToRefresh)
        }
        measurePrice()
    }
    
    func measurePrice() {
        if let price = product?.currentPrice, let footer = footerView {
            footer.setCurrentPrice(price: price + organizer.measureExtras())
        }
    }
    
    func refreshItems(ids: [Int]) {
        var indexes = [IndexPath]()
        for id in ids {
            let index = IndexPath(row: id, section: 0)
            indexes.append(index)
        }
        if indexes.count > 0 {
            tableView.reloadRows(at: indexes, with: .automatic)
        }
    }
    
    @objc func goToFourthPage() {
        showLoading()
        item!.setConfigurations(organizer: organizer)
        API.sharedInstance.addItemWithConfigurations(item: item!, callback: { [weak self] (order) in
            guard let self = self else { return }
            self.sendOrderBack(self.mergeData(order))
            self.dismissPmzLoading()
            }, failure: { [weak self] (error) in
                guard let self = self else { return }
                self.dismissPmzLoading()
                self.showGenericError()
        })
    }
    
    func sendOrderBack(_ order: PmzOrder) {
        delegate?.onItemAddedToOrder(order: order)
        backDidPressed(self)
    }
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mergeData(_ response: PmzOrder) -> PmzOrder {
        if let items = response.items {
            for item in items {
                if let newProductId = item.productId, let productId = product?.id, productId == newProductId {
                    item.imageUrl = product?.imageUrl
                }
            }
            if let oldItems = order?.items {
                for oldItem in oldItems {
                    for newItem in items {
                        if let newProductId = newItem.id, let oldProductId = oldItem.id, newProductId == oldProductId {
                            newItem.imageUrl = oldItem.imageUrl
                        }
                    }
                }
            }
        }
        return response
    }
}
