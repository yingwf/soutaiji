//
//  ClubViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/29.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class ClubViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,YYDropDownMenuDelegate {
    
    var clubInfoArray = [ClubInfo]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    var titles = ["城市","流派","认证"]
    var options:[AnyObject] = ["city", ["不限","武式","和式","陈式","孙式","武当","杨式","洪式","赵堡","吴式","其他流派"],["不限","已认证","未认证"]]
    var liupai: String?
    var appCity: Int?
    var renzheng: Int?
    var mPage = 1
    var mSize = 10
    private let reuseIdentifier = "ClubCell"
    var headView = YYDropDownMenu()
    
    var isOffline = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerNib(UINib(nibName: "ClubCell", bundle:nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        
        layout.sectionInset = UIEdgeInsetsMake(7, 7, 0, 7)
        let width = screenWidth/2 - 10
        let height = width * 0.63 + 45
        layout.itemSize = CGSize(width: width, height: height)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        headView.frame = CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.width, height: 44)
        
        
        headView.titles = titles
        headView.options = options
        headView.delegate = self
                
        headView.show()
        
        self.view.addSubview(headView)
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.pagingEnabled = false
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(downPullRefresh))
        header.lastUpdatedTimeLabel?.hidden = true
        self.collectionView.mj_header = header
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(upPullRefresh))

        self.collectionView.mj_header.beginRefreshing()
    }
    
    override  func backToPrevious(){
        self.headView.hide()
        super.backToPrevious()
    }
    
    func downPullRefresh(){
        mPage = 1
        postClubList()
    }
    
    func upPullRefresh(){
        mPage += 1
        postClubList()
    }
    
    
    func praseClubList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            if json["userhgList"].array!.count == 0{
                if self.collectionView.mj_footer.isRefreshing(){
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.clubInfoArray = []
                    self.collectionView.reloadData()
                    self.collectionView.mj_header.endRefreshing()
                    self.collectionView.mj_footer.endRefreshing()
                }
                return
            }
            
            var tempList = [ClubInfo]()
            
            for index in 0...json["userhgList"].array!.count-1 {
                let clubInfo = ClubInfo(json: json["userhgList"].array![index])
                tempList.append(clubInfo)
            }
            
            if self.collectionView.mj_header.isRefreshing(){
                self.clubInfoArray = tempList
            }else{
                if clubInfoArray.count >= 50 {
                    clubInfoArray.removeFirst(10)
                }
                self.clubInfoArray += tempList
            }
            self.collectionView.reloadData()
            
        }else{
            NSLog("失败")
        }
        self.collectionView.mj_header.endRefreshing()
        self.collectionView.mj_footer.endRefreshing()
    }


    func dropDownMenuSelect(currentMenuIndex: Int, currentOptionIndex: Int, otherIndex: NSArray?){
        if currentOptionIndex > 0 {
            switch currentMenuIndex{
            case 0:
                self.appCity = currentOptionIndex
            case 1:
                self.liupai = (self.options[currentMenuIndex] as! NSArray)[currentOptionIndex] as? String
            case 2:
                if currentOptionIndex == 1 {
                    self.renzheng = 1
                } else {
                    self.renzheng = 0
                }
            default:
                break
            }
        }else{
            switch currentMenuIndex{
            case 0:
                self.appCity = nil
            case 1:
                self.liupai = nil
            case 2:
                self.renzheng = nil
            
            default:
                print("default")
            }
        }
        self.collectionView.mj_header.beginRefreshing()
    }
    
    func postClubList(){
        
        let url = getClubList
        var parameters =  ["pageNo":mPage ,"pageSize":mSize] as [String: AnyObject]
        if let liupai = self.liupai {
            parameters["liupai"] = liupai
        }
        if let renzheng = self.renzheng {
            parameters["renzheng"] = renzheng
        }
        if let appCity = self.appCity {
            parameters["appCity"] = appCity
        }
        
        parameters["offline"] = isOffline

        doRequest(url, parameters: parameters, praseMethod: praseClubList)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.clubInfoArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClubCell

        if let image = self.clubInfoArray[indexPath.row].image {
            cell.imageView.sd_setImageWithURL(NSURL(string: image))
        }
        cell.clubName.text = self.clubInfoArray[indexPath.row].name
        cell.liupai.text = "流派:\(self.clubInfoArray[indexPath.row].liupai ?? "")"
        cell.city.text = "所在城市:\(self.clubInfoArray[indexPath.row].appCityStr ?? "")"
        
        if self.clubInfoArray[indexPath.row].renzheng != nil && self.clubInfoArray[indexPath.row].renzheng! == 1{
            cell.renzheng.hidden = false
        }else{
            cell.renzheng.hidden = true
        }
        
        return cell
    }
    

    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let clubDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClubDetailTableViewController")as! ClubDetailTableViewController
        clubDetailViewController.clubInfo = clubInfoArray[indexPath.item]
        self.navigationController?.pushViewController(clubDetailViewController, animated: true)
        
    }

}
