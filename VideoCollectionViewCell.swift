//
//  VideoCollectionViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/28.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var playView: UIImageView!
    
    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        playView.userInteractionEnabled = true
        playView.addGestureRecognizer(tap)
        
        self.videoView.addSubview(playerController.view)
        playerController.view.frame = self.videoView.bounds
        playerController.showsPlaybackControls = false
        self.videoView.bringSubviewToFront(self.playView)
    }
    
    func setVideo(url: NSURL) {
        self.player = AVPlayer(URL: url)
        playerController.player = player
        //self.addChildViewController(playerController)

    }
    
    func playVideo() {
        self.player.play()
    }

}
