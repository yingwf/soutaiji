//
//  UserGeneralViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/9.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class UserGeneralViewController: UIViewController {
    @IBOutlet weak var userDetailLabel: UIView!

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var yue: UILabel!
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var vipView: UIView!

    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.userInfo?.photo {
            self.photo.sd_setImageWithURL(NSURL(string: image))
        }
        self.name.text = self.userInfo?.name
        self.userName.text = self.userInfo?.user_Name
        if let balance = self.userInfo?.balance {
            self.yue.text = "\(balance)"
        }
        
        userDetailLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDetail))
        userDetailLabel.addGestureRecognizer(tap)
        
        GeneralUserInfoStore = self.userInfo

        balanceView.userInteractionEnabled = true
        let balanceTap = UITapGestureRecognizer(target: self, action: #selector(gotoBalance(_:)))
        balanceView.addGestureRecognizer(balanceTap)
        
        commentView.userInteractionEnabled = true
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(gotoComment(_:)))
        commentView.addGestureRecognizer(commentTap)
        
        vipView.userInteractionEnabled = true
        let vipTap = UITapGestureRecognizer(target: self, action: #selector(gotoBuyVIP(_:)))
        vipView.addGestureRecognizer(vipTap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userDetail(){
        let userGeneralDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralDetailViewController")as! UserGeneralDetailViewController
        userGeneralDetailViewController.userType = 0
        userGeneralDetailViewController.userGeneral = self.userInfo
        self.navigationController?.pushViewController(userGeneralDetailViewController, animated: true)
    }

    @IBAction func gotoSet(sender: AnyObject) {
        let setTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetTableViewController") as! SetTableViewController
        self.navigationController?.pushViewController(setTableViewController, animated: true)
    }
    
    func gotoBalance(sender: UITapGestureRecognizer) {
        let moneyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MoneyViewController")as! MoneyViewController
        self.navigationController?.pushViewController(moneyViewController, animated: true)
    }
    
    func gotoComment(sender: UITapGestureRecognizer) {
        let remarkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RemarkViewController")as! RemarkViewController
        self.navigationController?.pushViewController(remarkViewController, animated: true)
    }


    func gotoBuyVIP(sender: UITapGestureRecognizer) {
        let buyContactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BuyContactViewController") as! BuyContactViewController
        self.navigationController?.pushViewController(buyContactViewController, animated: true)
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
