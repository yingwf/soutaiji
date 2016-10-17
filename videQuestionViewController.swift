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
    @IBOutlet weak var content: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            return
        }
        /*
        let mediaPlayerController = MPMoviePlayerController(contentURL:url)
        mediaPlayerController.view.frame = CGRect(x: 0,y: 0,width: 375,height: 114)
        mediaPlayerController.scalingMode = .AspectFill
        mediaPlayerController.controlStyle = .Embedded
        self.mediaPlayerView.addSubview(mediaPlayerController.view)
        mediaPlayerController.play()
        */
        
        //let player = AVPlayer(URL: NSURL(fileURLWithPath: url))
        let player = AVPlayer(URL: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = mediaPlayerView.frame
        
    }
    
    @IBAction func askForTeaching(sender: AnyObject) {
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
                self.displayAlertControllerWithMessage("网络出错，请重新提交")
                return
            }
            let requestUrl = askForTeach
            let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "content":content , "video":videoUrl, "fee": fee, "videoThumb": videoThumb ] as! [String : AnyObject]
            doRequest(requestUrl, parameters: params , praseMethod: self.praseResult)
        })
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
