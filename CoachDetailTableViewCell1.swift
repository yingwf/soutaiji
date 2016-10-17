//
//  CoachDetailTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachDetailTableViewCell1: UITableViewCell {
    @IBOutlet weak var buyContactLabel: UILabel!
    @IBOutlet weak var renzheng: UILabel!

    override func awakeFromNib() {
        self.renzheng.layer.borderWidth = 0.5
        self.renzheng.layer.borderColor = UIColor(red: 0x8c/255, green: 0x18/255, blue: 0x02/255, alpha: 1).CGColor
        
        
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
