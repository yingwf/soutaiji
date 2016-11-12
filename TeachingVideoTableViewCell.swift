//
//  TeachingVideoTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/11/11.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class TeachingVideoTableViewCell: UITableViewCell {

    static let id = "TeachingVideoTableViewCell"
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func dataBind(vipVideo: VipVideo) {
        videoName.text = vipVideo.name
        videoDesc.text = vipVideo.description
        videoDesc.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
