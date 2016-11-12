//
//  videQuestionViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/4.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyJSON

class videQuestionViewController: UIViewController {
    @IBOutlet weak var mediaPlayerView: UIView!

    var url: NSURL?
    @IBOutlet weak var fee: UITextField!
    @IBOutlet weak var content: BRPlaceholderTextView!
    var teaching: Teaching?
    var isModify = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        content.placeholder = "输入对教练的问题"
        if isModify {
            guard let teaching = self.teaching else {
                return
            }
            let player = AVPlayer(URL: NSURL(string: teaching.video ?? "")!)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = mediaPlayerView.frame
            
            fee.text = String(teaching.fee ?? 0)
            content.text = teaching.content
            
        } else {
            guard let url = self.url else {
                return
            }
            let player = AVPlayer(URL: url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = mediaPlayerView.frame
        }
        
    }
    
    @IBAction func askForTeaching(sender: AnyObject) {
        if isModify {
            modifyTeaching()
        } else {
            createTeaching()
        }
    }
    
    func createTeaching() {
        guard let url = self.url else {
            return
        }
        guard let fee = fee.text else {
            displayAlertControllerWithMessage("请输入费用")
            return
        }
        guard let content = content.text else {
            displayAlertControllerWithMessage("请输入问题描述")
            return
        }
        
        uploadVideo(url, handler: { json in
            guard let videoUrl = json?["url"].string, let videoThumb = json?["thumb"].string else {
                self.displayAlertControllerWithMessage("提交出错，请重新提交")
                return
            }
            let requestUrl = askForTeach
            let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "content":content , "video":videoUrl, "fee": fee, "videoThumb": videoThumb ] as! [String : AnyObject]
            doRequest(requestUrl, parameters: params , praseMethod: self.praseResult)
        })
    }
    
    func modifyTeaching() {
        guard let teachingId = self.teaching?.id, let videoUrl = self.teaching?.video, let videoThumb = self.teaching?.videoThumb else {
            return
        }
        guard let fee = fee.text else {
            displayAlertControllerWithMessage("请输入费用")
            return
        }
        guard let content = content.text else {
            displayAlertControllerWithMessage("请输入问题描述")
            return
        }
        
        let requestUrl = modifyTeachingRequest
        let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType ,"teachId":teachingId,  "content":content , "video":videoUrl, "fee": fee, "videoThumb": videoThumb ] as! [String : AnyObject]
        doRequest(requestUrl, parameters: params , praseMethod: self.praseResult)
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {action in
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        displayAlertController("提交完成", actions: [okAction])
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
