//
//  PaymentGatewayCollection.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 11/11/24.
//

import Foundation

extension FatoorahPaymentVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let paymentMethods = paymentMethods else {
            return 0
        }
        return paymentMethods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PaymentMethodCollectionViewCell
        if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
            let selectedIndex = selectedPaymentMethodIndex ?? -1
            cell.configure(paymentMethod: paymentMethods[indexPath.row], selected: selectedIndex == indexPath.row)
        }
        return cell
    }
    
}

extension FatoorahPaymentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentMethodIndex = indexPath.row
        payButton.isEnabled = true
        
        if let paymentMethods = paymentMethods {
            if paymentMethods[indexPath.row].isDirectPayment {
                hideCardInfoStacksView(isHidden: false)
            } else {
                hideCardInfoStacksView(isHidden: true)
            }
        }
        collectionView.reloadData()
    }
}
