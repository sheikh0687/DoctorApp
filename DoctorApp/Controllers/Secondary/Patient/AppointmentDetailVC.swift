//
//  AppointmentDetailVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit
import Foundation
import FSCalendar
import Gallery

class AppointmentDetailVC: UIViewController {
    
    @IBOutlet weak var profile_Img: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_CountryBloodType: UILabel!
    @IBOutlet weak var btn_RatingOt: UIButton!
    @IBOutlet weak var lbl_TimeSlot: UILabel!
    @IBOutlet weak var txt_AdditionalInfo: UITextView!
    @IBOutlet weak var btn_OnlineOt: UIButton!
    @IBOutlet weak var btn_CashOt: UIButton!
    
    @IBOutlet var collec_Photo: UICollectionView!
    @IBOutlet weak var timeSlot_Collection: UICollectionView!
    @IBOutlet weak var timeSlot_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calenderHeight: NSLayoutConstraint!
    @IBOutlet weak var hide_Vw: UIView!
    
    var resProviderDetail: Res_ProviderDetails?
    
    var provider_Id:String = ""
    var consultant_Fee:String = ""
    
    var array_TimeSlot: [Res_TimeSlot] = []
    var array_Images: [UIImage] = []
    
    var str_TimeSlot:String = ""
    var str_Date:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeSlot_Collection.register(UINib(nibName: "TimeSlotCell", bundle: nil),forCellWithReuseIdentifier: "TimeSlotCell")
        time_Slot(currentDay: Utility.getCurrentDay(), currentDate: Utility.getCurrentDate())
        self.calendar.select(Date())
        self.calendar.scope = .week
        btn_OnlineOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
        btn_CashOt.setImage(R.image.ic_Circle_Black(), for: .normal)
        self.txt_AdditionalInfo.addHint("Type here")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Appointment Details", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
        providerDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_AddReports(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func btn_PaymentMethod(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btn_OnlineOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
            btn_CashOt.setImage(R.image.ic_Circle_Black(), for: .normal)
        } else {
            btn_CashOt.setImage(R.image.ic_CheckedCircle_Black(), for: .normal)
            btn_OnlineOt.setImage(R.image.ic_Circle_Black(), for: .normal)
        }
    }
    
    @IBAction func btn_TappedImg(_ sender: UIButton) {
        Config.Camera.recordLocation = true
        Config.Camera.imageLimit = 3
        Config.tabsToShow = [.imageTab, .cameraTab]
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    @IBAction func btn_Submit(_ sender: UIButton) {
        if isValidInputs() {
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "FatoorahPaymentVC") as! FatoorahPaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
//            booking()
        }
    }
    
    func isValidInputs() -> Bool {
        var isValid: Bool = true
        var errorMessage:String = ""
        
        if str_TimeSlot.count == 0 {
            isValid = false
            errorMessage = "Please select the time slot"
        }
        
        if (isValid == false) {
            self.alert(alertmessage: errorMessage)
        }
        return isValid
        
//        else if array_Images.count == 0 {
//            isValid = false
//            errorMessage = "Please upload the report"
//        }
    }
}

extension AppointmentDetailVC {
    
