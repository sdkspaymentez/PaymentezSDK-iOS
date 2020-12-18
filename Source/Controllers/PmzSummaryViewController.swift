import Foundation

class PmzSummaryViewController: PaymentezViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let PMZ_SUMMARY_VC = "PmzSummaryVC"
       
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIView!
   
    var fromPayment: Bool = false
    
    var store: PmzStore?
    var order: PmzOrder?
   
    init() {
        super.init(nibName: PmzSummaryViewController.PMZ_SUMMARY_VC, bundle: PaymentezSDK.shared.getBundle())
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        store = order?.store
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.finishFlow)))
        setTableView()
    }
   
    func setTableView() {
        tableView.register(UINib(nibName: "CartItemCellView", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "CartItemCellView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 404
  
        let headerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("SummaryHeaderView", owner: self, options: nil)!.first as! SummaryHeaderView
        headerView.configure(store: store)
        tableView.tableHeaderView = headerView
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
 
        let footerView = PaymentezSDK.shared.getBundle()?.loadNibNamed("SummaryFooterView", owner: self, options: nil)!.first as! SummaryFooterView
        footerView.initialize()
        footerView.setPrice(price: calculatePrice())
        tableView.tableFooterView = footerView
        footerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        footerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        footerView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = order?.items {
            return items.count
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCellView") as! CartItemCellView
        if let item = order?.items?[indexPath.row] {
            cell.configure(item: item)
        }
        //cell.delegate = self
        return cell
    }
   
    @objc func finishFlow() {
        if fromPayment {
            PaymentezSDK.shared.onPaymentCheckingFinished(order: order!)
        } else {
            PaymentezSDK.shared.onSearchFinished(order: order!)
        }
    }
   
    @IBAction func backDidPressed(_ sender: Any) {
        PaymentezSDK.shared.onSearchCancelled()
    }
}
