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
    case Teaching = 0, Vip, Lesson, LessonExp, EoList
}


class PayViewController: UIViewController {

    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var orderFeeLabel: UILabel!
    
    var orderId: String?
    var productName: String?
    var orderFee: Float = 0.0
    var month: Int?
    var payType: PayType = .Teaching
    var teaching: Teaching?
    var coach: CoachInfo?
    var club: ClubInfo?
    var lesson: LessonInfo?
    var toUserType: Int?
    var mobile: String?
    var expTime: String?
    var eoList: EoList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        switch payType {
        case .Teaching:
            orderIdLabel.text = teaching?.extraOrderInfo?.uniOrderId
            productNameLabel.text = "\(coach?.name ?? "")（教学指正）"
            orderFee = Float(teaching?.fee ?? 0)
            
        case .Vip:
            orderIdLabel.text = orderId
            productNameLabel.text = productName
            
        case .Lesson:
            productNameLabel.text = lesson?.name
            orderFee = Float(lesson?.price ?? 0)
            
        case .LessonExp:
            productNameLabel.text = lesson?.name
            orderFee = Float(lesson?.expPrice ?? 0)
            
        case .EoList:
            productNameLabel.text = eoList?.expOrder?.actionType == 1 ? eoList?.user?.name : eoList?.lesson?.name
            orderFee = Float(eoList?.expOrder?.price ?? 0)
            self.orderIdLabel.text = eoList?.extraOrderInfo?.uniOrderId
            
        default:
            break
        }
        orderFeeLabel.text = "￥\(NSString(format: "%.2f", orderFee))元"
        
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
        case .EoList:
            gotoPay()
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
        guard let month = self.month else {
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
            if payType == .Vip || payType == .Lesson || payType == .LessonExp {
                self.orderIdLabel.text = json["uniOrderId"].string
            }
            gotoPay()
        }else{
            displayAlertControllerWithMessage("订购失败")

        }
    }
    
    func gotoPay() {
        
        guard let subject = productNameLabel.text, let out_trade_no = orderIdLabel.text else {
            return
        }
        
        let payHandler : (Bool, String) -> Void = { success, message in
            if success {
                let okAction = UIAlertAction(title: "确定", style: .Cancel) { action in
                    if let count = self.navigationController?.viewControllers.count where count > 3 {
                        if self.payType == .Vip {
                            let popVc = self.navigationController?.viewControllers[count - 3]
                            self.navigationController?.popToViewController(popVc!, animated: true)
                        }else if self.payType == .EoList {
                            let popVc = self.navigationController?.viewControllers[count - 2]
                            self.navigationController?.popToViewController(popVc!, animated: true)
                        } else {
                            let popVc = self.navigationController?.viewControllers[count - 4]
                            self.navigationController?.popToViewController(popVc!, animated: true)
                        }
                    } else {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
                self.displayAlertController(message, actions: [okAction])
                return
            } else {
                self.displayAlertControllerWithMessage(message)
                return
            }
        }
        
        let orderContent = OrderContent(subject: subject, out_trade_no: out_trade_no, total_amount: orderFee)
        
        AliPayController.payWithEcodeOrderInfo(orderContent, handler: payHandler)
    }

}
