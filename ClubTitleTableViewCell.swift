//
//  ClubTitleTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class ClubTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var more: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        more.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
