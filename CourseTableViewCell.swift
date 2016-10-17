//
//  CourseTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/8/24.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    static let id = "CourseTableViewCell"
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var classCount: UILabel!
    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var studentCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataBindwithCoach(lesson: LessonInfo , coach: CoachInfo) {
        headImage.sd_setImageWithURL(NSURL(string: lesson.pic ?? ""))
        name.text = lesson.name
        let startDate = (lesson.startDate! as NSString).substringToIndex(10)
        let endDate = (lesson.endDate! as NSString).substringToIndex(10)

        classCount.text = "\(lesson.classCount ?? 0)次课 \(startDate) - \(endDate)"
        coachName.text = "教练:\(coach.name ?? "")"
        price.text = "￥\(lesson.price ?? 0)"
        studentCount.text = "已报名\(lesson.studentCount ?? 0)人"
        
    }
    
    func dataBindwithClub(lesson: LessonInfo , club: ClubInfo) {
        headImage.sd_setImageWithURL(NSURL(string: lesson.pic ?? ""))
        name.text = lesson.name
        let startDate = (lesson.startDate! as NSString).substringToIndex(10)
        let endDate = (lesson.endDate! as NSString).substringToIndex(10)
        
        classCount.text = "\(lesson.classCount ?? 0)次课 \(startDate) - \(endDate)"
        coachName.text = "教练:\(lesson.jl1Name ?? "")"
        price.text = "￥\(lesson.price ?? 0)"
        studentCount.text = "已报名\(lesson.studentCount ?? 0)人"
        
    }
    
}
