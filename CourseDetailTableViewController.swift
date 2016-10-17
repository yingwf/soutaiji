//
//  CourseDetailTableViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/21.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

protocol UpdateLessonInfoDelegate {
    func updateLessonInfo(lesson: LessonInfo)
}

class CourseDetailTableViewController: UITableViewController, UpdateLessonInfoDelegate {

    
    var lesson: LessonInfo?
    var lessons = [LessonInfo]()
    var coach: CoachInfo?
    var club: ClubInfo?
    var userType = 2 //default is coach
    
    var delegate: UpdateLessonListDelegate?
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var classCount: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var detailTime: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var classDescription: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var lessonTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "CoachQualificationTableViewCell", bundle: nil), forCellReuseIdentifier: CoachQualificationTableViewCell.identifier)
        tableView.registerNib(UINib(nibName: "PlatformGuaranteeTableViewCell", bundle: nil), forCellReuseIdentifier: PlatformGuaranteeTableViewCell.identifier)
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseTableViewCell.id)
        tableView.registerNib(UINib(nibName: "FooterTableViewCell", bundle: nil), forCellReuseIdentifier: FooterTableViewCell.identifier)
        self.setBackButton()
        self.initData()
    }
    
    func initData() {
        headImage.sd_setImageWithURL(NSURL(string: lesson?.pic ?? ""))
        name.text = lesson?.name
        price.text = "￥\(lesson?.price ?? 0)"
        classCount.text = "\(lesson?.classCount ?? 0)"
        
        if let startDateString = lesson?.startDate as? NSString, let endDateString = lesson?.endDate as? NSString {
            let startDateSub = startDateString.length >= 10 ? startDateString.substringToIndex(10) : startDateString
            let endDateSub = endDateString.length >= 10 ? endDateString.substringToIndex(10) : endDateString
            startDate.text = "\(startDateSub) - \(endDateSub)"
        }
        
        
        detailTime.text = lesson?.detailTime
        address.text = lesson?.location
        classDescription.text = lesson?.description
        classDescription.sizeToFit()
        
        moreLabel.userInteractionEnabled = true
        
        if userType == 1 {
            lessonTitle.text = "会馆其他课程"
            moreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoClubLessonList)))
        } else {
            lessonTitle.text = "教练其他课程"
            moreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoCoachLessonList)))
        }
