//
//  InfoFeeTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/27.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class InfoFeeTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
