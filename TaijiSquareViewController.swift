//
//  TaijiSquareViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/28.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TaijiSquareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var coachInfoArray = [CoachInfo]()
    var clubInfoArray = [ClubInfo]()
    var clubLabels = [UILabel]()
    var clubImages = [UIImageView]()
    var clubViews = [UIView]()
    
    var coachLabels = [UILabel]()
    var coachImages = [UIImageView]()
    var coachViews = [UIView]()
    
    let screenSize = UIScreen.mainScreen().bounds

    
    var headView = YYScrollView()
    
    let iconCell = "Icon4TableViewCell"
    let listCell = "ClubRecoTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.scrollsToTop = true
        
        self.tableView.registerNib(UINib(nibName: "ClubRecoTableViewCell", bundle: nil), forCellReuseIdentifier: listCell)
        self.tableView.registerNib(UINib(nibName: "Icon4TableViewCell", bundle: nil), forCellReuseIdentifier: iconCell)
        
        
        //self.edgesForExtendedLayout = .None
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        headView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 176)
        headView.delegate = self
        self.tableView.tableHeaderView = headView
        
        //获取滚动图片
        var url = GET_MARQUESS
        doRequest(url, parameters: nil, praseMethod: praseMarquess)


    }
    
    func praseClubForMainpage(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            for index in 0 ..< json["clubs"].array!.count {
                let club = ClubInfo(json: json["clubs"][index])
                self.clubImages[index].sd_setImageWithURL(NSURL(string: club.image ?? ""))
                self.clubLabels[index].text = club.name
                self.clubViews[index].userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(gotoClubDetail(_:)))
                self.clubViews[index].tag = index
                self.clubViews[index].addGestureRecognizer(tap)
                self.clubInfoArray.append(club)
                
            }
        }
    }
    
    func praseCoachForMainpage(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            for index in 0 ..< json["coaches"].array!.count {
                let coachInfo = CoachInfo(json: json["coaches"][index])
                coachInfoArray.append(coachInfo)
                self.coachImages[index].sd_setImageWithURL(NSURL(string: coachInfo.photo ?? ""))
                self.coachLabels[index].text = coachInfo.name
                self.coachViews[index].userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(gotoCoachDetail(_:)))
                self.coachViews[index].tag = index
                self.coachViews[index].addGestureRecognizer(tap)
                
                
            }
        }
        //coachCollectionView?.reloadData()
        
    }

    //获取滚动图片
    func praseMarquess(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            let count = json["marquees"].array!.count
            var imageArray = [String]()

            for index in 0 ... count - 1 {
                let url = json["marquees"].array![index].string!
                imageArray.append(url)
            }
            self.headView.delegate = self
            self.headView.initWithImgs(imageArray)
            
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()

        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(iconCell, forIndexPath: indexPath) as! Icon4TableViewCell
            cell.clubView.userInteractionEnabled = true
            cell.clubView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clubAction)))
            cell.coachView.userInteractionEnabled = true
            cell.coachView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coachAction)))
            cell.mallView.userInteractionEnabled = true
            cell.mallView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vipAction)))
            cell.videoView.userInteractionEnabled = true
            cell.videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shopAction)))
            returnCell = cell

        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(listCell, forIndexPath: indexPath) as! ClubRecoTableViewCell
            cell.title.text = "会馆推介"
            
            cell.more.userInteractionEnabled = true
            cell.more.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clubAction)))
            
            let width = (screenSize.width - 30)/2 //间隔10
            for hangIndex in 0...1 {
                for lieIndex in 0...1 {
                    let view = UIView(frame: CGRect(x: CGFloat(hangIndex) * (width + 10) + 10, y: 41 + (width * 0.8 + 22) * CGFloat(lieIndex), width: width, height: 2 * width + 22))
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width * 0.8))
                    imageView.backgroundColor = UIColor(hex: 0xEFEFF4)
                    let label = UILabel(frame: CGRect(x: 0, y: width * 0.8, width: width, height: 22))
                    label.textAlignment = .Center
                    label.font = UIFont.systemFontOfSize(11)
                    self.clubImages.append(imageView)
                    self.clubLabels.append(label)
                    view.addSubview(label)
                    view.addSubview(imageView)
                    self.clubViews.append(view)
                    cell.contentView.addSubview(view)
                    
                    //获取今日会馆
                    let url = getClubForMainpage
                    let parameters =  ["count":4] as [String: AnyObject]
                    doRequest(url, parameters: parameters, praseMethod: self.praseClubForMainpage)
                }
            }
            
            returnCell = cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(listCell, forIndexPath: indexPath) as! ClubRecoTableViewCell
            cell.title.text = "教练推介"
            cell.more.userInteractionEnabled = true
            cell.more.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coachAction)))
            
            let width = (screenSize.width - 50)/4 //间隔10
            for hangIndex in 0...3 {
                for lieIndex in 0...1 {
                    let view = UIView(frame: CGRect(x: CGFloat(hangIndex) * (width + 10) + 10, y: 41 + (width + 22) * CGFloat(lieIndex), width: width, height: 2 * width + 22))
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
                    imageView.backgroundColor = UIColor(hex: 0xEFEFF4)
                    let label = UILabel(frame: CGRect(x: 0, y: width, width: width, height: 22))
                    label.textAlignment = .Center
                    label.font = UIFont.systemFontOfSize(11)
                    self.coachImages.append(imageView)
                    self.coachLabels.append(label)
                    view.addSubview(label)
                    view.addSubview(imageView)
                    self.coachViews.append(view)
                    cell.contentView.addSubview(view)

                    if self.coachInfoArray.count == 0 {
                        //获取今日推荐教练
                        let url = getCoachForMainpage
                        let parameters =  ["count":8] as [String: AnyObject]
                        doRequest(url, parameters: parameters, praseMethod: praseCoachForMainpage)
                    }
                }
            }
            returnCell = cell
        }
        return returnCell
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let width = UIScreen.mainScreen().bounds.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 8))
        view.backgroundColor = UIColor(red: 0xef/255, green: 0xef/255, blue: 0xef/255, alpha: 1)
        if section == 2{
            view.backgroundColor = UIColor.whiteColor()
        }
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        if indexPath.section == 0{
            rowHeight = 86
        }else if indexPath.section == 1 {
            rowHeight = screenSize.width * 0.8 + 59
        }else if indexPath.section == 2 {
            rowHeight = screenSize.width * 0.5 + 80
        }
        return rowHeight
    }

    func gotoClubDetail(sender: UITapGestureRecognizer){
        guard let tag = sender.view?.tag else {
            return
        }
        let clubViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubDetailTableViewController")as! ClubDetailTableViewController
        clubViewController.clubInfo = clubInfoArray[tag]
        self.navigationController?.pushViewController(clubViewController, animated: true)
    }
    
    func gotoCoachDetail(sender: UITapGestureRecognizer){
        guard let tag = sender.view?.tag else {
            return
        }
        let coachDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachDetailViewController")as! CoachDetailViewController
        coachDetailViewController.coachInfo = coachInfoArray[tag]
        self.navigationController?.pushViewController(coachDetailViewController, animated: true)
    }

    
    func clubAction(){
        let clubViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubViewController")as! ClubViewController
        self.navigationController?.pushViewController(clubViewController, animated: true)
    }
    func coachAction(){
        let coachViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachViewController")as! CoachViewController
        self.navigationController?.pushViewController(coachViewController, animated: true)
    }
    
    func shopAction(){
        let clubViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShopViewController")as! ShopViewController
        self.navigationController?.pushViewController(clubViewController, animated: true)
    }
    
    func vipAction() {
        let vipViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VIPViewController")as! VIPViewController
        self.navigationController?.pushViewController(vipViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
