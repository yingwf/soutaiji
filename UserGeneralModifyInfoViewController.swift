//
//  UserGeneralModifyInfoViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import MBProgressHUD


class UserGeneralModifyInfoViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var upLoadImage: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var sexView: UIView!
    
    @IBOutlet weak var areaView: UIView!
    
    var imageUrl: String?
    
    var birthday: NSDate?
    var cityId: Int?
    
    let sexArray = ["男","女"]
    var datePicker = UIDatePicker()
    var sexPicker: UIPickerView?

    var imageType: String?
    var imagePicker = UIImagePickerController()
    var headImage: UIImageView?
    var imageContent: String?

    var userType: Int!
    var username: String!
    var password: String!
    
    var isModify = false
    var userinfo: UserInfo?
    var delegate: UpdateUserInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        self.userNameField.delegate = self
        self.phoneField.delegate = self
        self.areaField.delegate = self
        
        self.upLoadImage.layer.borderWidth = 0.5
        self.upLoadImage.layer.borderColor = self.upLoadImage.textColor.CGColor
        upLoadImage.userInteractionEnabled = true
        upLoadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
        
        self.birthdayView.userInteractionEnabled=true
        let birthdayViewTap = UITapGestureRecognizer(target: self, action: #selector(selectBirthday))
        self.birthdayView.addGestureRecognizer(birthdayViewTap)
        
        self.areaView.userInteractionEnabled=true
        let areaViewTap = UITapGestureRecognizer(target: self, action: #selector(selectArea))
        self.areaView.addGestureRecognizer(areaViewTap)
        
        self.sexView.userInteractionEnabled=true
        let sexViewTap = UITapGestureRecognizer(target: self, action: #selector(selectSex))
        self.sexView.addGestureRecognizer(sexViewTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as! Int
        self.username = NSUserDefaults.standardUserDefaults().valueForKey("userName") as! String
        self.password = encryptPassword(NSUserDefaults.standardUserDefaults().valueForKey("password") as! String)
        
        self.setBackButton()
        
        if isModify {
            initUI()
        }
    }
    
    func initUI() {
        guard let userinfo = self.userinfo else {
            return
        }
        
        if self.headImage == nil{
            self.headImage = UIImageView(frame: self.upLoadImage.frame)
        }
        self.headImage!.sd_setImageWithURL(NSURL(string: userinfo.photo ?? ""))
        self.headImage!.userInteractionEnabled = true
        self.headImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
        self.view.addSubview(self.headImage!)
        
        userNameField.text = userinfo.name
        phoneField.text = userinfo.tel
        areaField.text = userinfo.appCityStr
        sexField.text = userinfo.sex
        birthdayField.text = (userinfo.birthday! as NSString).substringToIndex(10)
        self.cityId = userinfo.appCity
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
    
    func selectValue(label:UITextField, value:[String]) {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        sheetView.addAction(cancelAction)
        
        for index in 0...value.count - 1 {
            let otherAction = UIAlertAction(title: value[index], style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                label.text = value[index]
                sheetView.dismissViewControllerAnimated(true, completion: nil)
            }
            sheetView.addAction(otherAction)
            
        }
        
        self.presentViewController(sheetView, animated: true, completion: nil)
    }
    
    
    func selectSex(){
        
        selectValue(self.sexField, value: sexArray)

    }
    
    // 设置列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 设置行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexArray.count
    }
    
    // 设置每行具体内容（titleForRow 和 viewForRow 二者实现其一即可）
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexArray[row]
    }
    
    // 选中行的操作
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sexField.text = sexArray[row]
        
    }
    
    func selectBirthday( ) {
        
        
        let sheetView = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: 200))
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.backgroundColor = UIColor.clearColor()
        
        if self.birthdayField.text!.isEmpty{
            datePicker.date = NSDate()
        }else{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            datePicker.date = dateFormatter.dateFromString(self.birthdayField.text!)!
        }
        
        let okAction = UIAlertAction(title: "确定", style:UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthdayField.text = dateFormatter.stringFromDate(self.datePicker.date)
            self.birthday = self.datePicker.date
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        sheetView.addAction(okAction)
        sheetView.view.addSubview(datePicker)
        self.presentViewController(sheetView, animated: true, completion: nil)

    }
    
    func birthdayValueChange(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthdayField.text = dateFormatter.stringFromDate(sender.date)
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
                self.headImage = UIImageView(frame: self.upLoadImage.frame)
            }
            self.headImage!.image = image
            self.headImage!.userInteractionEnabled = true
            self.headImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadImageAction)))
            self.view.addSubview(self.headImage!)
            if !self.upLoadImage.hidden{
                self.upLoadImage.hidden = true
            }
        }
        //获取图片类型
        let urlQuery = info[UIImagePickerControllerReferenceURL]?.query
        let paramArray = urlQuery!!.componentsSeparatedByString("&")
        for index in 0 ... paramArray.count - 1 {
            if paramArray[index].hasPrefix("ext=") {
                self.imageType = (paramArray[index] as NSString).substringFromIndex(4)
            }
        }
            
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func selectArea() {
        
        let cityVC = CFCityPickerVC()
        cityVC.cityModels = cityParse()
        cityVC.hotCities = hotCities
        
        let navVC = UINavigationController(rootViewController: cityVC)
        self.presentViewController(navVC, animated: true, completion: nil)
        
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
            self.areaField.text = cityModel.name
            self.cityId = cityModel.id
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modifyInfo(sender: AnyObject) {
        
        let url = uploadFile

        if self.headImage == nil {
            let alertView = UIAlertController(title: nil, message: "请选择头像", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){ (UIAlertAction) -> Void in
                return
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            return
        }
        
        
        
        let inputElement = [userNameField,sexField,birthdayField,areaField,phoneField]
        let hintArray = ["请输入姓名","请选择性别","请选择出生日期","请选择所在地区","请输入手机号码"]
        
        for index in 0...4{
            guard !inputElement[index].text!.isEmpty else{
                let alertView = UIAlertController(title: nil, message: hintArray[index], preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
                return
            }
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //获取图片数据
        let imageData = UIImageJPEGRepresentation(self.headImage!.image!, 0.2)
        self.imageContent = imageData?.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
        
        let parameters =  ["username":username,"password":password,"userType":userType,"fileext":"jpg", "filetype":1,"content":self.imageContent!] as [String : AnyObject]
        
        doRequest(url, parameters: parameters, praseMethod: praseUploadFileResult)
    }

    func praseUploadFileResult(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            self.imageUrl = json["url"].string
            let url = modifyUser
            
            self.birthday = self.birthdayField.text?.getDateByFormatString("yyyy-MM-dd")
            
            
            let parameters =  ["username":username,"password":password,"userType":userType,"name":self.userNameField.text!,"tel":self.phoneField.text!,"sex":sexField.text!,"birthday": self.birthday! , "appCity": self.cityId!,"photo":self.imageUrl! ] as [String : AnyObject]
            
            //头像上传成功后，再次提交信息
            doRequest(url, parameters: parameters, praseMethod: praseModifyResult)
            
        }else{
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            let alert = UIAlertView()
            alert.message = "上传头像失败"
            alert.addButtonWithTitle("确定")
            alert.show()
        }
    }

    func praseModifyResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            
            let alertView = UIAlertController(title: "提醒", message: "完善信息完成", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {
                action in
                if self.isModify {
                    self.userinfo?.name = self.userNameField.text
                    self.userinfo?.photo = self.imageUrl
                    self.userinfo?.birthday = self.birthdayField.text
                    self.userinfo?.appCity = self.cityId
                    self.userinfo?.appCityStr = self.areaField.text
                    self.userinfo?.tel = self.phoneField.text
                    self.userinfo?.sex = self.sexField.text
                    
                    self.delegate?.updateUserinfo(self.userType, userinfo: self.userinfo!)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
            
        }else{
            let alertView = UIAlertController(title: "提醒", message: "信息上传失败", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)

        }
    }

}
