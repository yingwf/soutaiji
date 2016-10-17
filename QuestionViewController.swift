//
//  QuestionViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import MobileCoreServices
import MJRefresh
import SwiftyJSON

protocol UpdateQuestionInfoDelegate {
    func updateQuestionInfo(teaching: Teaching, index: Int)
}

class QuestionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UpdateQuestionInfoDelegate {
    @IBOutlet var tableView: UITableView!

    var imagePicker = UIImagePickerController()
    var teachings = [Teaching]()

    var mPage = 1
    var mLimite = 10
    var isMine = true
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var newQuestionButton: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    
    
    let questionCellIdentitier = "QuestionTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentDidchange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: questionCellIdentitier)
        tableView.tableFooterView = UIView()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(downPullRefresh))
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(upPullRefresh))
        self.tableView.mj_header.beginRefreshing()
        
        if !userInfoStore.isLogin {
            let navLoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("nav_LoginViewController") as! UINavigationController
            let loginViewController = navLoginViewController.childViewControllers.first as! LoginViewController
            loginViewController.forLoginHint = true
            
            self.navigationController?.presentViewController(navLoginViewController, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        switch userInfoStore.userType {
        case 0:
            segment.hidden = false
            segment.setTitle("我的提问", forSegmentAtIndex: 0)
            segment.setTitle("全部提问", forSegmentAtIndex: 1)
            newQuestionButton.hidden = false
            navigationTitle.hidden = true
        case 1:
            segment.hidden = true
            newQuestionButton.hidden = true
            navigationTitle.hidden = false
            newQuestionButton.hidden = true
            self.navigationItem.title = "全部提问"
            isMine = false
        case 2:
            segment.hidden = false
            segment.setTitle("我的指导", forSegmentAtIndex: 0)
            segment.setTitle("全部提问", forSegmentAtIndex: 1)
            newQuestionButton.hidden = true
            navigationTitle.hidden = true
        default:
            break
        }

    }
    
    func segmentDidchange(segmented: UISegmentedControl){
        let selectedSegmentIndex = segmented.selectedSegmentIndex
        
        if selectedSegmentIndex == 0 {
            isMine = true
        } else  if selectedSegmentIndex == 1 {
            isMine = false
        }
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    //下拉刷新
    func  downPullRefresh(){

        mPage = 1
        postShowOrder()
    }
    //上拉刷新
    func  upPullRefresh(){

        mPage += 1
        postShowOrder()
    }

    func postShowOrder(){
        var url =  getMyTeachingList
        if !isMine {
            url =  getTeachingList
        }
        let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "pageNo":mPage , "pageSize":mLimite ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseResult)
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true, let teachingList = json["teachingList"].array else {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        if teachingList.count == 0 {
            if self.tableView.mj_footer.isRefreshing(){
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.teachings = []
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
            return
        }
        
        let tempList = teachingList.flatMap{ Teaching(json: $0) }
        if self.tableView.mj_header.isRefreshing(){
            self.teachings = tempList
        } else {
            self.teachings += tempList
        }
        self.tableView.reloadData()

        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        
    }

    
    @IBAction func newQuestion(sender: AnyObject) {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        
        let photoAction = UIAlertAction(title: "拍摄视频", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("拍摄")
        }
        
        let choiceAction = UIAlertAction(title: "从手机相册中选择视频", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("相册")
        }
        sheetView.addAction(cancelAction)
        sheetView.addAction(photoAction)
        sheetView.addAction(choiceAction)
        
        self.presentViewController(sheetView, animated: true, completion: nil)

        
    }
    
    func initWithImagePickView(type: NSString){
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true

            switch type{
            case "拍摄":
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.imagePicker.videoMaximumDuration = 60
                self.imagePicker.videoQuality = .Type640x480
                
                if !UIImagePickerController.isSourceTypeAvailable(.Camera){
                    let alertView = UIAlertController(title: "提醒", message: "摄像头不可用，请在设置中打开摄像头权限", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    return
                }
            case "相册":
                self.imagePicker.sourceType = .PhotoLibrary
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            default:
                break
            }
            presentViewController(self.imagePicker, animated: true, completion: nil)
            
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.CompareCaseInsensitive)
        if compareResult == CFComparisonResult.CompareEqualTo {
            
            //系统保存到tmp目录里的视频文件的路径
            let mediaUrl: NSURL = info[UIImagePickerControllerMediaURL] as! NSURL
            //let videoPath = mediaUrl.path

            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("videQuestionViewController")as! videQuestionViewController
            vc.url = mediaUrl
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.teachings.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let status = teachings[indexPath.row].status else {
            return
        }
        let userType = userInfoStore.userType
        switch status {
        case 0:
            if userType == 0 || userType == 1 {
                let questionToDoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionToDoViewController")as! QuestionToDoViewController
                questionToDoViewController.teaching = self.teachings[indexPath.row]
                self.navigationController?.pushViewController(questionToDoViewController, animated: true)
            } else if userType == 2 {
                let coachToDoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachToDoViewController")as! CoachToDoViewController
                coachToDoViewController.teaching = self.teachings[indexPath.row]
                coachToDoViewController.teachingIndex = indexPath.row
                coachToDoViewController.delegate = self
                self.navigationController?.pushViewController(coachToDoViewController, animated: true)
            }

        case 1,2,3:
            let coachTeachingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CoachTeachingViewController")as! CoachTeachingViewController
            coachTeachingViewController.teaching = self.teachings[indexPath.row]
            self.navigationController?.pushViewController(coachTeachingViewController, animated: true)
        default:
            break
        }
    }
    
    func updateQuestionInfo(teaching: Teaching, index: Int) {
        guard index < teachings.count else {
            return
        }
        self.teachings[index] = teaching
        self.tableView.reloadRowsAtIndexPaths([ NSIndexPath(forRow:index, inSection:0) ], withRowAnimation: .Automatic)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(questionCellIdentitier, forIndexPath: indexPath) as! QuestionTableViewCell
        cell.dataBind(self.teachings[indexPath.row], isMine: isMine)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 128
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
