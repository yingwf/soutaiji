//
//  OrderListTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/11/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    static let id = "OrderListTableViewCell"
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var teachTimes: UILabel!
    @IBOutlet weak var eoId: UILabel!
    @IBOutlet weak var eoTime: UILabel!
    @IBOutlet weak var eoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func dataBind(eoList: EoList) {
        let headImage = eoList.expOrder?.actionType == 1 ? eoList.user?.pic : eoList.lesson?.pic
        
        pic.sd_setImageWithURL(NSURL(string: headImage ?? ""))
        
        let price = (NSString(format: "%.2f", Float(eoList.expOrder?.price ?? 0)) as String)
        
        switch eoList.expOrder?.actionType ?? 1 {
        case 1:
            lessonName.text = eoList.user?.name
            teachTimes.text = "单次体验   ￥\(price)"
        case 2:
            lessonName.text = eoList.lesson?.name
            teachTimes.text = "单次体验   ￥\(price)"
        case 3:
            lessonName.text = eoList.lesson?.name
            teachTimes.text = "\(eoList.lesson?.classCount ?? 0)次课   ￥\(price)"
        default:
            lessonName.text = eoList.user?.name
            teachTimes.text = "单次体验   ￥\(price)"
        }

        eoId.text = "订单编号: \(eoList.extraOrderInfo?.uniOrderId ?? "")"
        eoTime.text = (eoList.expOrder?.applyTime as! NSString).substringToIndex(10)
        
        switch  eoList.expOrder?.status ?? 3 {
        case 1:
            eoButton.hidden = false
            eoButton.setTitle("立即支付", forState: .Normal)
            eoButton.setTitleColor(SYSTEMCOLOR, forState: .Normal)
            eoButton.layer.borderColor = SYSTEMCOLOR.CGColor
            eoButton.layer.borderWidth = 0.5
        case 2:
            eoButton.hidden = false
            eoButton.setTitle("立即评价", forState: .Normal)
            eoButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            eoButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            eoButton.layer.borderWidth = 0.5
        case 3:
            eoButton.hidden = true
        default:
            eoButton.hidden = true
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