//        let view = UIView(frame: CGRect(x: 0, y: screenHeight - 40, width: screenWidth, height: 40))
//        view.backgroundColor = UIColor.yellowColor()
//        self.view.addSubview(view)

    }

    
    func updateLessonInfo(lesson: LessonInfo) {
        self.lesson = lesson
        initData()
    }
    
    
    
    func gotoCoachLessonList() {
        let courselist = self.storyboard?.instantiateViewControllerWithIdentifier("CourseViewController") as! CourseViewController
        courselist.coach = self.coach
        
        self.navigationController?.pushViewController(courselist, animated: true)
    }
    
    func gotoClubLessonList() {
        let courselist = self.storyboard?.instantiateViewControllerWithIdentifier("ClubCourseViewController") as! ClubCourseViewController
        courselist.club = self.club
        
        self.navigationController?.pushViewController(courselist, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - Table view data source
extension CourseDetailTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
        case (1,2):
            let cell = tableView.dequeueReusableCellWithIdentifier(CoachQualificationTableViewCell.identifier) as? CoachQualificationTableViewCell
            if userType == 2 {
                cell!.dataBind(self.coach!)
            } else {
                cell!.dataBindWithFields(lesson?.jl1Pic, coachName: lesson?.jl1Name, coachDesc: lesson?.jl1Desc)
            }
            
            return cell!
            
        case (1,3):
            let cell = tableView.dequeueReusableCellWithIdentifier(CoachQualificationTableViewCell.identifier) as? CoachQualificationTableViewCell
            if userType == 2 {
                cell!.dataBind(self.coach!)
            } else {
                cell!.dataBindWithFields(lesson?.jl2Pic, coachName: lesson?.jl2Name, coachDesc: lesson?.jl2Desc)
            }
            
            return cell!
        case (4,2):
            let cell = tableView.dequeueReusableCellWithIdentifier(PlatformGuaranteeTableViewCell.identifier) as? PlatformGuaranteeTableViewCell
            cell?.selectionStyle = .None
            return cell!
        case (5,2 ... lessons.count + 2):
            let cell = tableView.dequeueReusableCellWithIdentifier(CourseTableViewCell.id) as? CourseTableViewCell
            if userType == 2 {
                cell?.dataBindwithCoach(lessons[indexPath.row - 2], coach: coach!)
            } else {
                cell?.dataBindwithClub(lessons[indexPath.row - 2], club: club!)
            }
            return cell!
        case (6,1):
            let cell = tableView.dequeueReusableCellWithIdentifier(FooterTableViewCell.identifier) as? FooterTableViewCell
            cell!.initUI()
            cell?.selectionStyle = .None
            return cell!
        default:
            break
        }

        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func countCoachCount() -> Int {
        if userType == 2 {
            return 1
        }
        var count = 0
        guard let lesson = lesson else {
            return 0
        }
        if !lesson.jl1Desc!.isEmpty || !lesson.jl1Name!.isEmpty || !lesson.jl1Pic!.isEmpty {
            count += 1
        }
        if !lesson.jl2Desc!.isEmpty || !lesson.jl2Name!.isEmpty || !lesson.jl2Pic!.isEmpty {
            count += 1
        }
        return count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return countCoachCount() + 2
        case 4:
            return 3
        case 5:
            return lessons.count + 2
        case 6:
            return 2
        default:
            break
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 {
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: indexPath.section))
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (1,2...3):
            return 72
        case (4,2):
            return 88
        case (5,2 ... lessons.count + 2):
            return 97
        case (6,1):
            return 93
        default:
            break
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: false)
        if userType == 2 {
            if indexPath.section == 5 && indexPath.row >= 2 {
                let courseDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailTableViewController") as! CourseDetailTableViewController
                courseDetailTableViewController.coach = self.coach
                courseDetailTableViewController.lesson = self.lessons[indexPath.row - 2]
                self.lessons.append(self.lesson!)
                let otherLessons = self.lessons.filter { $0.id != self.lessons[indexPath.row - 2].id }
                
                courseDetailTableViewController.lessons = otherLessons
                courseDetailTableViewController.userType = 2
                
                self.navigationController?.pushViewController(courseDetailTableViewController, animated: true)
                
            }
            return
        }
        
        if indexPath.section == 5 && indexPath.row >= 2 {
            let courseDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailTableViewController") as! CourseDetailTableViewController
            courseDetailTableViewController.club = self.club
            courseDetailTableViewController.lesson = self.lessons[indexPath.row - 2]
            self.lessons.append(self.lesson!)
            let otherLessons = self.lessons.filter { $0.id != self.lessons[indexPath.row - 2].id }
            
            courseDetailTableViewController.lessons = otherLessons
            courseDetailTableViewController.userType = 1
            
            self.navigationController?.pushViewController(courseDetailTableViewController, animated: true)
            
        }
        
    }
    
    @IBAction func deleteCoachLesson(sender: AnyObject) {
        
        var url = deleteJlLesson
        if self.userType == 1 {
            url = deleteHgLesson
        }
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  ["username":username,"password":password,"userType":userType, "lessonId": self.lesson!.id!] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseModifyResult)
        
    }
    
    func praseModifyResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            let alertView = UIAlertController(title: "提醒", message: "项目/课程已删除", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {
                action in
                self.delegate?.updateLessonList()
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }else{
            let alertView = UIAlertController(title: "提醒", message: "项目/课程删除失败", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func modifyCoachLesson(sender: AnyObject) {
        if userType == 2 {
            let coachLessonCreateTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachLessonCreateTableViewController") as! CoachLessonCreateTableViewController
            coachLessonCreateTableViewController.coach = self.coach
            coachLessonCreateTableViewController.lesson = self.lesson
            coachLessonCreateTableViewController.isModify = true
            
            coachLessonCreateTableViewController.delegate = self
            
            self.navigationController?.pushViewController(coachLessonCreateTableViewController, animated: true)
            return
        }

        let clubLessonCreateTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubLessonCreateTableViewController") as! ClubLessonCreateTableViewController
        clubLessonCreateTableViewController.club = self.club
        clubLessonCreateTableViewController.lesson = self.lesson
        clubLessonCreateTableViewController.isModify = true
        
        clubLessonCreateTableViewController.delegate = self
        
        self.navigationController?.pushViewController(clubLessonCreateTableViewController, animated: true)
        
    }
    


}

