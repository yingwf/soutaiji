//
//  models.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/17.
//  Copyright © 2016年  ywf. All rights reserved.
//

import Foundation
import SwiftyJSON


let SYSTEMCOLOR = UIColor(red: 0x8c/255, green: 0x18/255, blue: 0x02/255, alpha: 1)
let cityModels: [CFCityPickerVC.CityModel] = []
var cityList = Dictionary<Int,cityInfo>()
let hotCities = ["北京","上海","广州","深圳","天津","青岛","济南","武汉"]
let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

//客户
class Customer {
    var name:String?
    var telephone1:String?
    var new_company:String?
    var new_position:String?
    var guid:String?
}

//用户信息
//class UserInfo {
//    var lastname:String?
//    var firstname:String?
//    var teritoryid:String?
//    var businessunitid:String?
//    var internalemailaddress:String?
//    var mobilephone:String?
//}

class UserInfo {
    var birthday: String?
    var sex : String?
    var niming: Int?
    var tel : String?
    var regIp : String?
    var version : Int?
    var id: Int?
    var balance : Int?
    var lastLoginIp : String?
    var name: String?
    var user_Password : String?
    var money : Int?
    var publish : String?
    var isVIP : Int?
    var lastLoginTime : String?
    var publishTitle: String?
    var qq: String?
    var isLock: Int?
    var zip : String?
    var mail: String?
    var szQu: Int?
    var regTime : String?
    var classId : Int?
    var szSheng : Int?
    var appCity : Int?
    var appCityStr: String?
    var loginCount: Int?
    var photo : String?
    var content : String?
    var address : String?
    var szShi : Int?
    var expireDate: String? 
    var jifen : Int?
    var paixu : Int?
    var user_Name : String?
    
    init(json: SwiftyJSON.JSON) {
        self.birthday = json["birthday"].string
        self.sex = json["sex"].string
        self.niming = json["niming"].int
        self.tel = json["tel"].string
        self.regIp = json["regIp"].string
        self.version = json["version"].int
        self.id = json["id"].int
        self.balance = json["balance"].int
        self.lastLoginIp = json["lastLoginIp"].string
        self.name = json["name"].string
        self.user_Password = json["user_Password"].string
        self.money = json["money"].int
        self.publish = json["publish"].string
        self.isVIP = json["isVIP"].int
        self.lastLoginTime = json["lastLoginTime"].string
        self.publishTitle = json["publishTitle"].string
        self.qq = json["qq"].string
        self.isLock = json["isLock"].int
        self.zip = json["zip"].string
        self.mail = json["mail"].string
        self.szQu = json["szQu"].int
        self.regTime = json["regTime"].string
        self.classId = json["classId"].int
        self.szSheng = json["szSheng"].int
        self.appCity = json["appCity"].int
        self.loginCount = json["loginCount"].int
        self.photo = json["photo"].string
        self.content = json["content"].string
        self.address = json["address"].string
        self.szShi = json["szShi"].int
        self.expireDate = json["expireDate"].string
        self.jifen = json["jifen"].int
        self.paixu = json["paixu"].int
        self.user_Name = json["user_Name"].string
        self.appCityStr = json["appCityStr"].string

    }
    

}

//会馆
class ClubInfo {
    var image: String?
    var name: String?
    var liupai: String?
    var szSheng: String?
    var szShi: Int?
    var szQu: String?
    var renzheng: Int?
    var tel: String?
    
