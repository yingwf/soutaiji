//
//  CoachLessonCreateTableViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/21.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import MBProgressHUD



class CoachLessonCreateTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var coach: CoachInfo?
    var lesson: LessonInfo?
    var isModify = false
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var expPrice: UITextField!
    @IBOutlet weak var classCount: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var detailTime: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var classDescription: BRPlaceholderTextView!
    
    var headImage: UIImageView?
    var datePicker = UIDatePicker()
    var startDateTime: NSDate?
    
    var imagePicker = UIImagePickerController()
    
    var delegate: UpdateLessonInfoDelegate?
    var updateListDelegate: UpdateLessonListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        classDescription.placeholder = "请输入"
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
        
        startDate.delegate = self
        endDate.delegate = self
        
        if isModify {
            initUI()
        }
        
    }
    
    func initUI() {
        guard let lesson = self.lesson else {
            return
        }
        
        self.navigationItem.title = "修改课程"
        
        if self.headImage == nil{
            self.headImage = UIImageView(frame: self.imageView.frame)
        }
        self.headImage?.sd_setImageWithURL(NSURL(string: lesson.pic ?? ""))
        self.headImage!.userInteractionEnabled = true
        self.headImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
        self.imageView.addSubview(self.headImage!)
        
        name.text = lesson.name
        price.text = "\(lesson.price ?? 0)"
        expPrice.text = "\(lesson.expPrice ?? 0)"
        classCount.text = "\(lesson.classCount ?? 0)"
        
        let startDateSub = (lesson.startDate! as NSString).substringToIndex(10)
        let endDateSub = (lesson.endDate! as NSString).substringToIndex(10)
        startDate.text = startDateSub
        endDate.text = endDateSub
        
        detailTime.text = lesson.detailTime
        location.text = lesson.location
        classDescription.text = lesson.description
    }
    

    
    func uploadImageAction(){
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("拍照")
        }
        let choiceAction = UIAlertAction(title: "从手机相机选择照片", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("相机")
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
        case "拍照":
            self.imagePicker.sourceType = .Camera
            break
        case "相机":
            self.imagePicker.sourceType = .PhotoLibrary
            break
        default:
            print("error")
        }
        presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        
        let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if compareResult == CFComparisonResult.CompareEqualTo {
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            if self.headImage == nil{
                self.headImage = UIImageView(frame: self.imageView.frame)
            }
            self.headImage!.image = image
            self.headImage!.userInteractionEnabled = true
            self.headImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
            self.imageView.addSubview(self.headImage!)
        }
//        //获取图片类型
//        let urlQuery = info[UIImagePickerControllerReferenceURL]?.query
//        let paramArray = urlQuery!!.componentsSeparatedByString("&")
//        for index in 0 ... paramArray.count - 1 {
//            if paramArray[index].hasPrefix("ext=") {
//                self.imageType = (paramArray[index] as NSString).substringFromIndex(4)
//            }
//        }
//        
//        //获取图片数据
//        let imageData = UIImageJPEGRepresentation(self.headImage!.image!, 0.5)
//        self.imageContent = imageData?.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
//        
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField.tag < 100 {
            return true
        }
        self.selectDate(textField)
        return false
    }

    
    func selectDate(textField: UITextField) {
        
        let sheetView = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: 200))
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.backgroundColor = UIColor.clearColor()

        if textField.text!.isEmpty{
            datePicker.date = NSDate()
        }else{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            datePicker.date = dateFormatter.dateFromString(textField.text!)!
        }
        
        let okAction = UIAlertAction(title: "确定", style:UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            textField.text = dateFormatter.stringFromDate(self.datePicker.date)
            //self.startDateTime = textField.date
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        sheetView.addAction(okAction)
        sheetView.view.addSubview(datePicker)
        self.presentViewController(sheetView, animated: true, completion: nil)
        
    }
    
    @IBAction func finishToCreateLesson(sender: AnyObject) {
        
        guard let _ = self.coach else {
            return
        }
        
        let url = uploadFile
        
        guard let image = headImage?.image else {
            displayAlertControllerWithMessage("请选择头像")
            return
        }
        
        let inputElement = [name,price,startDate,endDate]
        let hintArray = ["请输入名称","请输入价格","请选择起始日期","请选择起始日期"]

        for index in 0...3{
            guard !inputElement[index].text!.isEmpty else {
                displayAlertControllerWithMessage(hintArray[index])
                return
            }
        }
        let username = userInfoStore.userName
        let password = encryptPassword(userInfoStore.password)
        let userType = userInfoStore.userType
        
        let imageData = UIImageJPEGRepresentation(image , 0.2)
        let imageDataBase64 = imageData!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
        
        let parameters =  ["username":username, "password":password,"userType":userType,  "fileext":"JPG", "filetype":1, "content":imageDataBase64] as [String : AnyObject]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        doRequest(url, parameters: parameters, praseMethod: praseUploadFileResult)
        
    }

    func praseUploadFileResult(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            guard let imageUrl = json["url"].string else {
                return
            }
            var url = createJlLesson
            if isModify {
                url = modifyJlLesson
            }
            
            let username = userInfoStore.userName
            let password = encryptPassword(userInfoStore.password)
            let userType = userInfoStore.userType
            
            var parameters =  ["username":username,"password":password,"userType":userType, "pic": imageUrl] as [String : AnyObject]
            
            
            if isModify {
                parameters["lessonId"] = self.lesson?.id
            } else {
                parameters["jlId"] = self.coach!.id
            }
            
            if let name = name.text {
                parameters["name"] = name
            }
            if let price = price.text {
                parameters["price"] = price
            }
            if let expPrice = expPrice.text {
                parameters["expPrice"] = expPrice
            }
            if let description = classDescription.text {
                parameters["description"] = description
            }
            if let classCount = classCount.text {
                parameters["classCount"] = classCount
            }
            if let location = location.text {
                parameters["location"] = location
            }
            if let detailTime = detailTime.text {
                parameters["detailTime"] = detailTime
            }
            if let startDate = startDate.text?.getDateByFormatString("yyyy-MM-dd") {
                parameters["startDate"] = startDate
            }
            if let endDate = endDate.text?.getDateByFormatString("yyyy-MM-dd") {
                parameters["endDate"] = endDate
            }
            
            //头像上传成功后，再次提交信息
            doRequest(url, parameters: parameters, praseMethod: praseModifyResult)
            
        }else{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            displayAlertControllerWithMessage("上传封面图失败")
        }
    }
    
    func praseModifyResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            var message = "发布课程完成"
            if isModify {
                message = "修改课程完成"
            }
            let lesson = LessonInfo(json:json["jlLesson"])
            
            let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {
                action in
                self.delegate?.updateLessonInfo(lesson)
                self.updateListDelegate?.updateLessonList()
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }else{
            var message = "发布课程失败"
            if isModify {
                message = "修改课程失败"
            }
            let alertView = UIAlertController(title: "提醒", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
