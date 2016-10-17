//
//  CoachIntroTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachIntroTableViewCell: UITableViewCell {
    @IBOutlet weak var coachIntroLabel: UILabel!
    @IBOutlet weak var expandView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
