//
//  MyOrderListTableViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/11/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import MBProgressHUD


class MyOrderListTableViewController: UITableViewController {

    var userInfo: UserInfo?
    var eoList = [EoList]()
    var mPage = 1
    var mSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: OrderListTableViewCell.id)
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(downPullRefresh))
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(upPullRefresh))
        
        updateList()
        
    }
    
    
    func updateList() {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func downPullRefresh(){
        mPage = 1
        postList()
    }
    
    func upPullRefresh(){
        mPage += 1
        postList()
    }
    
    func postList(){
        
        let url = getEOListForNormalUser
        
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let parameters =  [ "username":username, "password":password,"userType":userType,  "pageNo":mPage ,"pageSize":mSize] as [String : AnyObject]
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        doRequest(url, parameters: parameters, praseMethod: praseList)
        
    }
    
    func praseList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            if json["eoList"].array!.count == 0{
                if self.tableView.mj_footer.isRefreshing(){
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.eoList = []
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
                return
            }
            
            var tempList = [EoList]()
            
            for index in 0...json["eoList"].array!.count-1 {
                let list = EoList(json: json["eoList"].array![index])
                tempList.append(list)
            }
            
            if self.tableView.mj_header.isRefreshing(){
                self.eoList = tempList
            }else{
                if eoList.count >= 50 {
                    eoList.removeFirst(10)
                }
                self.eoList += tempList
            }
            self.tableView.reloadData()
            
        }else{
            NSLog("失败")
        }
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eoList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(OrderListTableViewCell.id, forIndexPath: indexPath) as! OrderListTableViewCell
        cell.dataBind(self.eoList[indexPath.row])
        cell.eoButton.tag = indexPath.row
        cell.eoButton.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
        if self.eoList[indexPath.row].expOrder?.status == 1 {
            cell.eoButton.addTarget(self, action: #selector(gotoBuy(_:)), forControlEvents: .TouchUpInside)
        } else if self.eoList[indexPath.row].expOrder?.status == 2 {
            cell.eoButton.addTarget(self, action: #selector(gotoRemark(_:)), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    func gotoRemark(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddRemarkViewController") as! AddRemarkViewController
        vc.isEoList = true
        vc.eoList = self.eoList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoBuy(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        vc.payType = .EoList
        vc.eoList = self.eoList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
