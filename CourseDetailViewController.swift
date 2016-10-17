//
//  CourseDetailViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/27.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {

    var lesson: LessonInfo?
    var lessons = [LessonInfo]()
    var coach: CoachInfo?
    var club: ClubInfo?
    var userType = 2 //default is coach
    var delegate: UpdateLessonListDelegate?
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var expButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setBackButton()
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseDetailTableViewController") as! CourseDetailTableViewController
        vc.lesson = self.lesson
        vc.lessons = self.lessons
        vc.coach = self.coach
        vc.club = self.club
        vc.userType = self.userType
        vc.delegate = self.delegate
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        
        if userInfoStore.userType != 0 {
            self.buttomView.hidden = true
        } else {
            self.buttomView.hidden = false
            self.view.bringSubviewToFront(buttomView)
            expButton.setTitle("\(lesson?.expPrice ?? 0)元体验预约", forState: .Normal)
        }
        
    }
    
    
    @IBAction func gotoBuy(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseBuyViewController") as! CourseBuyViewController
        vc.lesson = self.lesson
        vc.club = self.club
        vc.coach = self.coach
        vc.userType = self.userType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func gotoExpBuy(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseExpBuyViewController") as! CourseExpBuyViewController
        vc.lesson = self.lesson
        vc.club = self.club
        vc.coach = self.coach
        vc.userType = self.userType
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
