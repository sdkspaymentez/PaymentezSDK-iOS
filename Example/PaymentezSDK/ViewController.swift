import UIKit
import PaymentezSDK

class ViewController: UIViewController, PmzSearchCallback, PmzPayAndPlaceCallback, UITextFieldDelegate, PmzGetStoresCallback {
    
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
    @IBOutlet var summaryButton: UIView!
    @IBOutlet var getStoresButton: UIView!
    @IBOutlet var paymentButton: UIView!
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
        summaryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSummary)))
        getStoresButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getStores)))
        paymentButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPayment)))
        randomizeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.randomizeColors)))
        setLMColors()
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
        PaymentezSDK.shared
                .setStyle(style: getStyle())
                .startSearch(navigationController: navigationController!, buyer: getBuyer(), appOrderReference: "appOrderReference", callback: self)
    }
    
    @objc func goToSearchWithId() {
        PaymentezSDK.shared
                .setStyle(style: getStyle())
                .startSearch(navigationController: navigationController!, buyer: getBuyer(), appOrderReference: "appOrderReference", storeId: 105, callback: self)
    }
    
    @objc func goToSummary() {
        PaymentezSDK.shared
                .setStyle(style: getStyle())
                .showSummary(navigationController: navigationController!, order: PmzOrder.hardcoded(), callback: self)
    }
    
    @objc func goToPayment() {
        PaymentezSDK.shared
                .setStyle(style: getStyle())
                .startPayAndPlace(navigationController: navigationController!, order: PmzOrder.hardcoded(), paymentsData: PmzPaymentData.hardcodedList(), callback: self)
    }
    
    func getStyle() -> PmzStyle {
        return PmzStyle().setBackgroundColor(backgroundColorSelected!.color!)
            .setTextColor(textColorSelected!.color!)
            .setButtonBackgroundColor(buttonColorSelected!.color!)
            .setButtonTextColor(buttonTextColorSelected!.color!)
            .setFont(PmzFont.SYSTEM)
    }
    
    func getBuyer() -> PmzBuyer {
        return PmzBuyer().setName("Pepe").setPhone("123123123").setFiscalNumber("fiscalNumber")
            .setUserReference("userReference").setEmail("pepe@test.com.ar")
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
        if let error = error.errorCode {
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
    
    @objc func getStores() {
        showLoading()
        PaymentezSDK.shared.getStores(filter: nil, callback: self)
    }
    
    func getStoresOnSuccess(stores: [PmzStore]) {
        dismissLoading()
        showToast(controller: self, message: "Se obtuvieron los comercios.", seconds: 1)
    }
    
    func getStoresOnError(error: PmzError) {
        dismissLoading()
        showToast(controller: self, message: "Ha ocurrido un error obteniendo los comercios.", seconds: 1)
    }
    
    func searchFinishedWithError(error: PmzError) {
        showToast(controller: self, message: "Ha ocurrido un error con los servicios.", seconds: 1)
    }
    
    func payAndPlaceOnError(order: PmzOrder?, error: PmzError) {
        showToast(controller: self, message: "Ha ocurrido un error con los servicios.", seconds: 1)
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
    
    func setLMColors() {
        didPickBackgroundColor(Color(name: "Blanco", color: UIColor(named: "LMWhite")!))
        didPickTextColor(Color(name: "LM Negro", color: UIColor(named: "LMBlack")!))
        didPickButtonColor(Color(name: "LM Color Principal", color: UIColor(named: "LMRed")!))
        didPickButtonTextColor(Color(name: "Blanco", color: UIColor(named: "LMWhite")!))
    }
    
    @objc func randomizeColors() {
        didPickBackgroundColor(colors![getRandom()])
        didPickTextColor(colors![getRandom()])
        didPickButtonColor(colors![getRandom()])
        didPickButtonTextColor(colors![getRandom()])
    }

}

