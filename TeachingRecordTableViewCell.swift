//
//  TeachingRecordTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

let voiceIndicatorImageTag = 10040


class TeachingRecordTableViewCell: UITableViewCell {

    static let id = "TeachingRecordTableViewCell"
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var teachingDate: UILabel!
    @IBOutlet weak var teachingContent: UILabel!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var voicePlayIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    

    
    func dataBind(teachingRecord: TeachingRecord, fromUser: Bool) {
        
        setUpVoicePlayIndicatorImageView(false)
        voicePlayIndicatorImageView.tag = voiceIndicatorImageTag
        voicePlayIndicatorImageView.animationDuration = 1.0
        
        let recordFromUser = teachingRecord.fromUser == 1
        
        if recordFromUser == fromUser {
            name.text = "我"
        } else if recordFromUser {
            name.text = teachingRecord.user?.name
        } else {
            name.text = teachingRecord.coach?.name
        }
        
        if recordFromUser {
            headImage.sd_setImageWithURL(NSURL(string: teachingRecord.user?.photo ?? ""))
        } else {
            headImage.sd_setImageWithURL(NSURL(string: teachingRecord.coach?.photo ?? ""))
        }
        if let time = teachingRecord.createdTime as? NSString where time.length > 10 {
            teachingDate.text = time.substringToIndex(10)
        } else {
            teachingDate.text = teachingRecord.createdTime
        }
        audioView.hidden = teachingRecord.audio?.isEmpty ?? true

        teachingContent.text = teachingRecord.content
        teachingContent.sizeToFit()
        
        
    }
    
    
    func stopAnimation() {
        if voicePlayIndicatorImageView.isAnimating() {
            voicePlayIndicatorImageView.stopAnimating()
        }
    }
    
    
    func beginAnimation() {
        voicePlayIndicatorImageView.startAnimating()
    }
    
    func setUpVoicePlayIndicatorImageView(send: Bool) {
        var images = NSArray()
        if send {
            images = NSArray(objects: UIImage(named: "SenderVoiceNodePlaying001")!, UIImage(named: "SenderVoiceNodePlaying002")!, UIImage(named: "SenderVoiceNodePlaying003")!)
            //voicePlayIndicatorImageView.image = UIImage(named: "SenderVoiceNodePlaying")
        } else {
            images = NSArray(objects: UIImage(named: "ReceiverVoiceNodePlaying001")!, UIImage(named: "ReceiverVoiceNodePlaying002")!, UIImage(named: "ReceiverVoiceNodePlaying003")!)
            //voicePlayIndicatorImageView.image = UIImage(named: "ReceiverVoiceNodePlaying")
        }
        
        voicePlayIndicatorImageView.animationImages = (images as! [UIImage])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            voicePlayIndicatorImageView.startAnimating()
        } else {
            voicePlayIndicatorImageView.stopAnimating()
        }
    }
    
}
