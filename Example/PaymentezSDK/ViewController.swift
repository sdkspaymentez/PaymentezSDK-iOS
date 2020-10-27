import UIKit
import PaymentezSDK

class ViewController: UIViewController, PmzSearchCallback, PmzPayAndPlaceCallback, PmzGetStoresCallback, UITextFieldDelegate {
    
    @IBOutlet var backgroundColorInput: UITextField!
    @IBOutlet var textColorInput: UITextField!
    @IBOutlet var buttonColorInput: UITextField!
    @IBOutlet var buttonTextColorInput: UITextField!
    
    @IBOutlet var backgroundColorShower: UIView!
    @IBOutlet var textColorShower: UIView!
    @IBOutlet var buttonColorShower: UIView!
    @IBOutlet var buttonTextColorShower: UIView!
    
    @IBOutlet var searchButton: UIView!
    @IBOutlet var searchWithStoreIdButton: UIView!
    @IBOutlet var showSummaryButton: UIView!
    @IBOutlet var finishPurchaseButton: UIView!
    @IBOutlet var finishWithoutSummaryButton: UIView!
    @IBOutlet var getStoresButton: UIView!
    
    @IBOutlet var randomizeButton: UIView!
    
    var lastSelectedTextField: UITextField?
    
    var backgroundColorSelected: Color?
    var textColorSelected: Color?
    var buttonColorSelected: Color?
    var buttonTextColorSelected: Color?
    
