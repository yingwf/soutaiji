//
//  InfoTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/27.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var value: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView(frame: CGRect(x: 10, y: 43.5, width: screenWidth, height: 0.5))
        view.backgroundColor = UIColor(hex: 0xefefef)
        self.contentView.addSubview(view)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
