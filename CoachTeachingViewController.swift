//
//  CoachTeachingViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyJSON
import MBProgressHUD

let toolBarMinHeight: CGFloat = 44.0
let indicatorViewH: CGFloat = 120

let messageOutSound: SystemSoundID = {
    var soundID: SystemSoundID = 10120
    let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageOutgoing", "aiff", nil)
    AudioServicesCreateSystemSoundID(soundUrl, &soundID)
    return soundID
}()


let messageInSound: SystemSoundID = {
    var soundID: SystemSoundID = 10121
    let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageIncoming", "aiff", nil)
    AudioServicesCreateSystemSoundID(soundUrl, &soundID)
    return soundID
}()

class CoachTeachingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nobodyLabel: UILabel!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    var url: String?
    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    var teaching: Teaching?
    var teachingIndex: Int?
    var teachingRecords = [TeachingRecord]()
    var toolBarView: LGToolBarView!
    var shareView: LGShareMoreView!
    var recordIndicatorView: LGRecordIndicatorView!
    var recorder: LGAudioRecorder!
    var toolBarConstranit: NSLayoutConstraint!
    var delegate: DeleteQuestionDelegate?
    
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
        tableView.registerNib(UINib(nibName: "TeachingRecordTableViewCell", bundle: nil), forCellReuseIdentifier: TeachingRecordTableViewCell.id)
        
        tableView.registerNib(UINib(nibName: "QuestionToDoTableViewCell", bundle: nil), forCellReuseIdentifier: QuestionToDoTableViewCell.id)
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
        recordIndicatorView = LGRecordIndicatorView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
        
        toolBarView = LGToolBarView(taget: self, voiceSelector: #selector(voiceClick(_:)), recordSelector: #selector(recordClick(_:)), sendSelector: #selector(sendClick(_:)))
        toolBarView.textView.delegate = self
        view.addSubview(toolBarView)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: toolBarMinHeight))
        toolBarConstranit = NSLayoutConstraint(item: toolBarView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(toolBarConstranit)
        
        
        postShowOrder()
        self.setBackButton()
        
        if userInfoStore.userType == 1 {
            toolBarView.hidden = true
        }
        if userInfoStore.userType != 0 {
            finishButton.hidden = true
        }
        if teaching?.status == 2 {
            //结束
            self.navigationItem.title = "已结束"
            finishButton.hidden = true
            toolBarView.hidden = true
        }
        
    }
    
    func postShowOrder(){
        guard let id = teaching?.id else {
            return
        }
        let url = getTechingRecord
        let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "pageNo":1 , "pageSize":100, "teachId": id ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseResult)
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        guard let records = json["teachingRecord"].array where records.count > 0 else {
            self.nobodyLabel.hidden = false
            self.view.bringSubviewToFront(nobodyLabel)
            return
        }
        
        self.teachingRecords = records.flatMap{ TeachingRecord(json: $0) }
        self.tableView.reloadData()
        
    }
    
    func deleteTeaching() {
        guard let id = teaching?.id else {
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let url = deleteTeachingRequest
        let params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType , "teachId": id ] as! [String : AnyObject]
        doRequest(url, parameters: params , praseMethod: praseDeleteResult)
    }
    
    func praseDeleteResult(json: SwiftyJSON.JSON) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        guard let teachingIndex = self.teachingIndex else {
            return
        }
        let okAction = UIAlertAction(title: "确定", style: .Cancel) {
            action in
            self.delegate?.deleteQuestion(teachingIndex)
            self.navigationController?.popViewControllerAnimated(true)
        }
        displayAlertController(nil, message: "删除成功", actions: [okAction])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.teachingRecords.count == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return self.teachingRecords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(QuestionToDoTableViewCell.id, forIndexPath: indexPath) as! QuestionToDoTableViewCell
            cell.dataBind(teaching!)
            cell.editButton.addTarget(self, action: #selector(deleteTeaching), forControlEvents: .TouchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TeachingRecordTableViewCell.id, forIndexPath: indexPath) as! TeachingRecordTableViewCell
        let fromUser = userInfoStore.userType == 0
        cell.dataBind(teachingRecords[indexPath.row], fromUser: fromUser)
        cell.audioView.userInteractionEnabled = true
        cell.audioView.tag = indexPath.row
        cell.audioView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCell(_:))))
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let  uiView = UIView(frame : CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: screenWidth - 8, height: 30))
        label.text = "教学记录"
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func selectCell(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        guard let audioUrl = teachingRecords[tag].audio where !audioUrl.isEmpty else {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: tag, inSection: 1)) as! TeachingRecordTableViewCell
        let play = LGAudioPlayer()
        let audioPlayer = play
        audioPlayer.stopPlay = {
            cell.stopAnimation()
        }
        audioPlayer.startPlaying(audioUrl)
        cell.beginAnimation()
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5) * 1000 * 1000 * 1000), dispatch_get_main_queue(), { () -> Void in
//            cell.stopAnimation()
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: extension for toobar action

extension CoachTeachingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, LGAudioRecorderDelegate {
    
    func voiceClick(button: UIButton) {
        if toolBarView.recordButton.hidden == false {
            toolBarView.showRecord(false)
        } else {
            toolBarView.showRecord(true)
            self.view.endEditing(true)
        }
    }
    
    func recordClick(button: UIButton) {
        button.setTitle("松开结束", forState: .Normal)
        button.addTarget(self, action: "recordComplection:", forControlEvents: .TouchUpInside)
        button.addTarget(self, action: "recordDragOut:", forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: "recordCancel:", forControlEvents: .TouchUpOutside)
        
        let currentTime = NSDate().timeIntervalSinceReferenceDate
        let record = LGAudioRecorder(fileName: "\(currentTime).wav")
        record.delegate = self
        recorder = record
        recorder.startRecord()
        
        recordIndicatorView = LGRecordIndicatorView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
        view.addSubview(recordIndicatorView)
    }
    
    func recordComplection(button: UIButton) {
        button.setTitle("按住说话", forState: .Normal)
        recorder.stopRecord()
        recorder.delegate = nil
        recordIndicatorView.removeFromSuperview()
        recordIndicatorView = nil
        
        if recorder.timeInterval != nil, let _ = recorder.audioData {
            
            sendAudio( recorder.audioData )
            
//            let message = voiceMessage(incoming: false, sentDate: NSDate(), iconName: "", voicePath: recorder.recorder.url, voiceTime: recorder.timeInterval)
//            let receiveMessage = voiceMessage(incoming: true, sentDate: NSDate(), iconName: "", voicePath: recorder.recorder.url, voiceTime: recorder.timeInterval)
            
//            messageList.append(message)
//            reloadTableView()
//            messageList.append(receiveMessage)
//            reloadTableView()
//            AudioServicesPlayAlertSound(messageOutSound)
        }
    }
    
    func sendAudio(audioData: NSData) {
        
        let url = uploadFile
        
        let parameters =  ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType, "fileext":"wav", "filetype":3, "content":audioData] as [String : AnyObject]
            
        doRequest(url, parameters: parameters, praseMethod: {json in
            if json["success"].boolValue, let url = json["url"].string {
                self.sendMessage(nil, audio: url)
            } else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.displayAlertControllerWithMessage("消息发送失败")
                return
            }
        })
    }
    
    func recordDragOut(button: UIButton) {
        button.setTitle("按住说话", forState: .Normal)
        recordIndicatorView.showText("松开手指,取消发送", textColor: UIColor.redColor())
    }
    
    
    func recordCancel(button: UIButton) {
        button.setTitle("按住说话", forState: .Normal)
        recorder.stopRecord()
        recorder.delegate = nil
        recordIndicatorView.removeFromSuperview()
        recordIndicatorView = nil
    }
    
