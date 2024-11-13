//
//  FatoorahPaymentVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 11/11/24.
//

import UIKit
import MFSDK

class FatoorahPaymentVC: UIViewController {

    //MARK: Variables
    var paymentMethods: [MFPaymentMethod]?
    var selectedPaymentMethodIndex: Int?
    
    //MARK: Outlet
//    @IBOutlet weak var errorCodeLabel : UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
//    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var cardInfoStackViews: [UIStackView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var secureCodeTextField: UITextField!
    @IBOutlet weak var sendPaymentButton: UIButton!
    @IBOutlet weak var sendPaymentActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var paymentCardView: MFPaymentCardView!
    @IBOutlet weak var cardActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cardPayButton: UIButton!
    
    //at list one product Required
    let productList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        payButton.isEnabled = false
        
        setCardInfo()
        initiatePayment()
        
        // set delegate
        MFSettings.shared.delegate = self
        setUpCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Payment", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpCard()
    {
        let configure = MFCardConfigureBuilder.default
//        // but you can create yours
//        // set placeholders
        configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name", cardNumberPlaceholder: "Number", expiryDatePlaceholder: "MM / YY", cvvPlaceholder: "CVV"))
//        //set labels
        configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name", cardNumberLabel: "Card number", expiryDateLabel: "MM / YY", cvvLabel: "CVV", showLabels: true))
//        // set theme
        let theme = MFCardTheme(inputColor: .black, labelColor: .black, errorColor: .red)
    
        // to make direction rtl or ltr
        theme.language = .english
        configure.setTheme(theme)
//
//
//        // set labels and texts font size
        configure.setFontSize(15)
//
//        // set border width
        configure.setBorderWidth(1)
//
//        // set border radius for input fields
        configure.setBorderRadius(8)
        configure.setCardInput(MFCardInput(inputHeight: 32, inputMargin: 15))
        configure.setFontFamily(.arial)
        
        configure.setBoxShadow(MFBoxShadow(hOffset: 0, vOffset: 0, blur: 0, spread: 0, color: .gray))

//          create the new configure and assigned to payment card view
        paymentCardView.configure = configure.build()
        
        // initiate session
        let request = MFInitiateSessionRequest(customerIdentifier: "asd")
        MFPaymentRequest.shared.initiateSession(request: request, apiLanguage: .english) { [weak self] response in
            switch response {
            case .success(let session):
                    self?.paymentCardView.load(initiateSession: session)
            case .failure(let error):
                print("#initiate session", error.localizedDescription)
            }
        }
    }
    
    @IBAction func payDidPRessed(_ sender: Any) {
        if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
            if let selectedIndex = selectedPaymentMethodIndex {
                if paymentMethods[selectedIndex].paymentMethodCode == MFPaymentMethodCode.applePay.rawValue {
                    executeApplePayPayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                } else if paymentMethods[selectedIndex].isDirectPayment {
                    executeDirectPayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                } else {
                    executePayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                }
            } else {
                self.alert(alertmessage: "Please select the payment card")
            }
        }
    }

    // MARK: - Actions
    @IBAction func payDidTapped(_ sender: UIButton) {
        executeInAppPayment()
    }
    
    // MARK: - Methods
    fileprivate func executeInAppPayment() {
        let request = getExecuteRequestForCardPayment()
        startCardViewLoading()
        paymentCardView.pay(request, .english) { [weak self] response, invoiceId  in
            self?.stopCardViewLoading()
            switch response {
            case .success(let executePaymentResponse):
                if let invoiceStatus = executePaymentResponse.invoiceStatus {
                    self?.showSuccess(invoiceStatus)
                }
            case .failure(let failError):
                self?.showFailError(failError)
            }
        }
    }
    private func getExecuteRequestForCardPayment() -> MFExecutePaymentRequest {
        let invoiceValue = Decimal(string: amountTextField.text ?? "0") ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        //request.userDefinedField = ""
        request.customerEmail = "a@b.com"// must be email
        request.customerMobile = "66556655"
        request.customerCivilId = "12345678902222"
        let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
        request.customerAddress = address
        request.customerName = "Hosny"
        request.customerReference = "Hosny22"
        request.language = .english
        request.mobileCountryCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.displayCurrencyIso = .uAE_AED
//        request.supplierCode = 1
//        request.supplierValue = 1
//        request.suppliers.append(MFSupplier(supplierCode: 1, invoiceShare: 1))
        // Uncomment this to add products for your invoice
//         var productList = [MFProduct]()
//        let product = MFProduct(name: "ABC", unitPrice: 1.887, quantity: 1)
//         productList.append(product)
//         request.invoiceItems = productList
        return request
    }
}

extension FatoorahPaymentVC  {
    func startSendPaymentLoading() {
//        errorCodeLabel.text = "Status:"
//        resultTextView.text = "Result:"
        sendPaymentButton.setTitle("", for: .normal)
        sendPaymentActivityIndicator.startAnimating()
    }
    
    func stopSendPaymentLoading() {
        sendPaymentButton.setTitle("Send Payment", for: .normal)
        sendPaymentActivityIndicator.stopAnimating()
    }
    
    func startLoading() {
//        errorCodeLabel.text = "Status:"
//        resultTextView.text = "Result:"
        payButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        payButton.setTitle("Pay", for: .normal)
        activityIndicator.stopAnimating()
    }
    
    func showSuccess(_ message: String) {
//        errorCodeLabel.text = "Succes"
//        resultTextView.text = "result: \(message)"
    }
    
    func showFailError(_ error: MFFailResponse) {
//        errorCodeLabel.text = "responseCode: \(error.statusCode)"
//        resultTextView.text = "Error: \(error.errorDescription)"
    }
}

extension FatoorahPaymentVC {
    func hideCardInfoStacksView(isHidden: Bool) {
        for stackView in cardInfoStackViews {
            stackView.isHidden = isHidden
        }
    }
    private func setCardInfo() {
        cardNumberTextField.text = "5123450000000008"
        cardHolderNameTextField.text = "John Wick"
        monthTextField.text = "05"
        yearTextField.text = "21"
        secureCodeTextField.text = "100"
    }
}

extension FatoorahPaymentVC: MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print("#Invoice id:", invoiceId)
    }
}

extension FatoorahPaymentVC {
    func startCardViewLoading() {
        payButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
    }
    
    func stopCardViewLoading() {
        payButton.setTitle("Pay", for: .normal)
        activityIndicator.stopAnimating()
    }
}
