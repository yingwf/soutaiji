//
//  QuestionTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var boundView: UIView!

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var jiedan: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var QImage: UIImageView!
    
    @IBOutlet weak var QDescription: UILabel!
    
    @IBOutlet weak var statusTitle: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        boundView.layer.borderWidth = 0.5
        boundView.layer.borderColor = UIColor(red: 0xd8/255, green: 0xd8/255, blue: 0xd8/255, alpha: 1).CGColor
        dotView.backgroundColor = SYSTEMCOLOR
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = 4
        
        
    }
    
    func dataBind(teaching: Teaching, isMine: Bool) {
        if isMine {
            switch teaching.status! {
            case 0:
                statusTitle.text = "申请中"
            case 1:
                statusTitle.text = "教学中"
            case 2:
                statusTitle.text = "已结束"
            default:
                break
            }
            statusTitle.sizeToFit()
            price.hidden = true
            unitLabel.hidden = true
        } else {
            statusTitle.text = "悬赏"
            price.hidden = false    
            unitLabel.hidden = false
            price.text = String(teaching.fee ?? 0)
            price.sizeToFit()
        }
        
        setCoachWithCount(teaching.applyCoachCount ?? 0 )
        
        QImage.sd_setImageWithURL(NSURL(string: teaching.user?.photo ?? ""))
        QDescription.text = teaching.content
        QDescription.sizeToFit()
        
    }
    
    func setJiedanPrice(price: Int) {
        self.price.text = String(price)
        self.price.sizeToFit()
    }
    
    func setCoachWithCount(count: Int) {
        if count == 0 {
            jiedan.text = "暂无教练接单"
            dotView.hidden = true
            jiedan.sizeToFit()
            return
        }
        jiedan.text = "\(count)位教练接单"
        jiedan.sizeToFit()
        dotView.hidden = false
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
