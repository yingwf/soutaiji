//
//  ClubDetailTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class ClubDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var renzheng: UILabel!
    @IBOutlet weak var liupai: UILabel!
    @IBOutlet weak var visitCount: UILabel!
    @IBOutlet weak var waiyu: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
