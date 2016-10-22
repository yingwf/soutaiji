//
//  CoachDetailViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/30.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoachDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let detailCell = "CoachDetailTableViewCell"
    let titleCell = "ClubTitleTableViewCell"
    let appraiseCell = "ClubAppraiseTableViewCell"
    let footerCell = "FooterTableViewCell"
    let contentCell = "ContentTableViewCell"
    let courseCell = "CourseTableViewCell"
    let qualificationCell = "CoachQualificationTableViewCell"
    let honorCell = "HonorTableViewCell"
    var headView = YYScrollView()
    var coachInfo: CoachInfo?
    var teaching: Teaching?
    var lessons = [LessonInfo]()
    
    var selectCoachMode = false

    @IBOutlet weak var selectCoachButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        
        selectCoachButton.hidden = !selectCoachMode
        
        self.tableView.separatorStyle = .None
        self.tableView.scrollsToTop = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "CoachDetailTableViewCell", bundle: nil), forCellReuseIdentifier: detailCell)
        self.tableView.registerNib(UINib(nibName: "ClubTitleTableViewCell", bundle: nil), forCellReuseIdentifier: titleCell)
        self.tableView.registerNib(UINib(nibName: "ClubAppraiseTableViewCell", bundle: nil), forCellReuseIdentifier: appraiseCell)
        self.tableView.registerNib(UINib(nibName: "FooterTableViewCell", bundle: nil), forCellReuseIdentifier: footerCell)
        self.tableView.registerNib(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: contentCell)
        self.tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: courseCell)
        self.tableView.registerNib(UINib(nibName: "CoachQualificationTableViewCell", bundle: nil), forCellReuseIdentifier: qualificationCell)
        self.tableView.registerNib(UINib(nibName: "HonorTableViewCell", bundle: nil), forCellReuseIdentifier: honorCell)
        self.tableView.registerNib(UINib(nibName: "WebTableViewCell", bundle: nil), forCellReuseIdentifier: WebTableViewCell.id)

        self.tableView.estimatedRowHeight = 130.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        headView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 176)
        headView.delegate = self
        self.tableView.tableHeaderView = headView
        
        praseClubInfo()
        getLessons()

        
//        let url = getClubInfo
//        let parameters =  ["clubId": clubId] as [String: AnyObject]
//        doRequest(url, parameters: parameters, praseMethod: praseClubInfo)
    }
    
    func praseClubInfo() {
        var imageArray = [String]()
        
        if let pic = coachInfo?.pic1 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = coachInfo?.pic2 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = coachInfo?.pic3 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = coachInfo?.pic4 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = coachInfo?.pic5 where !pic.isEmpty {
            imageArray.append(pic)
        }
        self.headView.delegate = self
        self.headView.initWithImgs(imageArray)
        
        self.navigationItem.title = coachInfo?.name
        
        self.tableView.reloadData()
    }
    
    
    func getLessons() {
        
        guard let jlId = coachInfo?.id else {
            return
        }
        let url = getJlLessonList
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  [ "username":username, "password":password,"userType":userType,  "pageNo":1 ,"pageSize":100, "jlId":jlId ] as [String : AnyObject]
        
        doRequest(url, parameters: parameters, praseMethod: praseLessonList)
    }
    
    func praseLessonList(json: SwiftyJSON.JSON){
        if json["success"].boolValue, let list = json["jlLessonList"].array where list.count > 0 {
            lessons = list.map { LessonInfo(json: $0) }
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(detailCell, forIndexPath: indexPath) as! CoachDetailTableViewCell
            if coachInfo?.renzheng == 1 {
                cell.renzheng.text = "已认证"
            } else {
                cell.renzheng.text = "未认证"
            }
            cell.liupai.text = coachInfo?.liupai
            if let visit = coachInfo?.visitCount {
                cell.visit.text = String(visit)
            } else {
                cell.visit.text = ""
            }
            cell.waiyu.text = coachInfo?.waiyu
            cell.sex.text = coachInfo?.sex
            if let id = self.coachInfo?.szShi {
                if let city = cityList[id]{
                    cell.city.text = city.name
                }
            }
            if let age = coachInfo?.age {
                cell.age.text = String(age)
            } else {
                cell.age.text = ""
            }
            if let price = coachInfo?.money {
                cell.price.text = String(price)  + "元/小时"
            } else {
                cell.price.text = ""
            }
            
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "教练公告"
                cell.selectionStyle = .None
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(contentCell , forIndexPath: indexPath) as! ContentTableViewCell
            cell.dataBind(coachInfo?.publish ?? "")
            cell.selectionStyle = .None
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "教练课程"
                cell.more.hidden = false
                cell.selectionStyle = .None
                cell.more.userInteractionEnabled = true
                cell.more.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLessonList)))
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(CourseTableViewCell.id, forIndexPath: indexPath) as! CourseTableViewCell
                cell.selectionStyle = .Default
                cell.dataBindwithCoach(lessons[indexPath.row - 1], coach: coachInfo!)
                return cell
            }
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "教练介绍"
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(WebTableViewCell.id, forIndexPath: indexPath) as! WebTableViewCell
                cell.dataBind(coachInfo?.content ?? "")
                cell.selectionStyle = .None
//                let cell = tableView.dequeueReusableCellWithIdentifier(contentCell, forIndexPath: indexPath) as! ContentTableViewCell
//                cell.content.text = coachInfo?.content
                return cell
            }
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "视频展示"
                cell.selectionStyle = .None
                return cell
            }
        //todo:add video
            
        case 5:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "荣誉资质"
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(coachInfo?.ry1)
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(coachInfo?.ry2)
                return cell
            }else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(coachInfo?.ry3)
                return cell
            }else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(coachInfo?.ry4)
                return cell
            }
            
        case 6:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "教练评价"
                cell.selectionStyle = .None
                return cell
            }
            
        case 7:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(footerCell, forIndexPath: indexPath) as! FooterTableViewCell
                cell.selectionStyle = .None
                return cell
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1 :
            if coachInfo?.publish != nil && coachInfo!.publish!.isEmpty {
                return 0
            } else {
                return 2
            }
            
        case 2:
            if lessons.count > 0 {
                return min(lessons.count, 2) + 1
            }
            return 0
            
        case 3:
            if coachInfo!.content!.isEmpty {
                return 0
            }
            return 2
            
        case 4:
            return 1
            
        case 5:
            var count = 0
            for ry in [coachInfo?.ry1,coachInfo?.ry2,coachInfo?.ry3,coachInfo?.ry4] {
                if let clubry = ry where !clubry.isEmpty {
                    count += 1
                } else {
                    break
                }
            }
            if count > 0 {
                count += 1
            }
            return count
            
        default:
            return 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = UIScreen.mainScreen().bounds.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 5))
        if section == 7 {
            view.backgroundColor = UIColor.clearColor()
        } else {
            view.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        
        return view
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard  indexPath.section == 2 && indexPath.row > 0 else {
            return
        }
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailViewController") as! CourseDetailViewController
        vc.lesson = lessons[indexPath.row - 1]
        vc.coach = coachInfo
        vc.userType = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoPay(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        vc.productName = "\(coachInfo!.name!)（教学指正）"
        vc.orderFee = self.teaching?.fee
        vc.payType = .Teaching
        vc.coach = self.coachInfo
        vc.teaching = self.teaching
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLessonList() {
        let courseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CourseViewController")as! CourseViewController
        courseViewController.coach = coachInfo
        self.navigationController?.pushViewController(courseViewController, animated: true)
        
        
    }
    
    
}
