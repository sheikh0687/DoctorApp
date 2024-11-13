//
//  PresentTimeScheduleVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 23/07/24.
//

import UIKit

class PresentTimeScheduleVC: UIViewController {

    @IBOutlet weak var collection_Vw: UICollectionView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    var arrTimeSlot =
    [
        "01:00","02:00","03:00","04:00",
        "05:00","06:00","07:00","08:00",
        "09:00","10:00","11:00","12:00",
        "13:00","14:00","15:00","16:00",
        "17:00","18:00","19:00","20:00",
        "21:00","22:00","23:00","00:00"
    ]
    
    var cloTimeSlot:((_ time: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection_Vw.register(UINib(nibName: "ProviderTimeCell", bundle: nil),forCellWithReuseIdentifier: "ProviderTimeCell")
    }
}

extension PresentTimeScheduleVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrTimeSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderTimeCell", for: indexPath) as! ProviderTimeCell
        cell.lbl_Time.text = self.arrTimeSlot[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.cloTimeSlot?(self.arrTimeSlot[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collection_Vw.frame.width / 4, height: 30)
    }
}