    var jl1name: String?
    var ry2: String?
    var jl2username: String?
    var ry1: String?
    var tj: Int?
    var ry4: String?
    var ry3: String?
    var jl1username: String?
    var pic1: String?
    var balance: Int?
    var pic: String?
    var pic5: String?
    var pic4: String?
    var pic3: String?
    var pic2: String?
    var fuwu: String?
    var regTime: String?
    var classId: Int?
    var dengji: Int?
    var loginCount: Int?
    var content: String?
    var jlVisitCount: Int?
    var jifen: String?
    var user_Name: String?
    var mobile: String?
    var birthday: String?
    var sex: String?
    var niming: String?
    var userVisitCount: Int?
    var regIp: String?
    var waiyu: String?
    var contact: String?
    var jl2photo: String?
    var version: Int?
    var id: Int?
    var huanjing: String?
    var headpic: String?
    var lastLoginIp: String?
    var jl1photo: String?
    var isUpdated: Int?
    var money: Int?
    var shizhi: String?
    var publish: String?
    var qq: String?
    var lastLoginTime: String?
    var publishTitle: String?
    var isLock: Int?
    var zip: String?
    var sharedUrl: String?
    var mail: String?
    var jl2desc: String?
    var jl1desc: String?
    var appCity: Int?
    var timeTable: String?
    var photo: String?
    var xuhao: Int?
    var hgVisitCount: Int?
    var dingwei: String?
    var address: String?
    var content2: String?
    var content3: String?
    var jl2name: String?
    var content4: String?
    var paixu: Int?
    var averageRemark: Int?
    var appCityStr: String?
    
    init(json: SwiftyJSON.JSON) {
        self.image = json["photo"].string
        self.name = json["name"].string
        self.liupai = json["liupai"].string
        self.szSheng = json["szSheng"].string
        self.szShi = json["szShi"].int
        self.szQu = json["szQu"].string
        self.renzheng = json["renzheng"].int
        self.tel = json["tel"].string
        self.pic = json["pic"].string
        self.jl1name = json["jl1name"].string
        self.ry2 = json["ry2"].string
        self.jl2username = json["jl2username"].string
        self.ry1 = json["ry1"].string
        self.tj = json["tj"].int
        self.ry4 = json["ry4"].string
        self.ry3 = json["ry3"].string
        self.jl1username = json["jl1username"].string
        self.pic1 = json["pic1"].string
        self.balance = json["balance"].int
        self.pic5 = json["pic5"].string
        self.pic4 = json["pic4"].string
        self.pic3 = json["pic3"].string
        self.pic2 = json["pic2"].string
        self.fuwu = json["fuwu"].string
        self.regTime = json["regTime"].string
        self.classId = json["classId"].int
        self.dengji = json["dengji"].int
        self.loginCount = json["loginCount"].int
        self.content = json["content"].string
        self.jlVisitCount = json["jlVisitCount"].int
        self.jifen = json["jifen"].string
        self.user_Name = json["user_Name"].string
        self.mobile = json["mobile"].string
        self.birthday = json["birthday"].string
        self.sex = json["sex"].string
        self.niming = json["niming"].string
        self.userVisitCount = json["userVisitCount"].int
        self.regIp = json["regIp"].string
        self.waiyu = json["waiyu"].string
        self.contact = json["contact"].string
        self.jl2photo = json["jl2photo"].string
        self.version = json["version"].int
        self.id = json["id"].int
        self.huanjing = json["huanjing"].string
        self.headpic = json["headpic"].string
        self.lastLoginIp = json["lastLoginIp"].string
        self.jl1photo = json["jl1photo"].string
        self.isUpdated = json["isUpdated"].int
        self.money = json["money"].int
        self.shizhi = json["shizhi"].string
        self.publish = json["publish"].string
        self.qq = json["qq"].string
        self.lastLoginTime = json["lastLoginTime"].string
        self.publishTitle = json["publishTitle"].string
        self.isLock = json["isLock"].int
        self.zip = json["zip"].string
        self.sharedUrl = json["sharedUrl"].string
        self.mail = json["mail"].string
        self.jl2desc = json["jl2desc"].string
        self.jl1desc = json["jl1desc"].string
        self.appCity = json["appCity"].int
        self.timeTable = json["timeTable"].string
        self.photo = json["photo"].string
        self.xuhao = json["xuhao"].int
        self.hgVisitCount = json["hgVisitCount"].int
        self.dingwei = json["dingwei"].string
        self.address = json["address"].string
        self.content2 = json["content2"].string
        self.content3 = json["content3"].string
        self.jl2name = json["jl2name"].string
        self.content4 = json["content4"].string
        self.paixu = json["paixu"].int
        self.averageRemark = json["averageRemark"].int
        self.appCityStr = json["appCityStr"].string
    }
}