    func providerDetail()
    {
        if let obj = resProviderDetail {
            self.lbl_Name.text = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            self.lbl_CountryBloodType.text = "\(obj.country_name ?? "")\n\(obj.sub_cat_name ?? "") | \(obj.university_name ?? "")"
            self.lbl_TimeSlot.text = "\(obj.open_time ?? "") - \(obj.close_time ?? "")"
//            self.user_iD =
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.profile_Img)
            } else {
                self.profile_Img.image = R.image.placeholder()
            }
        } else {
            print("There is no data!")
        }
    }
    
    func time_Slot(currentDay: String,currentDate: String)
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["provider_id"] = provider_Id as AnyObject
        paramDict["now_current_day"] = currentDay as AnyObject
        paramDict["current_date"] = currentDate as AnyObject
        
        print(paramDict)
        
        Api.shared.time_Slot(self, paramDict) { responseData in
            self.array_TimeSlot = responseData
            print(responseData.count)
            let numberOfItemsInRow = 3 // You can adjust this based on your layout
            let numberOfRows = (responseData.count + numberOfItemsInRow - 1) / numberOfItemsInRow
            let cellHeight: CGFloat = 30
            self.timeSlot_HeightConstraint.constant = CGFloat(numberOfRows) * cellHeight
            self.hide_Vw.isHidden = responseData.isEmpty
            self.timeSlot_Collection.reloadData()
        }
    }
    
    func booking()
    {
        var paramDict: [String : String] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["provider_id"] = provider_Id
        paramDict["total_amount"] = consultant_Fee
        paramDict["date"] = str_Date
        paramDict["time"] = str_TimeSlot
        paramDict["description"] = txt_AdditionalInfo.text
        paramDict["timezone"] = localTimeZoneIdentifier
        paramDict["payment_type"] = "Online"
        paramDict["admin_commission"] = k.emptyString
        paramDict["provider_amount"] = k.emptyString
        
        print(paramDict)
        
        func imageParam() -> [String : Array<Any>]
        {
            var imageDict: [String : Array<Any>] = [:]
            imageDict["request_images[]"]        = self.array_Images
            return imageDict
        }
        
        print(paramDict)
        
        Api.shared.add_Booking(self, paramDict, imageParam()) { responseData in
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "FatoorahPaymentVC") as! FatoorahPaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AppointmentDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeSlot_Collection {
            return array_TimeSlot.count
        } else {
            return array_Images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeSlot_Collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
            
            let obj = self.array_TimeSlot[indexPath.row]
            cell.lbl_Time.text = obj.time_slot ?? ""
            if obj.time_slot_status == "No" {
                cell.cornerRadius1 = 10
                cell.borderWidth1 = 1
                cell.borderColor1 = R.color.button()
                cell.backgroundColor = .clear
            } else {
                cell.backgroundColor = .clear
                cell.cornerRadius1 = 10
                cell.borderWidth1 = 0.5
                cell.borderColor1 = .separator
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
            cell.btn_Image.setImage(array_Images[indexPath.row], for: .normal)
            
            cell.btn_cross.isHidden = false
            cell.btn_cross.tag = indexPath.row
            cell.btn_cross.addTarget(self, action: #selector(click_On_Cross(button:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timeSlot_Collection {
            let collectionWidth = collectionView.bounds.width
            return CGSize(width: collectionWidth/3 - 5, height: 30)
        } else {
            return CGSize.init(width: 100, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeSlotCell
        let obj = array_TimeSlot[indexPath.item]
        
        if obj.time_slot_status == "No" {
            self.alert(alertmessage: "This time slot has been already booked by someone")
        } else {
            cell.backgroundColor = R.color.button()
            self.str_TimeSlot = obj.time_slot ?? ""
            print(self.str_TimeSlot)
        }
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPathOth in indexPaths {
            if indexPathOth.item != indexPath.item && indexPathOth.section == indexPath.section {
                if let cell1 = collectionView.cellForItem(at: indexPathOth) as? TimeSlotCell {
                    cell1.backgroundColor = .clear
                }
            }
        }
    }
    
    @objc func click_On_Cross(button:UIButton)  {
        array_Images.remove(at: button.tag)
        self.collec_Photo.reloadData()
    }
}

extension AppointmentDetailVC: FSCalendarDataSource, FSCalendarDelegate {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.str_Date = dateFormatter.string(from: date)
        var str_Day: String?
        
        if str_Date.isEmpty {
            let currentDate = Date()
            str_Date = dateFormatter.string(from: currentDate)
            str_Day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: currentDate) - 1]
        } else {
            str_Day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        }
        
        self.time_Slot(currentDay: str_Day ?? "", currentDate: str_Date)
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {}
}

extension AppointmentDetailVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            print(resolvedImages.compactMap({ $0 }))
            self!.array_Images = resolvedImages.compactMap({ $0 })
            self!.collec_Photo.reloadData()
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print(video)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print([Image].self)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        self.dismiss(animated: true, completion: nil)
    }
}
