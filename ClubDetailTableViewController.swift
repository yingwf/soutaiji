//
//  ClubDetailViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/30.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClubDetailTableViewController: UITableViewController {

    let detailCell = "ClubDetailTableViewCell"
    let titleCell = "ClubTitleTableViewCell"
    let appraiseCell = "ClubAppraiseTableViewCell"
    let footerCell = "FooterTableViewCell"
    let contentCell = "ContentTableViewCell"
    let courseCell = "CourseTableViewCell"
    let qualificationCell = "CoachQualificationTableViewCell"
    let honorCell = "HonorTableViewCell"
    var clubId = 2
    var headView = YYScrollView()
    var clubInfo: ClubInfo?
    var lessons = [LessonInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        self.tableView.registerNib(UINib(nibName: "ClubDetailTableViewCell", bundle: nil), forCellReuseIdentifier: detailCell)
        self.tableView.registerNib(UINib(nibName: "ClubTitleTableViewCell", bundle: nil), forCellReuseIdentifier: titleCell)
        self.tableView.registerNib(UINib(nibName: "ClubAppraiseTableViewCell", bundle: nil), forCellReuseIdentifier: appraiseCell)
        self.tableView.registerNib(UINib(nibName: "FooterTableViewCell", bundle: nil), forCellReuseIdentifier: footerCell)
        self.tableView.registerNib(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: contentCell)
        self.tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: courseCell)
        self.tableView.registerNib(UINib(nibName: "CoachQualificationTableViewCell", bundle: nil), forCellReuseIdentifier: qualificationCell)
        self.tableView.registerNib(UINib(nibName: "HonorTableViewCell", bundle: nil), forCellReuseIdentifier: honorCell)
        
        self.tableView.registerNib(UINib(nibName: "WebTableViewCell", bundle: nil), forCellReuseIdentifier: WebTableViewCell.id)
        self.tableView.registerNib(UINib(nibName: "LessonTimeTableViewCell", bundle: nil), forCellReuseIdentifier: LessonTimeTableViewCell.id)
        self.tableView.registerNib(UINib(nibName: "ClubTeacherTableViewCell", bundle: nil), forCellReuseIdentifier: ClubTeacherTableViewCell.id)

        self.tableView.estimatedRowHeight = 130.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        self.tableView.separatorStyle = .None
        self.tableView.scrollsToTop = true
        self.tableView.allowsSelection = true
        
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        headView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 176)
        headView.delegate = self
        self.tableView.tableHeaderView = headView
        
        praseClubInfo()
        
        getLessons()
        
        getRemarkList()
    }
    
    func praseClubInfo() {
        //self.clubInfo = ClubInfo(json: json["userhg"])
        
        var imageArray = [String]()
        
        if let pic = clubInfo?.pic1 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = clubInfo?.pic2 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = clubInfo?.pic3 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = clubInfo?.pic4 where !pic.isEmpty {
            imageArray.append(pic)
        }
        if let pic = clubInfo?.pic5 where !pic.isEmpty {
            imageArray.append(pic)
        }
        self.headView.delegate = self
        self.headView.initWithImgs(imageArray)
        
        self.navigationItem.title = clubInfo?.name
        
        self.tableView.reloadData()
    }
    
    func getRemarkList() {
        guard let hgId = clubInfo?.id else {
            return
        }
        let url = getRemarkListForHg
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  [ "username":username, "password":password,"userType":userType,  "pageNo":1 ,"pageSize":100, "hgId":hgId ] as [String : AnyObject]
        
        doRequest(url, parameters: parameters, praseMethod: praseRemarkList)
    
    }
    
    func praseRemarkList(json: SwiftyJSON.JSON) {
        if json["success"].boolValue, let list = json["remarkList"].array where list.count > 0 {
            //lessons = list.map { LessonInfo(json: $0) }
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
        }
    }
    
    func getLessons() {
        
        guard let hgId = clubInfo?.id else {
            return
        }
        let url = getHgLessonList
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  [ "username":username, "password":password,"userType":userType,  "pageNo":1 ,"pageSize":100, "hgId":hgId ] as [String : AnyObject]
        
        doRequest(url, parameters: parameters, praseMethod: praseLessonList)
    }
    
    func praseLessonList(json: SwiftyJSON.JSON){
        if json["success"].boolValue, let list = json["hgLessonList"].array where list.count > 0 {
            lessons = list.map { LessonInfo(json: $0) }
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(detailCell, forIndexPath: indexPath) as! ClubDetailTableViewCell
            if clubInfo?.renzheng == 1 {
                cell.renzheng.text = "是否认证：已认证"
            } else {
                cell.renzheng.text = "是否认证：未认证"
            }
            if let liupai = clubInfo?.liupai {
                cell.liupai.text = "太极流派：\(liupai)"
            }
            if let visitCount = clubInfo?.userVisitCount {
                cell.visitCount.text = "访问量：\(visitCount)"
            }
            if let waiyu = clubInfo?.waiyu {
                cell.waiyu.text = "外语特长：\(waiyu)"
            }
            if let tel = clubInfo?.tel {
                cell.tel.text = "会馆电话：\(tel)"
            }
            if let address = clubInfo?.address {
                cell.address.text = "会馆地址：\(address)"
            }
            cell.selectionStyle = .None
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆公告"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(contentCell , forIndexPath: indexPath) as! ContentTableViewCell
                cell.dataBind(clubInfo?.publish ?? "")
                cell.selectionStyle = .None
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆课程"
                cell.more.hidden = false
                cell.selectionStyle = .None
                cell.more.userInteractionEnabled = true
                cell.more.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLessonList)))
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(CourseTableViewCell.id, forIndexPath: indexPath) as! CourseTableViewCell
                cell.dataBindwithClub(lessons[indexPath.row - 1], club: clubInfo!)
                return cell
            }
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆上课时间表"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(LessonTimeTableViewCell.id, forIndexPath: indexPath) as! LessonTimeTableViewCell
                cell.setImageViewWithUrl(NSURL(string: clubInfo?.timeTable ?? "")!)
                cell.selectionStyle = .None
                return cell
            }
            
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆介绍"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(WebTableViewCell.id, forIndexPath: indexPath) as! WebTableViewCell
                cell.dataBind(clubInfo?.content ?? "")
                cell.selectionStyle = .None
                return cell
            }
            
        case 5:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆师资"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(ClubTeacherTableViewCell.id, forIndexPath: indexPath) as! ClubTeacherTableViewCell
                cell.dataBind(clubInfo?.jl1photo, name: clubInfo?.jl1name, content: clubInfo?.jl1desc)
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(ClubTeacherTableViewCell.id, forIndexPath: indexPath) as! ClubTeacherTableViewCell
                cell.dataBind(clubInfo?.jl2photo, name: clubInfo?.jl2name, content: clubInfo?.jl2desc)
                cell.selectionStyle = .None
                return cell
            }
            
        case 6:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆荣誉"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(clubInfo?.ry1)
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(clubInfo?.ry2)
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(clubInfo?.ry3)
                cell.selectionStyle = .None
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorTableViewCell
                cell.honorImage.imageFromUrl(clubInfo?.ry4)
                cell.selectionStyle = .None
                return cell
            }
            
        case 7:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! ClubTitleTableViewCell
                cell.title.text = "会馆评价"
                cell.more.hidden = true
                cell.selectionStyle = .None
                return cell
            }
            
        case 8:
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
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 9
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            if clubInfo!.publish!.isEmpty {
                return 0
            } else {
                return 2
            }
            
        case 2:
            if lessons.count == 0 {
                return 0
            }
            return min(lessons.count, 2) + 1
            
        case 3:
            if clubInfo!.timeTable!.isEmpty {
                return 0
            } else {
                return 2
            }
            
        case 4:
            if clubInfo!.content!.isEmpty {
                return 0
            } else {
                return 2
            }
            
        case 5:
            var count = 0
            if clubInfo?.jl1photo != "" ||  clubInfo?.jl1name != "" {
                count += 1
            }
            if clubInfo?.jl2photo != "" ||  clubInfo?.jl2name != "" {
                count += 1
            }
            if count > 0 {
                count += 1
            }
            return count
            
        case 6:
            var count = 0
            for ry in [clubInfo?.ry1,clubInfo?.ry2,clubInfo?.ry3,clubInfo?.ry4] {
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
            break
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 8 {
            return 0
        }
        return 5
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 8 {
            return nil
        }
        let width = UIScreen.mainScreen().bounds.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 5))
        view.backgroundColor = UIColor(hex: 0xEFEFEF)
        return view
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard  indexPath.section == 2 && indexPath.row > 0 else {
            return
        }
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailViewController") as! CourseDetailViewController
        vc.lesson = lessons[indexPath.row - 1]
        vc.club = clubInfo
        vc.userType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLessonList() {
        let courseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubCourseViewController")as! ClubCourseViewController
        courseViewController.club = clubInfo
        self.navigationController?.pushViewController(courseViewController, animated: true)
        
        
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 44
//        
//    }
    

}
