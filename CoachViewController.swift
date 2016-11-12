//
//  CoachViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/30.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh


class CoachViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,YYDropDownMenuDelegate {

    var coachInfoArray = [CoachInfo]()
    
    var titles = ["城市","流派","认证","其他"]
    var options:[AnyObject] = ["city",["不限","武式","和式","陈式","孙式","武当","杨式","洪式","赵堡","吴式","其他流派"],["不限","已认证","未认证"],"other" ]
    
    let sexs = ["不限","男","女"]
    let ages = ["不限","20-29","30-49","50以上"]
    let languages = ["不限","英语","日语","韩语","法语","德语","俄语","西班牙语","意大利语","阿拉伯语"]
    
    var sex: String?
    var age: Int?
    var waiyu: String?
    var liupai: String?
    var appCity: Int?
    var renzheng: Int?
    var mPage = 1
    var mSize = 10
    private let reuseIdentifier = "ClubCell"
    var headView = YYDropDownMenu()
    var isSearch = false
    let searchLayout = UICollectionViewFlowLayout()

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(UINib(nibName: "CoachListCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.registerNib(UINib(nibName: "CoachSearchCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CoachSearchCollectionViewCell.id)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsetsMake(7, 7, 0, 7)
        let width = UIScreen.mainScreen().bounds.width/2 - 10
        let height = width * 0.63 + 74
        layout.itemSize = CGSize(width: width, height: height)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        searchLayout.scrollDirection = .Vertical
        searchLayout.minimumInteritemSpacing = 0
        searchLayout.minimumLineSpacing = 0
        searchLayout.sectionInset = UIEdgeInsetsMake(1, 7, 7, 1)
        searchLayout.itemSize = CGSize(width: screenWidth, height: 64)
        
        headView.frame = CGRect(x: 0, y: 64, width: UIScreen.mainScreen().bounds.width, height: 44)
        
//        let cityViewController = CFCityPickerVC()
//        cityViewController.cityModels = cityParse()
//        cityViewController.hotCities = hotCities
//        options.append(cityViewController)
        
        headView.titles = titles
        headView.options = options
        headView.delegate = self
        headView.parentVC = self
        
        headView.show()
        
        self.view.addSubview(headView)
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.pagingEnabled = false
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(downPullRefresh))
        header.lastUpdatedTimeLabel?.hidden = true
        self.collectionView.mj_header = header
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(upPullRefresh))
        
        self.collectionView.mj_header.beginRefreshing()
        //postClubList()
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
    
    
    func praseCoachList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            if json["userjlList"].array!.count == 0{
                if self.collectionView.mj_footer.isRefreshing(){
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.coachInfoArray = []
                    self.collectionView.reloadData()
                    self.collectionView.mj_header.endRefreshing()
                    self.collectionView.mj_footer.endRefreshing()
                }
                return
            }
            
            var tempList = [CoachInfo]()
            
            for index in 0...json["userjlList"].array!.count-1 {
                let coachInfo = CoachInfo(json: json["userjlList"].array![index])
                tempList.append(coachInfo)
            }
            
            if self.collectionView.mj_header.isRefreshing(){
                self.coachInfoArray = tempList
            }else{
                if coachInfoArray.count >= 50 {
                    coachInfoArray.removeFirst(10)
                }
                self.coachInfoArray += tempList
            }
            self.collectionView.reloadData()
            
        }else{
            NSLog("失败")
        }
        self.collectionView.mj_header.endRefreshing()
        self.collectionView.mj_footer.endRefreshing()
    }
    
    
    func dropDownMenuSelect(currentMenuIndex: Int, currentOptionIndex: Int, otherIndex: NSArray?){
        
        if !isSearch {
            isSearch = true
            self.collectionView.collectionViewLayout = self.searchLayout
        }
        
        if let other = otherIndex as? [Int] {
            if other[0] > 0 {
                self.sex = self.sexs[other[0]]
            } else {
                self.sex = nil
            }
            
            if other[1] > 0 {
                switch other[1] {
                case 1:
                    self.age = 2
                case 2:
                    self.age = 3
                case 3:
                    self.age = 5
                default:
                    break
                }
            } else {
                self.age = nil
            }
            
            if other[2] > 0 {
                self.waiyu = self.languages[other[2]]
            } else {
                self.waiyu = nil
            }
            
            self.collectionView.mj_header.beginRefreshing()
            //postClubList()
            return
        }
        
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
                break
            }
        }
        self.collectionView.mj_header.beginRefreshing()
        //postClubList()
    }
    
    func postClubList(){
        
        let url = getCoachList
        var parameters =  ["pageNo":mPage ,"pageSize":mSize] as [String: AnyObject]
        if self.liupai != nil{
            parameters["liupai"] = self.liupai
        }
        if self.renzheng != nil{
            parameters["renzheng"] = self.renzheng
        }
        if self.appCity != nil{
            parameters["appCity"] = self.appCity
        }
        if self.sex != nil{
            parameters["sex"] = self.sex
        }
        if self.age != nil{
            parameters["age"] = self.age
        }
        if self.waiyu != nil{
            parameters["waiyu"] = self.waiyu
        }
        
        doRequest(url, parameters: parameters, praseMethod: praseCoachList)
        
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
        return self.coachInfoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if isSearch {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CoachSearchCollectionViewCell.id, forIndexPath: indexPath) as! CoachSearchCollectionViewCell
            cell.setData(self.coachInfoArray[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CoachListCollectionViewCell
        
        cell.photo.image = nil
        cell.photo.imageFromUrl(self.coachInfoArray[indexPath.row].pic1)
        cell.name.text = self.coachInfoArray[indexPath.row].name
        
        if let liupai = self.coachInfoArray[indexPath.row].liupai {
            cell.liupai.text = "流派:\(liupai)"
        }else {
            cell.liupai.text = "流派:"
        }
        
        if let id = self.coachInfoArray[indexPath.row].appCity {
            if let city = cityList[id]{
                cell.city.text = "城市:\(city.name!)"
            } else {
                cell.city.text = "城市:"
            }
        }
        if let age = self.coachInfoArray[indexPath.row].age {
            cell.age.text = "年龄:\(age)"
        } else {
            cell.age.text = "年龄:"
        }
        
        cell.waiyu.text = "外语特长:\(self.coachInfoArray[indexPath.row].waiyu ?? "无")"
        
        
        if self.coachInfoArray[indexPath.row].renzheng != nil && self.coachInfoArray[indexPath.row].renzheng! == 1{
            cell.renzheng.hidden = false
        }else{
            cell.renzheng.hidden = true
        }
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let coachDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachDetailViewController")as! CoachDetailViewController
        coachDetailViewController.coachInfo = coachInfoArray[indexPath.row]
        self.navigationController?.pushViewController(coachDetailViewController, animated: true)
        
    }
    
}