class cityInfo {
    var id: Int?
    var letter: String?
    var name: String?
    
    func getCityInfo(json: SwiftyJSON.JSON){
        //let city = json["cityList"].dictionary!
        self.id = json["id"].int
        self.letter = json["letter"].string
        self.name = json["name"].string
    }
}

//教练
class CoachInfo {
    var tel: String?
    var ry2: String?
    var ry1: String?
    var tj: Int?
    var ry4: String?
    var ry3: String?
    var pic1: String?
    var balance: Int?
    var age: Int?
    var pic: String?
    var pic5: String?
    var pic4: String?
    var video: String?
    var pic3: String?
    var pic2: String?
    var szQu: Int?
    var fuwu: Int?
    var classId: Int?
    var regTime: String?
    var dengji: Int?
    var loginCount: Int?
    var content: String?
    var szShi: Int?
    var jifen: Int?
    var user_Name: String?
    var birthday: String?
    var sex: String?
    var jibie: String?
    var niming: Int?
    var duanwei: String?
    var regIp: String?
    var waiyu: String?
    var version: Int?
    var id: Int?
    var lastLoginIp: String?
    var huanjing: String?
    var headpic: String?
    var isUpdated: Int?
    var name: String?
    var money: Int?
    var visitCount: Int?
    var shizhi: String?
    var publish: String?
    var lastLoginTime: String?
    var publishTitle: String?
    var qq: String?
    var isLock: Int?
    var zip: String?
    var sharedUrl: String?
    var mail: String?
    var videoThumb: String?
    var szSheng: Int?
    var appCity: Int?
    var timeTable: String?
    var renzheng: Int?
    var liupai: String?
    var photo: String?
    var xuhao: String?
    var dingwei: String?
    var address: String?
    var content2: String?
    var content3: String?
    var content4: String?
    var shoufei: String?
    var paixu: Int?
    var appCityStr: String?
    
    init() {
        
    }
    
    init(json: SwiftyJSON.JSON) {
        self.tel = json["tel"].string
        self.ry2 = json["ry2"].string
        self.ry1 = json["ry1"].string
        self.tj = json["tj"].int
        self.ry4 = json["ry4"].string
        self.ry3 = json["ry3"].string
        self.pic1 = json["pic1"].string
        self.balance = json["balance"].int
        self.age = json["age"].int
        self.pic5 = json["pic5"].string
        self.pic = json["pic"].string
        self.pic4 = json["pic4"].string
        self.video = json["video"].string
        self.pic3 = json["pic3"].string
        self.pic2 = json["pic2"].string
        self.szQu = json["szQu"].int
        self.fuwu = json["fuwu"].int
        self.classId = json["classId"].int
        self.regTime = json["regTime"].string
        self.dengji = json["dengji"].int
        self.loginCount = json["loginCount"].int
        self.content = json["content"].string
        self.szShi = json["szShi"].int
        self.jifen = json["jifen"].int
        self.user_Name = json["user_Name"].string
        self.birthday = json["birthday"].string
        self.sex = json["sex"].string
        self.jibie = json["jibie"].string
        self.niming = json["niming"].int
        self.duanwei = json["duanwei"].string
        self.regIp = json["regIp"].string
        self.waiyu = json["waiyu"].string
        self.version = json["version"].int
        self.id = json["id"].int
        self.lastLoginIp = json["lastLoginIp"].string
        self.huanjing = json["huanjing"].string
        self.headpic = json["headpic"].string
        self.isUpdated = json["isUpdated"].int
        self.name = json["name"].string
        self.money = json["money"].int
        self.visitCount = json["visitCount"].int
        self.shizhi = json["shizhi"].string
        self.publish = json["publish"].string
        self.lastLoginTime = json["lastLoginTime"].string
        self.publishTitle = json["publishTitle"].string
        self.qq = json["qq"].string
        self.isLock = json["isLock"].int
        self.zip = json["zip"].string
        self.sharedUrl = json["sharedUrl"].string
        self.mail = json["mail"].string
        self.videoThumb = json["videoThumb"].string
        self.szSheng = json["szSheng"].int
        self.appCity = json["appCity"].int
        self.timeTable = json["timeTable"].string
        self.renzheng = json["renzheng"].int
        self.liupai = json["liupai"].string
        self.photo = json["photo"].string
        self.xuhao = json["xuhao"].string
        self.dingwei = json["dingwei"].string
        self.address = json["address"].string
        self.content2 = json["content2"].string
        self.content3 = json["content3"].string
        self.content4 = json["content4"].string
        self.shoufei = json["shoufei"].string
        self.paixu = json["paixu"].int
        self.appCityStr = json["appCityStr"].string
        
    }
    
}

