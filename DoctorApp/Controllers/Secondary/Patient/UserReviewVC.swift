//
//  UserReviewVC.swift
//  DoctorApp
//
//  Created by Techimmense Software Solutions on 20/06/24.
//

import UIKit

class UserReviewVC: UIViewController {

    @IBOutlet weak var review_TableVw: UITableView!
    
    var arrayOfRatingReview: [Res_RatingReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        review_TableVw.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Reviews & Ratings", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "#ffffff", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension UserReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayOfRatingReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        let obj = self.arrayOfRatingReview[indexPath.row]
        let userName = "\(obj.form_details?.first_name ?? "") \(obj.form_details?.last_name ?? "")"
        cell.lbl_UserName.text = userName
        cell.lbl_DateTime.text = obj.date_time ?? ""
        cell.lbl_RatingCount.text = obj.rating ?? ""
        cell.ratingStar.rating = Double(obj.rating ?? "") ?? 0.0
        cell.lbl_Feedback.text = obj.feedback ?? ""
        
        if let userImg = obj.form_details?.image {
            if Router.BASE_IMAGE_URL != userImg {
                Utility.setImageWithSDWebImage(userImg, cell.user_Img)
            } else {
                cell.user_Img.image = R.image.placeholder_Blank()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

