//
//  UserCoachModifyInfoViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/5/21.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import MBProgressHUD


class UserCoachModifyInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var imageType: String?
    var imagePicker = UIImagePickerController()

    var cellList = [AnyObject]()
    
    let headerCell = "HeaderTableViewCell"
    let blankHonorCell = "BlankHonorTableViewCell"
    let honorCell = "HonorListTableViewCell"
    let videoCell = "VideoCollectionViewCell"
    let blankCell = "BlankCollectionViewCell"
    let infoCell = "InfoTableViewCell"
    let infoFeeCell = "InfoFeeTableViewCell"
    let titleCell = "TitleTableViewCell"
    let introduceCell = "IntroduceInputTableViewCell"
    let blankCollectionViewCell = "BlankCollectionViewCell"
    let  picCollectionViewCell = "PicCollectionViewCell"
    let titles = ["姓名","性别","出生日期","所在地区","联系电话","太极流派","外语特长","收费标准"]
    let hints = ["请输入真实姓名","请选择","请选择","请选择","请输入","请选择","请选择","请输入"]
    let sectionTitles = ["个人简介","照片展示","视频展示","荣誉资质"]
    var picCollectionView: UICollectionView!
    var videoCollectionView: UICollectionView!
    
    var headImage: UIImage?
    var pics = [UIImage]()
    var videos = [NSURL]()
    var honorPics = [UIImage]()
    var cityId: Int?
    let liupais = ["不限","武式","和式","陈式","孙式","武当","杨式","洪式","赵堡","吴式","其他流派"]
    let waiyus = ["英语","日语","韩语","法语","德语","俄语","西班牙语","意大利语","阿拉伯语"]
    
    let sexArray = ["男","女"]
    var datePicker = UIDatePicker()
    var sexPicker: UIPickerView?
    
    var isModify = false
    var userinfo: CoachInfo?
    var delegate: UpdateUserInfoDelegate?
    
    
    
    var results = [ "name": "",
                    "sex": "",
                    "photo": "",
                    "content": "",
                    "birthday": NSData(),
                    "appCity": 0,
                    "tel": "",
                    "liupai": "",
                    "waiyu": "",
                    "pic1": "",
                    "pic2": "",
                    "pic3": "",
                    "pic4": "",
                    "pic5": "",
                    "ry1": "",
                    "ry2": "",
                    "ry3": "",
                    "ry4": "",
                    "video": "" ] as [String : AnyObject]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0)
        layout.itemSize = CGSize(width: 62, height: 62)
        
        picCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 62), collectionViewLayout: layout)
        picCollectionView.dataSource = self
        picCollectionView.delegate = self
        picCollectionView.registerNib(UINib(nibName: "PicCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: picCollectionViewCell)
        picCollectionView.registerNib(UINib(nibName: "BlankCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: blankCollectionViewCell)

        picCollectionView.backgroundColor = UIColor.whiteColor()
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .Horizontal
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
        layout1.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0)
        layout1.itemSize = CGSize(width: 62, height: 62)
        
        videoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 62), collectionViewLayout: layout1)
        videoCollectionView.dataSource = self
        videoCollectionView.delegate = self
        videoCollectionView.registerNib(UINib(nibName: "VideoCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: videoCell)
        videoCollectionView.registerNib(UINib(nibName: "BlankCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: blankCollectionViewCell)
        videoCollectionView.backgroundColor = UIColor.whiteColor()
        
        self.tableView.registerNib(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: headerCell)
        self.tableView.registerNib(UINib(nibName: "BlankHonorTableViewCell", bundle: nil), forCellReuseIdentifier: blankHonorCell)
        self.tableView.registerNib(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: infoCell)
        self.tableView.registerNib(UINib(nibName: "InfoFeeTableViewCell", bundle: nil), forCellReuseIdentifier: infoFeeCell)
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: titleCell)
        self.tableView.registerNib(UINib(nibName: "IntroduceInputTableViewCell", bundle: nil), forCellReuseIdentifier: introduceCell)
        self.tableView.registerNib(UINib(nibName: "HonorListTableViewCell", bundle: nil), forCellReuseIdentifier: honorCell)
        
        self.setBackButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor(hex: 0xefefef)
        
        self.tableView.reloadData()
    
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        let headCell = NSBundle.mainBundle().loadNibNamed("HeaderTableViewCell", owner: self, options: nil).last!
        self.cellList.append(headCell)
        for _ in 0...6 {
            let cell = NSBundle.mainBundle().loadNibNamed("InfoTableViewCell", owner: self, options: nil).last!
            self.cellList.append(cell)
        }
        let feeCell = NSBundle.mainBundle().loadNibNamed("InfoFeeTableViewCell", owner: self, options: nil).last!
        self.cellList.append(feeCell)
        let contentCell = NSBundle.mainBundle().loadNibNamed("IntroduceInputTableViewCell", owner: self, options: nil).last!
        self.cellList.append(contentCell)
        
        if isModify {
            initData()
        }
        
    }
    
    func initData() {
        

        
    }
    

    func saveVideo(info: [String : AnyObject]){
        let url = info[UIImagePickerControllerMediaURL] as! NSURL
        let tempFilePath = url.path
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath!){
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath!, self, "video:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func video(video:NSString, didFinishSavingWithError error: NSError?,contextInfo:UnsafeMutablePointer<Void>){
        
        if error != nil{
            let alertView = UIAlertController(title: "提醒", message: error!.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }else{
            //avCompressAndUpload(video as String)
        }
    }
    
    func uploadImageAction() {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("拍照",tag:10)
        }
        let choiceAction = UIAlertAction(title: "从手机相机选择照片", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.initWithImagePickView("相机",tag:10)
        }
        sheetView.addAction(cancelAction)
        sheetView.addAction(photoAction)
        sheetView.addAction(choiceAction)
        
        self.presentViewController(sheetView, animated: true, completion: nil)
        
    }
    
    func deleteImage(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        if tag >= 100 && tag < 200 {
            //pic
            self.pics.removeAtIndex(tag - 100)
            self.picCollectionView.reloadData()
        } else if tag >= 200 && tag < 300 {
            //pic
            self.pics.removeAtIndex(tag - 200)
            self.videoCollectionView.reloadData()
        } else if tag >= 300 {
            self.honorPics.removeAtIndex(tag - 300)
            self.tableView.reloadSections(NSIndexSet(index: 4), withRowAnimation: .Automatic)
        }

    }
    
    func selectImage(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }   
        
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        if (tag < 200) || (tag >= 300) {
            //pic,honor pic
            let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.initWithImagePickView("拍照",tag:tag)
            }
            let choicePhotoAction = UIAlertAction(title: "从手机相机选择照片", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.initWithImagePickView("相机",tag:tag)
            }
            sheetView.addAction(cancelAction)
            sheetView.addAction(photoAction)
            sheetView.addAction(choicePhotoAction)
        } else if tag >= 200 && tag < 300 {
            //video
            let videoAction = UIAlertAction(title: "录像", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.initWithImagePickView("录像",tag:tag)
            }
            let choiceVideoAction = UIAlertAction(title: "从手机相机选择视频", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.initWithImagePickView("视频",tag:tag)
            }
            sheetView.addAction(cancelAction)
            sheetView.addAction(videoAction)
            sheetView.addAction(choiceVideoAction)
        }
        self.presentViewController(sheetView, animated: true, completion: nil)
        
    }
    
    
    func initWithImagePickView(type: NSString, tag:Int){
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.view.tag = tag
        
        switch type{
        case "拍照","录像":
            self.imagePicker.sourceType = .Camera
            if !UIImagePickerController.isSourceTypeAvailable(.Camera){
                
                let alertView = UIAlertController(title: "提醒", message: "摄像头不可用，请在设置中打开摄像头权限", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }
            if type == "录像" {
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.imagePicker.videoQuality = .Type640x480
            }
        case "相机","视频":
            self.imagePicker.sourceType = .PhotoLibrary
        default:
            break
        }
        presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if picker.view.tag == 0 {
            //选择头像
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
            if compareResult == CFComparisonResult.CompareEqualTo {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? HeaderTableViewCell {
                        cell.setImageView(image)
                    }
                    self.headImage = image
                }
            }
            
        }else if picker.view.tag >= 100 && picker.view.tag < 200 {
            //选择图片pic
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
            if compareResult == CFComparisonResult.CompareEqualTo {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.pics.append(image)
                    self.picCollectionView.reloadData()
                }
            }
            
        } else if picker.view.tag >= 200 && picker.view.tag < 300 {
            //video
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.CompareCaseInsensitive)
            if compareResult == CFComparisonResult.CompareEqualTo {
                if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
                    self.videos.append(videoUrl)
                    self.videoCollectionView.reloadData()
                }
            }
            
        } else if picker.view.tag >= 300 {
            //选择honor pic
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
            if compareResult == CFComparisonResult.CompareEqualTo {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.honorPics.append(image)
                    self.tableView.reloadSections(NSIndexSet(index: 4), withRowAnimation: .Automatic)
                }
            }
        }
        
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.picCollectionView {
            //pic
            if self.pics.count > 0 && indexPath.item < self.pics.count {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(picCollectionViewCell, forIndexPath: indexPath) as! PicCollectionViewCell
                cell.pic.image = self.pics[indexPath.item]
                
                cell.deleteImage.userInteractionEnabled = true
                let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
                cell.deleteImage.addGestureRecognizer(deleteTap)
                deleteTap.view!.tag = indexPath.item + 100
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(blankCollectionViewCell, forIndexPath: indexPath) as! BlankCollectionViewCell
            cell.image.userInteractionEnabled = true
            let selectTap = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            cell.image.addGestureRecognizer(selectTap)
            selectTap.view!.tag = indexPath.item + 100
            return cell
        }

        //video
        if self.videos.count > 0 && indexPath.item < self.videos.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(videoCell, forIndexPath: indexPath) as! VideoCollectionViewCell
            cell.setVideo(self.videos[indexPath.item])
            
            cell.deleteImage.userInteractionEnabled = true
            let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
            cell.deleteImage.addGestureRecognizer(deleteTap)
            deleteTap.view!.tag = indexPath.item + 200
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(blankCollectionViewCell, forIndexPath: indexPath) as! BlankCollectionViewCell
        cell.image.userInteractionEnabled = true
        let selectTap = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
        cell.image.addGestureRecognizer(selectTap)
        selectTap.view!.tag = indexPath.item + 200
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.picCollectionView {
            return self.pics.count + 1
        }
        return self.videos.count + 1
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = self.cellList[indexPath.row] as! HeaderTableViewCell
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            cell.uploadImage.tag = 0
            cell.uploadImage.userInteractionEnabled = true
            cell.uploadImage.addGestureRecognizer(tap)
            if isModify {
                cell.setImageViewWithUrl(NSURL(string: userinfo!.photo ?? "")!)
            }
            return cell
        case(0,1...7):
            //let cell = tableView.dequeueReusableCellWithIdentifier(infoCell, forIndexPath: indexPath) as! InfoTableViewCell
            let cell = self.cellList[indexPath.row] as! InfoTableViewCell
            cell.title.text = self.titles[indexPath.row - 1]
            cell.value.placeholder = self.hints[indexPath.row - 1]
            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row ==  7 {
                cell.value.enabled = false
            }
            if isModify {
                switch indexPath.row {
                case 1:
                    cell.value.text = userinfo?.name
                case 2:
                    cell.value.text = userinfo?.sex
                case 3:
                    let birthday = userinfo?.birthday as! NSString
                
                    cell.value.text = birthday.length >= 10 ? birthday.substringToIndex(10) : birthday as String
                case 4:
                    cell.value.text = userinfo?.appCityStr
                case 5:
                    cell.value.text = userinfo?.tel
                case 6:
                    cell.value.text = userinfo?.liupai
                case 7:
                    cell.value.text = userinfo?.waiyu
                default:
                    break
                }
            }
            

            return cell
        case (0,8):
            //let cell = tableView.dequeueReusableCellWithIdentifier(infoFeeCell, forIndexPath: indexPath) as! InfoFeeTableViewCell
            let cell = self.cellList[8] as! InfoFeeTableViewCell
            if isModify {
                cell.value.text = userinfo?.shoufei
            }
            return cell
        case (1...4,0):
            let cell = tableView.dequeueReusableCellWithIdentifier(titleCell, forIndexPath: indexPath) as! TitleTableViewCell
            cell.title.text = self.sectionTitles[indexPath.section - 1]
            return cell
        case (1,1):
            //let cell = tableView.dequeueReusableCellWithIdentifier(introduceCell, forIndexPath: indexPath) as! IntroduceInputTableViewCell
            let cell = self.cellList[9] as! IntroduceInputTableViewCell
            if isModify {
                cell.content.text = userinfo?.content
            }
            return cell
        case (2,1):
            let cell = UITableViewCell()
            cell.contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 62)
            cell.contentView.addSubview(picCollectionView)
            return cell
        case(3,1):
            let cell = UITableViewCell()
            cell.contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 62)
            cell.contentView.addSubview(videoCollectionView)
            return cell
        case(4,1...self.honorPics.count + 1):
            if indexPath.row == self.honorPics.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(blankHonorCell, forIndexPath: indexPath) as! BlankHonorTableViewCell
                let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
                cell.selectImage.tag = 300 + indexPath.row - 1
                cell.selectImage.userInteractionEnabled = true
                cell.selectImage.addGestureRecognizer(tap)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(honorCell, forIndexPath: indexPath) as! HonorListTableViewCell
                cell.honorImage.image = self.honorPics[indexPath.row - 1]
                let tap = UITapGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
                cell.deleteImage.tag = 300 + indexPath.row - 1
                cell.deleteImage.userInteractionEnabled = true
                cell.deleteImage.addGestureRecognizer(tap)
                
                return cell
            }

        default:
            break
        }
        return UITableViewCell()
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 9
        case 1,2,3:
            return 2
        case 4:
            return 2 + self.honorPics.count
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return 128
        case (0,1...8):
            return 44
        case(1...4,0):
            return 34
        case(1...3,1):
            return 68
        case(4,1...honorPics.count + 1):
            if indexPath.row == honorPics.count + 1 {
                return 43
            } else {
                return 78
            }
            
        default:
            break
        }
        return 0
    }
    
    func selectArea() {
        
        let cityVC = CFCityPickerVC()
        cityVC.cityModels = cityParse()
        cityVC.hotCities = hotCities
        
        let navVC = UINavigationController(rootViewController: cityVC)
        self.presentViewController(navVC, animated: true, completion: nil)
        
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: CFCityPickerVC.CityModel) in
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0)) as! InfoTableViewCell
            cell.value.text = cityModel.name
            self.cityId = cityModel.id
            self.results["appCity"] = cityModel.id
        }
    }
    
    
    func selectValue(label:UITextField, value:[String]) {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        sheetView.addAction(cancelAction)
        
        for index in 0...value.count - 1 {
            let otherAction = UIAlertAction(title: value[index], style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                label.text = value[index]
                if value == self.liupais {
                    self.results["liupai"] = value[index]
                } else if value == self.waiyus {
                    self.results["waiyu"] = value[index]
                } else if value == self.sexArray {
                    self.results["sex"] = value[index]
                }
                sheetView.dismissViewControllerAnimated(true, completion: nil)
            }
            sheetView.addAction(otherAction)
            
        }
        
        self.presentViewController(sheetView, animated: true, completion: nil)
    }
    
    func selectLiupai() {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0)) as! InfoTableViewCell
        selectValue(cell.value, value: liupais)
    }
    
    func selectWaiyu() {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0)) as! InfoTableViewCell
        selectValue(cell.value, value: waiyus)
    }
    
    func selectSex(){
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! InfoTableViewCell
        selectValue(cell.value, value: sexArray)
        
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
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sexArray[row]
    }
    
    // 选中行的操作
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! InfoTableViewCell

        cell.value.text = sexArray[row]
        
    }
    
    func selectBirthday( ) {
        
        
        let sheetView = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: 200))
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.backgroundColor = UIColor.clearColor()
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! InfoTableViewCell

        
        if cell.value.text!.isEmpty{
            datePicker.date = NSDate()
        }else{
            if let date = cell.value.text?.getDateByFormatString("yyyy-MM-dd") {
                datePicker.date = date
            }
            
        }
        
        let okAction = UIAlertAction(title: "确定", style:UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.value.text = dateFormatter.stringFromDate(self.datePicker.date)
            //self.birthday = self.datePicker.date
            //self.results["birthday"] = self.datePicker.date
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        sheetView.addAction(okAction)
        sheetView.view.addSubview(datePicker)
        self.presentViewController(sheetView, animated: true, completion: nil)
        
    }
    