class ExtraOrderInfo {
    var uniOrderId: String?
    var status: Int?
    init(json: SwiftyJSON.JSON) {
        self.uniOrderId = json["uniOrderId"].string
        self.status = json["status"].int
    }
}

class Teaching {
    var id: Int?
    var fee: Int?
    var content: String?
    var jlId: Int?
    var closedTime: String?
    var status: Int?
    var createdTime: String?
    var videoThumb: String?
    var userId: Int?
    var video: String?
    var version: Int?
    var user: UserInfo?
    var applyCoachCount: Int?
    var extraOrderInfo: ExtraOrderInfo?
    
    init(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.fee = json["fee"].int
        self.content = json["content"].string
        self.jlId = json["jlId"].int
        self.closedTime = json["closedTime"].string
        self.status = json["status"].int
        self.createdTime = json["createdTime"].string
        self.videoThumb = json["videoThumb"].string
        self.userId = json["userId"].int
        self.video = json["video"].string
        self.version = json["version"].int
        self.user = UserInfo(json: json["user"])
        self.applyCoachCount = json["applyCoachCount"].int
        self.extraOrderInfo = ExtraOrderInfo(json: json["extraOrderInfo"])
    }
    
}

class TeachingRecord {
    var id : Int?
    var content : String?
    var teachingId : Int?
    var createdTime : String?
    var version : Int?
    var fromUser : Int?
    var audio: String?
    var audio1 : String?
    var audio2 : String?
    var audio3 : String?
    var coach: CoachInfo?
    var user: UserInfo?
    
    init(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.content = json["content"].string
        self.teachingId = json["teachingId"].int
        self.createdTime = json["createdTime"].string
        self.version = json["version"].int
        self.fromUser = json["fromUser"].int
        self.audio = json["audio"].string
        self.audio1 = json["audio1"].string
        self.audio2 = json["audio2"].string
        self.audio3 = json["audio3"].string
        self.coach = CoachInfo(json: json["coach"])
        self.user = UserInfo(json: json["user"])

    }
    
    init() {
        
    }
}

class LessonInfo {
    var id: Int?
    var jlId: Int?
    var price: Int?
    var expPrice: Int?
    var startDate: String?
    var endDate: String?
    var pic: String?
    var description: String?
    var isUpdated: Int?
    var sharedUrl: String?
    var studentCount: Int?
    var location: String?
    var classCount: Int?
    var name: String?
    var detailTime: String?
    var version: Int?
    
    var hgId: Int?
    var jl1Name: String?
    var jl1Pic: String?
    var jl1Desc: String?
    var jl2Name: String?
    var jl2Pic: String?
    var jl2Desc: String?
    
    init(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.jlId = json["jlId"].int
        self.price = json["price"].int
        self.expPrice = json["expPrice"].int
        self.isUpdated = json["isUpdated"].int
        self.studentCount = json["studentCount"].int
        self.classCount = json["classCount"].int
        self.version = json["version"].int
        self.startDate = json["startDate"].string
        self.endDate = json["endDate"].string
        self.pic = json["pic"].string
        self.description = json["description"].string
        self.sharedUrl = json["sharedUrl"].string
        self.location = json["location"].string
        self.name = json["name"].string
        self.detailTime = json["detailTime"].string
        
        self.hgId = json["hgId"].int
        self.jl1Name = json["jl1Name"].string
        self.jl1Pic = json["jl1Pic"].string
        self.jl1Desc = json["jl1Desc"].string
        self.jl2Name = json["jl2Name"].string
        self.jl2Pic = json["jl2Pic"].string
        self.jl2Desc = json["jl2Desc"].string
    }
    
}

