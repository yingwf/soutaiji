//
//  HeaderTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/27.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var uploadImage: UILabel!
    var imgView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uploadImage.layer.borderWidth = 0.5
        self.uploadImage.layer.borderColor = self.uploadImage.textColor.CGColor
        
    }
    
    func setImageView(image: UIImage) {
        if imgView == nil {
            imgView = UIImageView(frame: uploadImage.frame)
            self.contentView.addSubview(imgView!)
        }
        imgView?.image = image
    }
    
    func setImageViewWithUrl(url: NSURL) {
        if imgView == nil {
            imgView = UIImageView(frame: uploadImage.frame)
            self.contentView.addSubview(imgView!)
        }
        imgView?.sd_setImageWithURL(url)
    }
    
    func getImage() -> UIImage? {
        return self.imgView?.image
    }
    
    func setClubHeader() {
        self.uploadImage.layer.borderWidth = 0
        self.uploadImage.layer.borderColor = UIColor.clearColor().CGColor
        self.uploadImage.frame = self.contentView.bounds
        self.uploadImage.text = "上传封面图"
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
