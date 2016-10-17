//
//  DropDownMenuCollectionViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/6/9.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class DropDownMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor(red: 0xd8/255, green: 0xd8/255, blue: 0xd8/255, alpha: 1).CGColor
        
    }

}
