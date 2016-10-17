//
//  CoachApplyTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachApplyTableViewCell: UITableViewCell {

    static let id = "CoachApplyTableViewCell"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var applyTime: UILabel!
    @IBOutlet weak var question: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
