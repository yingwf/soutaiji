//
//  AddRemarkViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/25.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SwiftyJSON


class AddRemarkViewController: UIViewController {

    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var remarkTextView: BRPlaceholderTextView!
    @IBOutlet weak var remarkView: StarView!
    
    
    var teaching: Teaching?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarkTextView.placeholder = "请对本次指导您的老师进行评价"
        setBackButton()
        getCoach()
        
    }
    
    func getCoach() {
        guard let jlId = teaching?.jlId where jlId > 0 else {
            return
        }
        
        let url = getCoachInfo
        let params = ["coachId": jlId ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseCoachResult)
    }
    
    func praseCoachResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        let coachInfo = CoachInfo(json:json["userjl"])
        headImage.sd_setImageWithURL(NSURL(string: coachInfo.photo ?? coachInfo.pic1 ?? ""))
        userName.text = coachInfo.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finishToRemark(sender: AnyObject) {
        let stars = remarkView.star
        let content = remarkTextView.text
        guard let teachId = teaching?.id else {
            return
        }
        
        let url = addRemark
        let params = [ "username":userInfoStore.userName, "password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType, "teachId": teachId, "remarkStars": stars, "remarkContent":content ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseRemarkResult)
    }
    
    func praseRemarkResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        let okAction = UIAlertAction(title: "确定", style: .Default) {action in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        displayAlertController("完成评价", actions: [okAction])

    }
    

}
