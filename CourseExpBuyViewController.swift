//
//  CourseExpBuyViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/10/1.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CourseExpBuyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var couseCount: UILabel!
    @IBOutlet weak var coachName: UILabel!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var expTime: UITextField!
    
    
    
    var lesson: LessonInfo!
    var club: ClubInfo?
    var coach: CoachInfo?
    var userType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setBackButton()
        dataBind()
        expTime.delegate = self
    }
    
    func dataBind() {
        headImage.sd_setImageWithURL(NSURL(string: lesson?.pic ?? ""))
        courseName.text = lesson.name
        
        var courseCountDesc = "单次体验"
        if let startDateString = lesson?.startDate as? NSString, let endDateString = lesson?.endDate as? NSString {
            let startDateSub = startDateString.length >= 10 ? startDateString.substringToIndex(10) : startDateString
            let endDateSub = endDateString.length >= 10 ? endDateString.substringToIndex(10) : endDateString
            courseCountDesc += "  \(startDateSub) - \(endDateSub)"
        }
        couseCount.text = courseCountDesc
        coachName.text = "教练:\(lesson.jl1Name ?? "")"
        fee.text = "￥\(lesson.expPrice ?? 0)元"
        
    }
    
    @IBAction func gotoPay(sender: AnyObject) {
        
        guard let mobile = self.phoneNumber.text where !mobile.isEmpty else {
            displayAlertControllerWithMessage("请输入手机号")
            return
        }
        
        guard let expTime = self.expTime.text where !expTime.isEmpty else {
            displayAlertControllerWithMessage("请选择预约时间")
            return
        }
        
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        vc.lesson = self.lesson
        vc.payType = .LessonExp
        vc.toUserType = self.userType
        vc.mobile = mobile
        vc.club = self.club
        vc.coach = self.coach
        vc.expTime = expTime
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        self.selectDate(textField)
        return false
    }
    
    
    func selectDate(textField: UITextField) {
        
        let sheetView = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: 200))
        
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
            textField.text = dateFormatter.stringFromDate(datePicker.date)
            //self.startDateTime = textField.date
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        sheetView.addAction(okAction)
        sheetView.view.addSubview(datePicker)
        self.presentViewController(sheetView, animated: true, completion: nil)
        
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
