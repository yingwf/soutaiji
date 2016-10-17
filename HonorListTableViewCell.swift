//
//  HonorListTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/28.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class HonorListTableViewCell: UITableViewCell {

    @IBOutlet weak var honorImage: UIImageView!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var honorDesc: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
