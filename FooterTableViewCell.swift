//
//  FooterTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var moment: UIView!
    @IBOutlet weak var wechat: UIView!
    
    static let identifier = "FooterTableViewCell"
    var vc: UIViewController?
    var coach: CoachInfo?
    var club: ClubInfo?
    var lesson: LessonInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI(vc: UIViewController?, coach: CoachInfo?, club: ClubInfo?, lesson: LessonInfo? ) {
        self.vc = vc
        self.coach = coach
        self.club = club
        self.lesson = lesson
        
        moment.layer.borderWidth = 0.5
        moment.layer.borderColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).CGColor
        moment.layer.cornerRadius = 14.5
        moment.layer.masksToBounds = true
        
        wechat.layer.borderWidth = 0.5
        wechat.layer.borderColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).CGColor
        wechat.layer.cornerRadius = 14.5
        wechat.layer.masksToBounds = true
        
        let tapWeChatFriend = UITapGestureRecognizer(target: self, action: #selector(didClickOnWeChatFriend))
        let tapFriendCircle = UITapGestureRecognizer(target: self, action: #selector(didClickOnFriendCircle))
        moment.userInteractionEnabled = true
        wechat.userInteractionEnabled = true
        moment.addGestureRecognizer(tapWeChatFriend)
        wechat.addGestureRecognizer(tapFriendCircle)
    }
    
    func didClickOnWeChatFriend(){
        /*
        if !WXApi.isWXAppInstalled() {
            let alertView = UIAlertController(title: "提醒", message: "没有安装微信，不能转发分享", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(UIAlertAction) -> Void in
                return
            }
            alertView.addAction(okAction)
            self.vc?.presentViewController(alertView, animated: true, completion: nil)
            return
        }*/

        let message = WXMediaMessage()
        let webpageObject = WXWebpageObject()

        if let coach = self.coach {
            message.title = "太极教练:\(coach.name ?? "")"
            message.description = coach.content
            webpageObject.webpageUrl = coach.sharedUrl
        }
        if let club = self.club {
            message.title = "太极会馆:\(club.name ?? "")"
            message.description = club.content
            webpageObject.webpageUrl = club.sharedUrl
        }
        if let lesson = self.lesson {
            message.title = "太极课程:\(lesson.name ?? "")"
            message.description = lesson.description
            webpageObject.webpageUrl = lesson.sharedUrl
        }
        
        message.setThumbImage(UIImage(named: "ic_tab_taiji_on"))
        message.mediaObject = webpageObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1 //WXSceneTimeline
        
        WXApi.sendReq(req)
        
    }
    
    func didClickOnFriendCircle(){
        /*
        if !WXApi.isWXAppInstalled() {
            let alertView = UIAlertController(title: "提醒", message: "没有安装微信，不能转发分享", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(UIAlertAction) -> Void in
                return
            }
            alertView.addAction(okAction)
            self.vc?.presentViewController(alertView, animated: true, completion: nil)
            return
        }*/
        
        let message = WXMediaMessage()
        let webpageObject = WXWebpageObject()
        
        if let coach = self.coach {
            message.title = "太极教练:\(coach.name ?? "")"
            message.description = coach.content
            webpageObject.webpageUrl = coach.sharedUrl
        }
        if let club = self.club {
            message.title = "太极会馆:\(club.name ?? "")"
            message.description = club.content
            webpageObject.webpageUrl = club.sharedUrl
        }
        if let lesson = self.lesson {
            message.title = "太极课程:\(lesson.name ?? "")"
            message.description = lesson.description
            webpageObject.webpageUrl = lesson.sharedUrl
        }
        
        message.setThumbImage(UIImage(named: "ic_tab_taiji_on"))
        message.mediaObject = webpageObject
        
        //完成发送对象实例
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 0 //WXSceneSession
        
        //发送分享信息
        WXApi.sendReq(req)
        
    }

    
}