class RemarkOld {
    var remarkStars: Int?
    var teachingId: Int?
    var remarkContent: String?
    var user: UserInfo?
    var coach: CoachInfo?
    
    init(json: SwiftyJSON.JSON) {
        self.remarkStars = json["remarkStars"].int
        self.teachingId = json["teachingId"].int
        self.remarkContent = json["remarkContent"].string
        self.coach = CoachInfo(json: json["coach"])
        self.user = UserInfo(json: json["user"])
    }
    
}

class Remark {
    var id: Int?
    var version: Int?
    var userId: Int?
    var toUserId: Int?
    var stars: Int?
    var actionType: Int?
    var orderId: Int?
    var remarkType: Int?
    var toLessonId: Int?
    var toUserType: Int?
    var content: String?
    var remarkTime: String?
    
    init(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.version = json["version"].int
        self.userId = json["userId"].int
        self.toUserId = json["toUserId"].int
        self.stars = json["stars"].int
        self.actionType = json["actionType"].int
        self.orderId = json["orderId"].int
        self.remarkType = json["remarkType"].int
        self.toLessonId = json["toLessonId"].int
        self.toUserType = json["toUserType"].int
        self.content = json["content"].string
        self.remarkTime = json["remarkTime"].string
    }
}

class UserRemark {
    var remark: Remark?
    var user: EoUserInfo?
    init(json: SwiftyJSON.JSON) {
        self.remark = Remark(json: json["remark"])
        if json["userJl"].isExists() {
            self.user = EoUserInfo(json: json["userJl"])
        } else if json["userHg"].isExists() {
            self.user = EoUserInfo(json: json["userHg"])
        } else if json["user"].isExists() {
            self.user = EoUserInfo(json: json["user"])
        }
    }
}

class ExpOrder {
    var status: Int?
    var toLessonId: Int?
    var applyTime: String?
    var actionType: Int?
    var version: Int?
    var expTime: String?
    var id: Int?
    var toUserType: Int?
    var price: Int?
    var toUserId: Int?
    var userId: Int?
    var mobile: String?
    init(json: SwiftyJSON.JSON) {
        self.status = json["status"].int
        self.toLessonId = json["toLessonId"].int
        self.applyTime = json["applyTime"].string
        self.actionType = json["actionType"].int
        self.version = json["version"].int
        self.expTime = json["expTime"].string
        self.id = json["id"].int
        self.toUserType = json["toUserType"].int
        self.price = json["price"].int
        self.toUserId = json["toUserId"].int
        self.mobile = json["mobile"].string
    }
}

class EoUserInfo {
    var id: Int?
    var name: String?
    var pic: String?
    init(json: SwiftyJSON.JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.pic = json["pic"].string
    }
}

class EoList {
    var expOrder: ExpOrder?
    var user: EoUserInfo?
    var lesson: LessonInfo?
    var extraOrderInfo: ExtraOrderInfo?
    init(json: SwiftyJSON.JSON) {
        self.expOrder = ExpOrder(json: json["expOrder"])
        
        if json["userHg"].isExists() {
            self.user = EoUserInfo(json: json["userHg"])
        } else  if json["userJl"].isExists() {
            self.user = EoUserInfo(json: json["userJl"])
        }
        
        if json["lessonHg"].isExists() {
            self.lesson = LessonInfo(json: json["lessonHg"])
        } else  if json["lessonJl"].isExists() {
            self.lesson = LessonInfo(json: json["lessonJl"])
        }
        self.extraOrderInfo = ExtraOrderInfo(json: json["extraOrderInfo"])
    }
}

class VipVideo {
    var name: String?
    var description: String?
    var url: String?
    init(json: SwiftyJSON.JSON) {
        self.name = json["name"].string
        self.description = json["description"].string
        self.url = json["url"].string
    }
    
}


