//
//  CourseBuyViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/30.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CourseBuyViewController: UIViewController {

    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var couseCount: UILabel!
    @IBOutlet weak var coachName: UILabel!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var fee: UILabel!
    
    
    var lesson: LessonInfo!
    var club: ClubInfo?
    var coach: CoachInfo?
    var userType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setBackButton()
        dataBind()
    }
    
    func dataBind() {
        headImage.sd_setImageWithURL(NSURL(string: lesson?.pic ?? ""))
        courseName.text = lesson.name
        
        var courseCountDesc = "\(lesson?.classCount ?? 0)次课"
        if let startDateString = lesson?.startDate as? NSString, let endDateString = lesson?.endDate as? NSString {
            let startDateSub = startDateString.length >= 10 ? startDateString.substringToIndex(10) : startDateString
            let endDateSub = endDateString.length >= 10 ? endDateString.substringToIndex(10) : endDateString
            courseCountDesc += "  \(startDateSub) - \(endDateSub)"
        }
        couseCount.text = courseCountDesc
        coachName.text = "教练:\(lesson.jl1Name ?? "")"
        fee.text = "￥\(lesson.price ?? 0)元"
        
    }

    @IBAction func gotoPay(sender: AnyObject) {
        
        guard let mobile = self.phoneNumber.text where !mobile.isEmpty else {
            displayAlertControllerWithMessage("请输入手机号")
            return
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        vc.lesson = self.lesson
        vc.payType = .Lesson
        vc.toUserType = self.userType
        vc.mobile = mobile
        vc.club = self.club
        vc.coach = self.coach
        
        self.navigationController?.pushViewController(vc, animated: true)
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
