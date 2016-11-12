//
//  ClubCourseViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/23.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import MBProgressHUD


class ClubCourseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UpdateLessonListDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    
    var club: ClubInfo?
    var lessons = [LessonInfo]()
    var mPage = 1
    var mSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createButton.hidden = club?.user_Name != userInfoStore.userName
        
        self.setBackButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseTableViewCell.id)
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(downPullRefresh))
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(upPullRefresh))
        
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    func updateLessonList() {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func downPullRefresh(){
        mPage = 1
        postLessonList()
    }
    
    func upPullRefresh(){
        mPage += 1
        postLessonList()
    }
    
    func postLessonList(){
        
        guard let hgId = club?.id else {
            return
        }
        let url = getHgLessonList
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  [ "username":username, "password":password,"userType":userType,  "pageNo":mPage ,"pageSize":mSize, "hgId":hgId ] as [String : AnyObject]
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        doRequest(url, parameters: parameters, praseMethod: praseLessonList)
        
    }
    
    func praseLessonList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            if json["hgLessonList"].array!.count == 0{
                if self.tableView.mj_footer.isRefreshing(){
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.lessons = []
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
                return
            }
            
            var tempList = [LessonInfo]()
            
            for index in 0...json["hgLessonList"].array!.count-1 {
                let lessonInfo = LessonInfo(json: json["hgLessonList"].array![index])
                tempList.append(lessonInfo)
            }
            
            if self.tableView.mj_header.isRefreshing(){
                self.lessons = tempList
            }else{
                if lessons.count >= 50 {
                    lessons.removeFirst(10)
                }
                self.lessons += tempList
            }
            self.tableView.reloadData()
            
        }else{
            NSLog("失败")
        }
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CourseTableViewCell.id, forIndexPath: indexPath) as! CourseTableViewCell
        cell.dataBindwithClub(self.lessons[indexPath.row], club: self.club!)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    @IBAction func createLesson(sender: AnyObject) {
        let clubLessonCreateTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubLessonCreateTableViewController") as! ClubLessonCreateTableViewController
        clubLessonCreateTableViewController.club = self.club
        clubLessonCreateTableViewController.updateListDelegate = self
        self.navigationController?.pushViewController(clubLessonCreateTableViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: false)
        
        let courseDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailTableViewController") as! CourseDetailTableViewController
        courseDetailTableViewController.club = self.club
        courseDetailTableViewController.userType = 1
        courseDetailTableViewController.lesson = self.lessons[indexPath.row]
        let otherLessons = self.lessons.filter { $0.id != self.lessons[indexPath.row].id }
        
        courseDetailTableViewController.lessons = otherLessons
        courseDetailTableViewController.delegate = self
        
        self.navigationController?.pushViewController(courseDetailTableViewController, animated: true)
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
