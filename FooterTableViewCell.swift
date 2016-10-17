//
//  FooterTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var moment: UIView!
    @IBOutlet weak var wechat: UIView!
    
    static let identifier = "FooterTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI() {
        moment.layer.borderWidth = 0.5
        moment.layer.borderColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).CGColor
        moment.layer.cornerRadius = 14.5
        moment.layer.masksToBounds = true
        
        wechat.layer.borderWidth = 0.5
        wechat.layer.borderColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.54).CGColor
        wechat.layer.cornerRadius = 14.5
        wechat.layer.masksToBounds = true
    }
    
}