//    func emotionClick(button: UIButton) {
//        if toolBarView.emotionButton.tag == 1 {
//            toolBarView.showEmotion(true)
//            toolBarView.textView.inputView = emojiView
//        } else {
//            toolBarView.showEmotion(false)
//            toolBarView.textView.inputView = nil
//        }
//        toolBarView.textView.becomeFirstResponder()
//        toolBarView.textView.reloadInputViews()
//    }
    
    func sendClick(button: UIButton) {
        sendText()
        
        if toolBarView.sendButton.tag == 2 {
            toolBarView.showMore(true)
            toolBarView.textView.inputView = shareView
        } else {
            toolBarView.showMore(false)
            toolBarView.textView.inputView = nil
        }
        
        toolBarView.textView.becomeFirstResponder()
        toolBarView.textView.reloadInputViews()
    }
    
    
    // MARK: - UIImagePick delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        toolBarView.showMore(false)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        toolBarView.showMore(false)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func sendMessage(content: String?, audio: String?) {

        guard let id = teaching?.id else {
            return
        }
        AudioServicesPlayAlertSound(messageOutSound)
        
        let url = addTechingRecord
        var params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType ,"teachId": id ] as! [String : AnyObject]
        if let content = content {
            params["content"] = content
        }
        if let audio = audio {
            params["audio"] = audio
        }
        doRequest(url, parameters: params , praseMethod: praseSendMessageResult)
    }
    
    func praseSendMessageResult(json: SwiftyJSON.JSON){
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        postShowOrder()
        
    }
    
    func sendText() {
        if !toolBarView.textView.text.isEmpty {
            let messageStr = toolBarView.textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if messageStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
                return
            }
            sendMessage(messageStr, audio: nil)
            toolBarView.textView.text = ""
        }
    }
    // MARK: - textViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let messageStr = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if messageStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
                return true
            }
            sendMessage(messageStr, audio: nil)
            textView.text = ""
            return false
        }
        return true
    }
    
    // MARK: -LGrecordDelegate
    func audioRecorderUpdateMetra(metra: Float) {
        if recordIndicatorView != nil {
            recordIndicatorView.updateLevelMetra(metra)
        }
    }
    
    
    @IBAction func gotoRemark(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddRemarkViewController") as! AddRemarkViewController
        vc.teaching = self.teaching
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
}
