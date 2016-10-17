//
//  PublishViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/9.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class PublishViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: BRPlaceholderTextView!
    
    var coach: CoachInfo?
    var club: ClubInfo?
    var userType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setBackButton()
        contentTextView.placeholder = "公告内容"
        if userType == 1 {
            //club
            titleTextField.text = club?.publishTitle
            contentTextView.text = club?.publish
        } else if userType == 2 {
            //club
            titleTextField.text = coach?.publishTitle
            contentTextView.text = coach?.publish
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func gotoPublish(sender: AnyObject) {
        
        guard let publishTitle = titleTextField.text where !publishTitle.isEmpty else {
            displayAlertControllerWithMessage("请填写公告标题")
            return
        }
        guard let publish = contentTextView.text where !publish.isEmpty else {
            displayAlertControllerWithMessage("请填写公告内容")
            return
        }
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        
        var url = modifyJlUser
        if userType == 1 {
            url = modifyHgUser
        }
        
        let parameters =  ["username":username,"password":password,"userType":userType!, "publishTitle":publishTitle, "publish":publish] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseModifyResult)
    }
    
    func praseModifyResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            let alertView = UIAlertController(title: "提醒", message: "发布成功", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {
                action in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }else{
            let alertView = UIAlertController(title: "提醒", message: "发布失败", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }
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