//    func birthdayValueChange(sender: UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! InfoTableViewCell
//
//        cell.value.text = dateFormatter.stringFromDate(sender.date)
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        switch indexPath.row {
        case 2:
            self.selectSex()
        case 3:
            self.selectBirthday()
        case 4:
            self.selectArea()
        case 6:
            //流派
            self.selectLiupai()
        case 7:
            //外语
            self.selectWaiyu()
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }

    @IBAction func modifyInfo(sender: AnyObject) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let hintArray = ["请选择头像","请输入姓名","请选择性别","请选择出生日期","请选择所在地区","请输入联系电话","请选择流派","请选择外语特长","请输入收费标准"]
        
        for index in 0...8 {
            
            if index == 0 {
                let cell = self.cellList[0] as! HeaderTableViewCell
                self.headImage = cell.getImage()
                
                guard let _ = self.headImage else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    displayAlertControllerWithMessage("请选择头像")
                    return
                }
                continue
            }
            
            if index == 8 {
                let cell = self.cellList[8] as! InfoFeeTableViewCell
                guard let value = cell.value.text else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    displayAlertControllerWithMessage(hintArray[index - 1])
                    return
                }
                self.results["shoufei"] = value
                continue
            }

            let cell = self.cellList[index] as! InfoTableViewCell
            guard let value = cell.value.text else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                displayAlertControllerWithMessage(hintArray[index - 1])
                return
            }
            switch index {
            case 1:
                results["name"] = value
            case 2:
                results["sex"] = value
            case 3:
                break
                results["birthday"] = value.getDateByFormatString("yyyy-MM-dd")
            case 4:
                break
                //results["szShi"] = self.cityId
            case 5:
                results["tel"] = value
            case 6:
                results["liupai"] = value
            case 7:
                results["waiyu"] = value
            default:
                break
            }
        }
        let cotentCell = self.cellList[9] as! IntroduceInputTableViewCell
        guard let value = cotentCell.content.text else {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            displayAlertControllerWithMessage("请输入个人简介")
            return
        }
        results["content"] = value

        //upload images
        var images = [headImage!]
        var imageFields = ["photo"]
        
        var coachFields = ["pic1", "pic2", "pic3", "pic4", "pic5"]
        for index in 0 ..< pics.count {
            guard index < 5 else {
                break
            }
            images.append(pics[index])
            imageFields.append(coachFields[index])
        }
        
        coachFields = ["ry1", "ry2", "ry3", "ry4"]
        for index in 0 ..< honorPics.count {
            guard index < 4 else {
                break
            }
            images.append(honorPics[index])
            imageFields.append(coachFields[index])
        }
        
        
        //let userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as! Int
        let username = NSUserDefaults.standardUserDefaults().valueForKey("userName") as! String
        let password = encryptPassword(NSUserDefaults.standardUserDefaults().valueForKey("password") as! String)
        
        let url = uploadFile
        
        for index in 0 ..< images.count {
            let imageData = UIImageJPEGRepresentation(images[index] , 0.2)
            let imageDataBase64 = imageData!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
            
            let parameters =  ["username":username,"password":password,"userType":2, "fileext":"jpg", "filetype":1, "content":imageDataBase64] as [String : AnyObject]

            doRequest(url, parameters: parameters, praseMethod: {json in
                if json["success"].boolValue {
                    if let url = json["url"].string {
                        self.results[imageFields[index]] = url
                    }
                    
                    if index == images.count - 1 {
                        //finish all images upload, and then upload video
                        if self.videos.count != 0 {
                            self.uploadVideo()
                        } else {
                            self.uploadUserInfo()
                        }
                        
                    }
                    
                } else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.displayAlertControllerWithMessage("图片上传失败")
                    return
                }
            })
            
        }
    }
    
    func uploadVideo() {
        
        if videos.count == 0 {
            return
        }
        
        let filename = self.videos.first!.absoluteString.componentsSeparatedByString("/").last!
        
        //上传视频
        let url = uploadFileMultipart
        Alamofire.upload(.POST, url, multipartFormData: {
            multipartFormData in
            let data = NSData(contentsOfURL: self.videos.first!)!

            multipartFormData.appendBodyPart(data: data, name: "file", fileName:filename, mimeType: "video/quicktime")
            
            //let userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as! Int
            let username = NSUserDefaults.standardUserDefaults().valueForKey("userName") as! String
            let password = encryptPassword(NSUserDefaults.standardUserDefaults().valueForKey("password") as! String)
            
            
            let param = ["username" : username, "password" : password, "userType": 2, "fileext": "MOV", "filetype": "2" ]
            for (key, value) in param {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key as! String)
            }
            
            },
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON{ response in
                                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                                    
                                    if(response.result.value != nil && response.result.isSuccess){
                                        let json = SwiftyJSON.JSON(response.result.value!)
                                        debugPrint(json)
                                        if let url = json["url"].string {
                                            self.results["video"] = url
                                        }
                                        if json["success"].boolValue {
                                            self.uploadUserInfo()
                                        }else{
                                            self.displayAlertControllerWithMessage("信息完善上传失败")
                                        }
                                    }else{
                                        self.displayAlertControllerWithMessage("信息完善上传失败")
                                    }
                                }
                            case .Failure(_):
                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                                self.displayAlertControllerWithMessage("信息完善上传失败")
                                
                            }
            }
        )
        
    }

    func uploadUserInfo() {
        
        //let userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as! Int
        let username = NSUserDefaults.standardUserDefaults().valueForKey("userName") as! String
        let password = encryptPassword(NSUserDefaults.standardUserDefaults().valueForKey("password") as! String)
        
        let url = modifyJlUser
        var parameters =  ["username":username,"password":password,"userType":2] as [String : AnyObject]
        for (key,value) in self.results {
            if value is String && value as! String == "" {
                continue
            }
            parameters[key] = value
        }
        
        doRequest(url, parameters: parameters, praseMethod: praseModifyResult)
        
    }
    
    func praseModifyResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            let alertView = UIAlertController(title: "提醒", message: "完善信息完成", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {
                action in
                self.navigationController?.popToRootViewControllerAnimated(true)
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

