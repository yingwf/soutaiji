//
//  QuestionToDoViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyJSON


class QuestionToDoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var url: String?
    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nobodyLabel: UILabel!
    
    @IBOutlet weak var movieView: UIView!
    
    var teaching: Teaching?
    var coachInfos = [CoachInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.player = AVPlayer(URL: NSURL(string: self.teaching?.video ?? "")!)
        playerController.player = player
        self.addChildViewController(playerController)
        self.movieView.addSubview(playerController.view)
        playerController.view.frame = self.movieView.bounds
        nobodyLabel.hidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "CoachTableViewCell", bundle: nil), forCellReuseIdentifier: CoachTableViewCell.id)
        
        tableView.registerNib(UINib(nibName: "QuestionToDoTableViewCell", bundle: nil), forCellReuseIdentifier: QuestionToDoTableViewCell.id)
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        postShowOrder()
        self.setBackButton()
        
    }
    
    func postShowOrder(){
        guard let id = teaching?.id else {
            return
        }
        let url = getTeachingApplication
        let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "pageNo":0 , "pageSize":100, "teachId": id ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseResult)
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        guard let coaches = json["coaches"].array where coaches.count > 0 else {
            self.nobodyLabel.hidden = false
            self.view.bringSubviewToFront(nobodyLabel)
            return
        }
        
        self.coachInfos = coaches.flatMap{ CoachInfo(json: $0) }
        self.tableView.reloadData()
    
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.coachInfos.count == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return self.coachInfos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(QuestionToDoTableViewCell.id, forIndexPath: indexPath) as! QuestionToDoTableViewCell
            cell.dataBind(teaching!)
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(CoachTableViewCell.id, forIndexPath: indexPath) as! CoachTableViewCell
        cell.photo.sd_setImageWithURL(NSURL(string:self.coachInfos[indexPath.row].pic1 ?? ""))
        cell.name.text = self.coachInfos[indexPath.row].name
        cell.name.sizeToFit()
        cell.liupai.text = self.coachInfos[indexPath.row].liupai
        cell.teaching.text = String(self.coachInfos[indexPath.row].fuwu ?? 0)
        cell.pingjia.text = "0"
        cell.renzheng.hidden = !(self.coachInfos[indexPath.row].renzheng == 1)
        cell.renzheng.layer.borderColor = SYSTEMCOLOR.CGColor
        cell.renzheng.layer.borderWidth = 0.5
        
        return cell
    }

    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let  uiView = UIView(frame : CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: screenWidth - 8, height: 30))
        label.text = "教练申请 \(self.coachInfos.count)"
        label.textColor = SYSTEMCOLOR
        label.font = UIFont.systemFontOfSize(14)
        uiView.backgroundColor = UIColor.whiteColor()

        uiView.addSubview(label)
        
        return uiView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let  uiView = UIView(frame : CGRect(x: 0, y: 0, width: screenWidth, height: 5))
        uiView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return uiView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        return 5
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let coachDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachDetailViewController")as! CoachDetailViewController
        coachDetailViewController.coachInfo = self.coachInfos[indexPath.row]
        coachDetailViewController.selectCoachMode = true
        coachDetailViewController.teaching = teaching
        
        self.navigationController?.pushViewController(coachDetailViewController, animated: true)
        
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
