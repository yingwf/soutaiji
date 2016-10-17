//
//  MyCoachTableViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/3.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SDWebImage

class MyCoachTableViewController: UITableViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var renzheng: UILabel!
    
    @IBOutlet weak var visitCount: UILabel!
    
    @IBOutlet weak var paiming: UILabel!
    @IBOutlet weak var shouru: UILabel!
    
    @IBOutlet weak var yue: UILabel!
    @IBOutlet weak var pingjia: UILabel!
    
    var userInfo: CoachInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = userInfo?.photo {
            self.photo.sd_setImageWithURL(NSURL(string: photo))
        }
        self.renzheng.hidden = (userInfo?.renzheng == 1) ? false:true
        self.name.text = userInfo?.name
        self.userName.text = userInfo?.user_Name
        self.name.sizeToFit()
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 3
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return 86
        case (0,1):
            return 66
        case (1...2,0):
            return 5
        case (1...2,1...2):
            return 50
        default:
            break
        }
        return 50
    }
    
    @IBAction func gotoSet(sender: AnyObject) {
        let setTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetTableViewController") as! SetTableViewController
        self.navigationController?.pushViewController(setTableViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let userGeneralDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralDetailViewController")as! UserGeneralDetailViewController
            userGeneralDetailViewController.userType = 2
            userGeneralDetailViewController.userCoach = self.userInfo
            self.navigationController?.pushViewController(userGeneralDetailViewController, animated: true)
        case (1,1):
            let moneyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MoneyViewController")as! MoneyViewController
            self.navigationController?.pushViewController(moneyViewController, animated: true)
        case (1,2):
            let remarkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RemarkViewController")as! RemarkViewController
            self.navigationController?.pushViewController(remarkViewController, animated: true)
        case (2,1):
            let courseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CourseViewController")as! CourseViewController
            courseViewController.coach = self.userInfo
            self.navigationController?.pushViewController(courseViewController, animated: true)
            
        case (2,2):
            let publishViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PublishViewController")as! PublishViewController
            publishViewController.coach = self.userInfo
            publishViewController.userType = 2
            self.navigationController?.pushViewController(publishViewController, animated: true)
        default:
            break
        }

    }

    
}
