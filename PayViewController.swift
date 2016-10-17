//
//  PayViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD


enum PayType: Int {
    case Teaching = 0, Vip, Lesson, LessonExp
}


class PayViewController: UIViewController {

    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var orderFeeLabel: UILabel!
    
    var orderId: String?
    var productName: String?
    var orderFee: Int?
    var month: Int?
    var payType: PayType = .Teaching
    var teaching: Teaching?
    var coach: CoachInfo?
    var club: ClubInfo?
    var lesson: LessonInfo?
    var toUserType: Int?
    var mobile: String?
    var expTime: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        switch payType {
        case .Teaching:
            orderIdLabel.text = teaching?.extraOrderInfo?.uniOrderId
            productNameLabel.text = "\(coach?.name ?? "")（教学指正）"
            orderFeeLabel.text = "￥\(Float(teaching?.fee ?? 0))元"
            
        case .Vip:
            orderIdLabel.text = orderId
            productNameLabel.text = productName
            if let orderFee = orderFee {
                orderFeeLabel.text = "￥\(Float(orderFee))元"
            }
            
        case .Lesson:
            productNameLabel.text = lesson?.name
            orderFeeLabel.text = "￥\(Float(lesson?.price ?? 0))元"
            
        case .LessonExp:
            productNameLabel.text = lesson?.name
            orderFeeLabel.text = "￥\(Float(lesson?.expPrice ?? 0))元"
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func gotoPay(sender: AnyObject) {
        
        switch payType {
        case .Teaching:
            pickTeaching()
        case .Vip:
            buyVip()
        case .Lesson:
            buyLesson()
        case .LessonExp:
            buyLessonExp()
        default:
            break
        }
    }
    
    func buyLesson() {
        guard let toUserType = self.toUserType, let mobile = self.mobile else {
            return
        }
        guard let toUserId = toUserType == 1 ? club?.id : coach?.id else {
            return
        }
        guard let price = lesson?.price, let lessonId = lesson?.id else {
            return
        }
        
        let url = orderLesson
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType, "toUserId": toUserId, "toUserType": toUserType, "mobile":mobile, "price":price, "lessonId": lessonId ] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseResult)
    }
    
    func buyLessonExp() {
        guard let toUserType = self.toUserType, let mobile = self.mobile, let expTime = self.expTime else {
            return
        }
        guard let toUserId = toUserType == 1 ? club?.id : coach?.id else {
            return
        }
        guard let expPrice = lesson?.expPrice, let lessonId = lesson?.id else {
            return
        }
        
        let url = orderLesson
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType, "toUserId": toUserId, "toUserType": toUserType, "mobile":mobile, "price":expPrice, "lessonId": lessonId, "expTime": expTime ] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseResult)
    }
    
    func buyVip() {
        guard let orderFee = self.orderFee, let month = self.month else {
            return
        }
        let url = buyVIP
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType, "mount": orderFee, "month": month ] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseResult)
    }
    
    func pickTeaching() {
        
        guard let teachId = teaching?.id, let jlId = coach?.id else {
            return
        }
        let url = pickCoachForTeaching
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType, "teachId": teachId, "jlId": jlId ] as [String : AnyObject]

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseResult)
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            let okAction = UIAlertAction(title: "确定", style: .Default) { _ in
                self.navigationController?.popViewControllerAnimated(true)
            }
            displayAlertController("完成支付", actions: [okAction])
        }else{
            displayAlertControllerWithMessage("完成失败")

        }
    }

}
