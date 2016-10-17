//
//  ClubTeacherTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/23.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class ClubTeacherTableViewCell: UITableViewCell {

    static let id = "ClubTeacherTableViewCell"
    @IBOutlet weak var coachName: UITextField!
    @IBOutlet weak var coachContent: UITextField!
    @IBOutlet weak var coachImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view1 = UIView(frame: CGRect(x: 70, y: 39, width: screenWidth - 78 , height: 0.5))
        view1.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.contentView.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 70, y: 77, width: screenWidth - 78 , height: 0.5))
        view2.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.contentView.addSubview(view2)
        
    }
    
    func dataBind(image: String?, name: String?, content: String? ) {
        coachName.text = name
        coachContent.text = content
        coachContent.sizeToFit()
        coachImage.sd_setImageWithURL(NSURL(string: image ?? ""))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
