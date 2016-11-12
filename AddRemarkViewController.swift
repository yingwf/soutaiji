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
    var eoList: EoList?
    var isEoList = false //订单评价，教学指正评价
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarkTextView.placeholder = isEoList ? "请对本次学习体验进行评价" : "请对本次指导您的老师进行评价"
        setBackButton()
        if isEoList {
            self.navigationItem.title = "评价订单"
            let pic = eoList?.expOrder?.actionType == 1 ? eoList?.user?.pic : eoList?.lesson?.pic
            headImage.sd_setImageWithURL(NSURL(string: pic ?? ""))
            userName.text = eoList?.expOrder?.actionType == 1 ? eoList?.user?.name : eoList?.lesson?.name
                
        } else {
            getCoach()
        }
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
        
        if isEoList {
            //订单评价
            guard let expOrderId = eoList?.expOrder?.id else {
                return
            }
            let url = addEORemark
            let params = [ "username":userInfoStore.userName, "password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType, "expOrderId": expOrderId, "stars": stars, "content":content ] as! [String : AnyObject]
            doRequest(url, parameters: params , praseMethod: praseRemarkResult)
            
            
        } else {
            //教练评价
            guard let teachId = teaching?.id else {
                return
            }
            
            let url = addRemark
            let params = [ "username":userInfoStore.userName, "password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType, "teachId": teachId, "remarkStars": stars, "remarkContent":content ] as! [String : AnyObject]
            doRequest(url, parameters: params , praseMethod: praseRemarkResult)
        }

    }
    
    func praseRemarkResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        let okAction = UIAlertAction(title: "确定", style: .Default) {action in
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        displayAlertController("完成评价", actions: [okAction])

    }
    

}
