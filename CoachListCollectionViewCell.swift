//
//  CoachListCollectionViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/25.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var liupai: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var waiyu: UILabel!
    @IBOutlet weak var photo: UIImageView!

    @IBOutlet weak var renzheng: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        renzheng.backgroundColor = SYSTEMCOLOR
        renzheng.textColor = UIColor.whiteColor()
    }

}
