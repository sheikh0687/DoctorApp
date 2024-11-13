//
//  FatoorahPayment.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 11/11/24.
//

import Foundation
import MFSDK

extension FatoorahPaymentVC {
    
    func executeDirectPayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        let card = getCardInfo()
        startLoading()
        MFPaymentRequest.shared.executeDirectPayment(request: request, cardInfo: card, apiLanguage: .english) { [weak self] (response, invoiceId) in
            self?.stopLoading()
            switch response {
            case .success(let directPaymentResponse):
                if let cardInfoResponse = directPaymentResponse.cardInfoResponse, let card = cardInfoResponse.cardInfo {
                    //                    self?.resultTextView.text = "Status: with card number: \(card.number ?? "")"
                }
                if let invoiceId = invoiceId {
                    //                    self?.errorCodeLabel.text = "Success with invoice id \(invoiceId)"
                } else {
                    //                    self?.errorCodeLabel.text = "Success"
                }
            case .failure(let failError):
                //                self?.resultTextView.text = "Error: \(failError.errorDescription)"
                if let invoiceId = invoiceId {
                    //                    self?.errorCodeLabel.text = "Fail: \(failError.statusCode) with invoice id \(invoiceId)"
                } else {
                    //                    self?.errorCodeLabel.text = "Fail: \(failError.statusCode)"
                }
            }
        }
    }
    
    func executeApplePayPayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        startLoading()
        if #available(iOS 13.0, *) {
            MFPaymentRequest.shared.executeApplePayPayment(request: request, apiLanguage: .english) { [weak self] (response, invoiceId) in
                self?.stopLoading()
                switch response {
                case .success(let executePaymentResponse):
                    if let invoiceStatus = executePaymentResponse.invoiceStatus {
                        self?.showSuccess(invoiceStatus)
                    }
                case .failure(let failError):
                    self?.showFailError(failError)
                    print(failError)
                }
            }
        } else {
            // Fallback on earlier versions
            //            _ = "com.myFatoorah.MFSDKDemo"
            MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] response, invoiceId  in
                self?.stopLoading()
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
    }
    
    func initiatePayment() {
        let request = generateInitiatePaymentModel()
        startLoading()
        MFPaymentRequest.shared.initiatePayment(request: request, apiLanguage: .english, completion: { [weak self] (result) in
            self?.stopLoading()
            switch result {
            case .success(let initiatePaymentResponse):
                self?.paymentMethods = initiatePaymentResponse.paymentMethods
                self?.collectionView.reloadData()
            case .failure(let failError):
                self?.showFailError(failError)
            }
        })
    }
    
    func executePayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        startLoading()
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] response, invoiceId  in
            self?.stopLoading()
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
    
    func sendPayment() {
        let request = getSendPaymentRequest()
        startSendPaymentLoading()
        MFPaymentRequest.shared.sendPayment(request: request, apiLanguage: .english) { [weak self] (result) in
            self?.stopSendPaymentLoading()
            switch result {
            case .success(let sendPaymentResponse):
                if let invoiceURL = sendPaymentResponse.invoiceURL {
                    //                    self?.errorCodeLabel.text = "Success"
                    //                    self?.resultTextView.text = "result: send this link to your customers \(invoiceURL)"
                }
            case .failure(let failError):
                self?.showFailError(failError)
            }
            
        }
    }
}

