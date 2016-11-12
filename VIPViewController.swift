//
//  VIPViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/22.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class VIPViewController: UITableViewController {

    
    @IBOutlet weak var offlineClubView: UIView!
    @IBOutlet weak var teachVideoView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var vipContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        offlineClubView.layer.borderColor = UIColor.lightGrayColor().CGColor
        offlineClubView.layer.borderWidth = 1
        teachVideoView.layer.borderColor = UIColor.lightGrayColor().CGColor
        teachVideoView.layer.borderWidth = 1
        
        self.setBackButton()
        
        vipContentLabel.sizeToFit()
        
        let applyButtonTitle = userInfoStore.isVip == 0 ? "加入V学员" : "续费"
        applyButton.setTitle(applyButtonTitle, forState: .Normal)
        
        offlineClubView.userInteractionEnabled = true
        offlineClubView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoOfflineClub)))
        
        teachVideoView.userInteractionEnabled = true
        teachVideoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoTeachVideo)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoBuyVIP(sender: AnyObject) {
        let buyContactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BuyContactViewController") as! BuyContactViewController
        self.navigationController?.pushViewController(buyContactViewController, animated: true)
        
    }
    
    func gotoOfflineClub() {
        
        let clubViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubViewController") as! ClubViewController
        clubViewController.isOffline = true
        self.navigationController?.pushViewController(clubViewController, animated: true)
    }
    
    func gotoTeachVideo() {
        
        if userInfoStore.isVip == 0 {
            self.displayAlertControllerWithMessage("不是VIP学员，不能访问")
            return
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VipVideoViewController") as! VipVideoViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
