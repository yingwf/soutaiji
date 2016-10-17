//
//  UserGeneralDetailViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

protocol UpdateUserInfoDelegate {
    func updateUserinfo(userType: Int, userinfo: AnyObject)
}

class UserGeneralDetailViewController: UIViewController, UpdateUserInfoDelegate {

    var userType:Int = 0
    var userGeneral: UserInfo?
    var userClub: ClubInfo?
    var userCoach: CoachInfo?
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var tel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        self.initUI()

    }
    
    func initUI() {
        switch userType {
        case 0:
            self.navigationItem.title = self.userGeneral?.name
            
            if let image = self.userGeneral?.photo {
                self.photo.sd_setImageWithURL(NSURL(string: image))
            }
            
            self.city.text = userGeneral?.appCityStr
            
            self.tel.text = self.userGeneral?.tel
            
        case 1:
            self.navigationItem.title = self.userClub?.name
            
            if let image = self.userClub?.photo {
                self.photo.sd_setImageWithURL(NSURL(string: image))
            }
            
            self.city.text = userClub?.appCityStr
            
            self.tel.text = self.userClub?.tel
            
        case 2:
            self.navigationItem.title = self.userCoach?.name
            
            if let image = self.userCoach?.photo {
                self.photo.sd_setImageWithURL(NSURL(string: image))
            }
            
            self.city.text = userCoach?.appCityStr
            
            self.tel.text = self.userCoach?.tel
        default:
            break
        }
    }
    
    func updateUserinfo(userType: Int, userinfo: AnyObject) {
        self.userType = userType
        switch userType {
        case 0:
            self.userGeneral = userinfo as? UserInfo
        case 1:
            self.userClub = userinfo as? ClubInfo
        case 2:
            self.userCoach = userinfo as? CoachInfo
        default:
            break
        }
        self.initUI()
    }
    
    @IBAction func gotoEditUserinfo(sender: AnyObject) {
        switch userType {
        case 0:
            let userGeneralModifyInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralModifyInfoViewController") as! UserGeneralModifyInfoViewController
            userGeneralModifyInfoViewController.isModify = true
            userGeneralModifyInfoViewController.userinfo = self.userGeneral
            userGeneralModifyInfoViewController.delegate = self
            self.navigationController?.pushViewController(userGeneralModifyInfoViewController, animated: true)
        case 1:
            
            let userClubModifyInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserClubModifyInfoViewController") as! UserClubModifyInfoViewController
            userClubModifyInfoViewController.isModify = true
            userClubModifyInfoViewController.userinfo = self.userClub
            userClubModifyInfoViewController.delegate = self
            self.navigationController?.pushViewController(userClubModifyInfoViewController, animated: true)
        case 2:
            
            let userCoachModifyInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserCoachModifyInfoViewController") as! UserCoachModifyInfoViewController
            userCoachModifyInfoViewController.isModify = true
            userCoachModifyInfoViewController.userinfo = self.userCoach
            userCoachModifyInfoViewController.delegate = self
            self.navigationController?.pushViewController(userCoachModifyInfoViewController, animated: true)
        default:
            break
        }
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
