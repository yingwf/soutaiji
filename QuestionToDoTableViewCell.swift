//
//  QuestionToDoTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class QuestionToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var payTitle: UILabel!
    
    
    static let id = "QuestionToDoTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func dataBind(teaching: Teaching ) {
        userName.text = teaching.user?.name
        photo.sd_setImageWithURL(NSURL(string:teaching.user?.photo ?? ""))
        price.text = String(teaching.fee ?? 0)
        price.sizeToFit()
        question.text = teaching.content
        question.sizeToFit()
        selectionStyle = .None
        
        if teaching.status != 0 {
            payTitle.text = "已经支付指导费"
            price.textColor = UIColor.lightGrayColor()
            editButton.setTitle("删除提问", forState: .Normal)
            deleteButton.hidden = true
        } else {
            payTitle.text = "愿意支付指导费"
            price.textColor = SYSTEMCOLOR
        }
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
