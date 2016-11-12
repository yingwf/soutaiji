//
//  VideoTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/11/11.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var video: UIView!
    static let id = "VideoTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func dataBind(vc:UIViewController ,videoUrl: String) {
        let player = AVPlayer(URL: NSURL(string: videoUrl)!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        video.addSubview(playerController.view)
        vc.addChildViewController(playerController)
        playerController.view.frame = video.frame
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