    var colors: [Color]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.isNavigationBarHidden = true
        colors = Color.getColors()
        setDelegates()
        self.view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.dismissKeyboard)))
        
        searchButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSearch)))
        searchWithStoreIdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSearchWithId)))
        showSummaryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showSummary)))
        finishPurchaseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPaymentChecking)))
        finishWithoutSummaryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPaymentWOSummaryChecking)))
        getStoresButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getStores)))
        
        randomizeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.randomizeColors)))
        randomizeColors()
    }
    
    @objc func randomizeColors() {
        didPickBackgroundColor(colors![getRandom()])
        didPickTextColor(colors![getRandom()])
        didPickButtonColor(colors![getRandom()])
        didPickButtonTextColor(colors![getRandom()])
    }
    
    func getRandom() -> Int {
        return Int(arc4random_uniform(UInt32(colors!.count)))
    }
    
    func setDelegates() {
        backgroundColorInput.delegate = self
        textColorInput.delegate = self
        buttonColorInput.delegate = self
        buttonTextColorInput.delegate = self
    }
    
    @objc func goToSearch() {
        let style = PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
                .setTextColor(textColorSelected!.color!)
                .setButtonBackgroundColor(buttonColorSelected!.color!)
                .setButtonTextColor(buttonTextColorSelected!.color!)
        
        PaymentezSDK.shared
                .setStyle(style: style)
                .startSearch(navigationController: navigationController!, buyer: getBuyer(), appOrderReference: "appOrderReference", callback: self)
    }
    
    @objc func goToSearchWithId() {
        let style = PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
                .setTextColor(textColorSelected!.color!)
                .setButtonBackgroundColor(buttonColorSelected!.color!)
                .setButtonTextColor(buttonTextColorSelected!.color!)
        
        PaymentezSDK.shared
                .setStyle(style: style)
                .startSearch(navigationController: navigationController!, buyer: getBuyer(), appOrderReference: "appOrderReference", storeId: 120, callback: self)
    }
    
    @objc func showSummary() {
        let style = PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
                .setTextColor(textColorSelected!.color!)
                .setButtonBackgroundColor(buttonColorSelected!.color!)
                .setButtonTextColor(buttonTextColorSelected!.color!)
        
        PaymentezSDK.shared
                .setStyle(style: style)
                .showSummary(navigationController: navigationController!, appOrderReference: "appOrderReference", order: PmzOrder.hardcoded(), callback: self)
    }
    
    @objc func goToPaymentChecking() {
        let style = PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
                .setTextColor(textColorSelected!.color!)
                .setButtonBackgroundColor(buttonColorSelected!.color!)
                .setButtonTextColor(buttonTextColorSelected!.color!)
        
        PaymentezSDK.shared
                .setStyle(style: style)
                .startPayAndPlace(navigationController: navigationController!, order: PmzOrder.hardcoded(), paymentData: getPaymentData(), callback: self)
    }
    
    @objc func goToPaymentWOSummaryChecking() {
        let style = PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
                .setTextColor(textColorSelected!.color!)
                .setButtonBackgroundColor(buttonColorSelected!.color!)
                .setButtonTextColor(buttonTextColorSelected!.color!)
        
        PaymentezSDK.shared
                .setStyle(style: style)
                .startPayAndPlace(navigationController: navigationController!, order: PmzOrder.hardcoded(), paymentData: getPaymentData(), skipSummary: true, callback: self)
    }
    
    @objc func getStores() {
        PaymentezSDK.shared.getStores(callback: self)
    }
    
    func getBuyer() -> PmzBuyer {
        return PmzBuyer()
                .setName("Buyer Test")
                .setEmail("buyer@test.com.ar")
                .setPhone("01112345678")
                .setFiscalNumber("fiscalNumber")
                .setUserReference("userReference")
    }
    
    func getPaymentData() -> PmzPaymentData {
        return PmzPaymentData()
                .setPaymentMethodReference("paymentMethodReference")
                .setPaymentReference("paymentReference")
                .setAmount(20000)
                .setService(200)
    }
    
    func searchFinishedSuccessfully(order: PmzOrder) {
        showToast(controller: self, message: "Flujo terminado exitosamente.", seconds: 1)
    }
    
    func searchCancelled() {
        showToast(controller: self, message: "Flujo cancelado.", seconds: 1)
    }
    
    func payAndPlaceFinishedSuccessfully(order: PmzOrder) {
        showToast(controller: self, message: "Flujo terminado exitosamente.", seconds: 1)
    }
    
    func payAndPlaceOnError(order: PmzOrder, error: PmzError) {
        if let error = error.type {
            switch error {
            case PmzError.PAYMENT_ERROR_KEY:
                showToast(controller: self, message: "Ocurrió un error con el Pago de la orden", seconds: 2)
            case PmzError.PLACE_ERROR_KEY:
                showToast(controller: self, message: "Ocurrió un error con el Place de la orden", seconds: 2)
            default:
                showToast(controller: self, message: "Ocurrió un error inesperado", seconds: 2)
            }
        }
    }
    
    func gotStores(stores: [PmzStore]) {
        showToast(controller: self, message: "Se obtuvieron los comercios", seconds: 1)
    }
    
    func gettingStoresFailed() {
        showToast(controller: self, message: "Se produjo un error obteniendo los comercios", seconds: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        lastSelectedTextField = textField
        if(textField == backgroundColorInput) {
            textField.tintColor = UIColor.clear
            showBackgroundColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        if(textField == textColorInput) {
            textField.tintColor = UIColor.clear
            showTextColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        if(textField == buttonColorInput) {
            textField.tintColor = UIColor.clear
            showButtonColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        if(textField == buttonTextColorInput) {
            textField.tintColor = UIColor.clear
            showButtonTextColorPicker()
            textField.resignFirstResponder()
            view.endEditing(true)
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        lastSelectedTextField?.resignFirstResponder()
    }
    
    func showBackgroundColorPicker() {
        showPicker(title: "Seleccione el color del Fondo", items: colors!, completion: { colorSelected in
            self.didPickBackgroundColor(colorSelected)
        })
    }
    
    func showTextColorPicker() {
        showPicker(title: "Seleccione el color del Texto", items: colors!, completion: { colorSelected in
            self.didPickTextColor(colorSelected)
        })
    }
    
    func showButtonColorPicker() {
        showPicker(title: "Seleccione el color del Botón", items: colors!, completion: { colorSelected in
            self.didPickButtonColor(colorSelected)
        })
    }
    
    func showButtonTextColorPicker() {
        showPicker(title: "Seleccione el color del Texto del Botón", items: colors!, completion: { colorSelected in
            self.didPickButtonTextColor(colorSelected)
        })
    }
    
    func didPickBackgroundColor(_ color: Color) {
        self.backgroundColorSelected = color
        self.backgroundColorInput.text = self.backgroundColorSelected!.name!
        self.backgroundColorShower.backgroundColor = self.backgroundColorSelected!.color!
    }
    
    func didPickTextColor(_ color: Color) {
        self.textColorSelected = color
        self.textColorInput.text = self.textColorSelected!.name!
        self.textColorShower.backgroundColor = self.textColorSelected!.color!
    }
    
    func didPickButtonColor(_ color: Color) {
        self.buttonColorSelected = color
        self.buttonColorInput.text = self.buttonColorSelected!.name!
        self.buttonColorShower.backgroundColor = self.buttonColorSelected!.color!
    }
    
    func didPickButtonTextColor(_ color: Color) {
        self.buttonTextColorSelected = color
        self.buttonTextColorInput.text = self.buttonTextColorSelected!.name!
        self.buttonTextColorShower.backgroundColor = self.buttonTextColorSelected!.color!
    }
    
    func showPicker(title: String, items: [Color], completion: @escaping (Color)->()) {
        let sexAlertController = UIAlertController(title: title,
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        for i in (0 ... items.count - 1) {
            let item = items[i]
            sexAlertController.addAction(UIAlertAction(title: item.name,
                                                       style: .default,
                                                       handler: { alert in
                                                completion(item)
            }))
        }
        
        sexAlertController.addAction(UIAlertAction(title: "Cancelar",
                                                   style: .cancel,
                                                   handler: nil))
        self.present(sexAlertController, animated: true, completion: nil)
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}

