//
//  CoachQualificationTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachQualificationTableViewCell: UITableViewCell {

    static let identifier = "CoachQualificationTableViewCell"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var introduce: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataBind(coach: CoachInfo) {
        photo.sd_setImageWithURL(NSURL(string: coach.photo ?? ""))
        name.text = coach.name
        introduce.text = coach.content
    }
    
    func dataBindWithFields(coachPic: String?, coachName: String?, coachDesc: String?) {
        photo.sd_setImageWithURL(NSURL(string: coachPic ?? ""))
        name.text = coachName
        introduce.text = coachDesc
    }
    
}
