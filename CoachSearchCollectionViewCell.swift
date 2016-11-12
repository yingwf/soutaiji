//
//  CoachSearchCollectionViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/20.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class CoachSearchCollectionViewCell: UICollectionViewCell {

    static let id = "CoachSearchCollectionViewCell"
    
    @IBOutlet weak var renzheng: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var liupai: UILabel!
    @IBOutlet weak var pingjia: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var dianji: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var fee: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.renzheng.backgroundColor = SYSTEMCOLOR
        self.renzheng.textColor = UIColor.whiteColor()
        
        let view = UIView(frame: CGRect(x: 0, y: 63.5, width: screenWidth, height: 0.5))
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.addSubview(view)
    }
    
    func setData(coach: CoachInfo) {
        renzheng.hidden = coach.renzheng == 0
        name.text = coach.name
        photo.sd_setImageWithURL(NSURL(string: coach.photo ?? ""))
        liupai.text = "流派:\(coach.liupai ?? "")"
        age.text = "年龄:\(coach.age ?? 0)"
        pingjia.text = "评价:\(coach.xuhao ?? "")"
        city.text = "城市:\(coach.appCityStr ?? "")"
        fee.text = "收费:\(coach.money ?? 0)"
        dianji.text = "点击:\(coach.visitCount ?? 0)"
    }

}
