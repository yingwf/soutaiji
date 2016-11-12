//
//  ClubAppraiseTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class ClubAppraiseTableViewCell: UITableViewCell {

    static let id = "ClubAppraiseTableViewCell"
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var remarkName: UILabel!
    @IBOutlet weak var remarkTime: UILabel!
    @IBOutlet weak var remarkType: UILabel!
    @IBOutlet weak var remarkContent: UILabel!
    @IBOutlet weak var remarkStarView: StarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func dataBindWithUserRemark(remark: UserRemark) {
        userPic.sd_setImageWithURL(NSURL(string: remark.user!.pic ?? ""))
        remarkName.text = remark.user!.name
        remarkTime.text = (remark.remark!.remarkTime! as NSString).substringToIndex(10)
        remarkContent.text = remark.remark?.content
        remarkStarView.setResult(remark.remark?.stars ?? 0)
        remarkType.text = remark.remark?.remarkType == 1 ? "教学评价" : "体验评价"
        remarkStarView.userInteractionEnabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