extension FatoorahPaymentVC {
    private func generateInitiatePaymentModel() -> MFInitiatePaymentRequest {
        // you can create initiate payment request with invoice value and currency
        // let invoiceValue = Double(amountTextField.text ?? "") ?? 0
        // let request = MFInitiatePaymentRequest(invoiceAmount: invoiceValue, currencyIso: .kuwait_KWD)
        // return request
        
        let request = MFInitiatePaymentRequest()
        return request
    }
    private func getCardInfo() -> MFCardInfo {
        let cardNumber = cardNumberTextField.text ?? ""
        let cardExpiryMonth = monthTextField.text ?? ""
        let cardExpiryYear = yearTextField.text ?? ""
        let cardSecureCode = secureCodeTextField.text ?? ""
        let cardHolderName = cardHolderNameTextField.text ?? ""
        
        
        let card = MFCardInfo(cardNumber: cardNumber, cardExpiryMonth: cardExpiryMonth, cardExpiryYear: cardExpiryYear, cardHolderName: cardHolderName, cardSecurityCode: cardSecureCode, saveToken: false)
        //        card.bypass = false // default is true
        return card
    }
    private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
        let invoiceValue = Decimal(string: amountTextField.text ?? "0") ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue , paymentMethod: paymentMethodId)
        //request.userDefinedField = ""
        request.customerEmail = "test@myfatoorah.com"// must be email
        request.customerMobile = "112233"
        request.customerCivilId = "1234567890"
        request.customerName = "Test MyFatoorah"
        let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
        request.customerAddress = address
        request.customerReference = "Test MyFatoorah Reference"
        request.language = .english
        request.mobileCountryCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.displayCurrencyIso = .kuwait_KWD
        //        request.recurringModel = MFRecurringModel(recurringType: .weekly, iteration: 2)
        //        request.supplierValue = 1
        //        request.supplierCode = 2
        //        request.suppliers.append(MFSupplier(supplierCode: 1, proposedShare: 2, invoiceShare: invoiceValue))
        
        // Uncomment this to add products for your invoice
        //         var productList = [MFProduct]()
        //        let product = MFProduct(name: "ABC", unitPrice: 1.887, quantity: 1)
        //         productList.append(product)
        //         request.invoiceItems = productList
        return request
    }
    
    func getSendPaymentRequest() -> MFSendPaymentRequest {
        let invoiceValue = Decimal(string: amountTextField.text ?? "") ?? 0
        let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .link, customerName: "Test")
        
        // send invoice link as sms to specified number
        // let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .sms, customerName: "Test")
        // request.customerMobile  = "" // required here
        
        // get invoice link
        // let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .link, customerName: "Test")
        
        //  send invoice link to email
        // let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .email, customerName: "Test")
        // request.customerEmail = "" required here
        
        
        
        //request.userDefinedField = ""
        request.customerEmail = "a@b.com"// must be email
        request.customerMobile = "mobile no"//Required
        request.customerCivilId = ""
        request.mobileCountryIsoCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.customerReference = ""
        request.language = .english
        let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
        request.customerAddress = address
        request.language = .english
        request.displayCurrencyIso = .kuwait_KWD
        let date = Date().addingTimeInterval(1000)
        request.expiryDate = date
        return request
    }
}

// MARK: - Recurring Payment
extension FatoorahPaymentVC {
    
    func executeRecurringPayment(paymentMethodId: Int) {
        let request = MFExecutePaymentRequest(invoiceValue: 5.000 , paymentMethod: paymentMethodId)
        let card = getCardInfo()
        MFPaymentRequest.shared.executeRecurringPayment(request: request, cardInfo: card, recurringType: .custom(intervalDays: 10), iteration: 2, apiLanguage: .english) { (response, invoiceId) in
            switch response {
            case .success(let directPaymentResponse):
                if let cardInfoResponse = directPaymentResponse.cardInfoResponse, let card = cardInfoResponse.cardInfo {
                    print("Status: with card number: \(card.number ?? "")")
                    print("Status: with recurring Id: \(cardInfoResponse.recurringId ?? "")")
                }
                if let invoiceId = invoiceId {
                    print("Success with invoice id \(invoiceId)")
                } else {
                    print("Success")
                }
            case .failure(let failError):
                print("Error: \(failError.errorDescription)")
                if let invoiceId = invoiceId {
                    print("Fail: \(failError.statusCode) with invoice id \(invoiceId)")
                } else {
                    print("Fail: \(failError.statusCode)")
                }
            }
        }
    }
    
    func executeRecurringPayment(recurringId: String) {
        MFPaymentRequest.shared.cancelRecurringPayment(recurringId: recurringId, apiLanguage: .english) { [weak self] (result) in
            switch result {
            case .success(let isCanceled):
                if isCanceled {
                    print("Success")
                }
                
            case .failure(let failError):
                self?.showFailError(failError)
            }
        }
    }
    
}

