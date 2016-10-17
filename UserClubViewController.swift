//
//  UserClubViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/9.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class UserClubViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var renzheng: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var visitCount: UILabel!
    @IBOutlet weak var coachVisit: UILabel!
    @IBOutlet weak var clubVisit: UILabel!

    
    @IBOutlet weak var yue: UILabel!
    @IBOutlet weak var pingjia: UILabel!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var gonggaoView: UIView!
    
    var userinfo: ClubInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.name.text = self.userinfo?.name
        self.userName.text = self.userinfo?.user_Name
        self.visitCount.text = String(self.userinfo?.userVisitCount ?? 0)
        self.coachVisit.text = String(self.userinfo?.jlVisitCount ?? 0)
        self.clubVisit.text = String(self.userinfo?.hgVisitCount ?? 0)

        if self.userinfo?.renzheng == 1 {
            self.renzheng.hidden = false
            self.renzheng.layer.borderWidth = 0.5
            self.renzheng.layer.borderColor = SYSTEMCOLOR.CGColor
        } else {
            self.renzheng.hidden = true
        }
        
        userView.userInteractionEnabled = true
        let userTap = UITapGestureRecognizer(target: self, action: #selector(gotoUser(_:)))
        userView.addGestureRecognizer(userTap)
        
        balanceView.userInteractionEnabled = true
        let balanceTap = UITapGestureRecognizer(target: self, action: #selector(gotoBalance(_:)))
        balanceView.addGestureRecognizer(balanceTap)
        
        commentView.userInteractionEnabled = true
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(gotoComment(_:)))
        commentView.addGestureRecognizer(commentTap)
        
        courseView.userInteractionEnabled = true
        let courseTap = UITapGestureRecognizer(target: self, action: #selector(gotoCourse(_:)))
        courseView.addGestureRecognizer(courseTap)
        
        gonggaoView.userInteractionEnabled = true
        let gonggaoTap = UITapGestureRecognizer(target: self, action: #selector(gotoGonggao(_:)))
        gonggaoView.addGestureRecognizer(gonggaoTap)
        
    }
    
    func gotoUser(sender: UITapGestureRecognizer) {
        let userGeneralDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralDetailViewController")as! UserGeneralDetailViewController
        userGeneralDetailViewController.userType = 1
        userGeneralDetailViewController.userClub = self.userinfo
        self.navigationController?.pushViewController(userGeneralDetailViewController, animated: true)
    }
    
    func gotoBalance(sender: UITapGestureRecognizer) {
        let moneyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MoneyViewController")as! MoneyViewController
        self.navigationController?.pushViewController(moneyViewController, animated: true)
    }
    
    func gotoComment(sender: UITapGestureRecognizer) {
        let remarkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RemarkViewController")as! RemarkViewController
        self.navigationController?.pushViewController(remarkViewController, animated: true)
    }
    
    func gotoCourse(sender: UITapGestureRecognizer) {
        let courseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubCourseViewController")as! ClubCourseViewController
        courseViewController.club = self.userinfo
        self.navigationController?.pushViewController(courseViewController, animated: true)
    }
    
    func gotoGonggao(sender: UITapGestureRecognizer) {
        let publishViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PublishViewController")as! PublishViewController
        publishViewController.club = self.userinfo
        publishViewController.userType = 1
        self.navigationController?.pushViewController(publishViewController, animated: true)
    }
    
    @IBAction func gotoSet(sender: AnyObject) {
        let setTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetTableViewController") as! SetTableViewController
        self.navigationController?.pushViewController(setTableViewController, animated: true)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
