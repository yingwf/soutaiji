//
//  functions.swift
//  SouTaiji
//
//  Created by  ywf on 16/5/3.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON



extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        if urlString == nil || urlString!.isEmpty{
            return
        }
        if let url = NSURL(string: urlString!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if data != nil{
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}

func doRequestGetImage(imageURL: String){
    var image: UIImage?
    Alamofire.request(.GET, imageURL).response { (request, response,  data, error) in
        image = UIImage(data: data! as NSData,scale: 1)
        NSLog("\(imageURL), json = \(data)")
        if error != nil{
            NSLog("\(imageURL)失败,\(error)")
        }
    }
}

extension String {
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash as String)
    }
}

func encryptPassword(password: String) -> String{
    if password.isEmpty {
        return ""
    }
    let pwd = String(password.characters.reverse()) as NSString
    
    let len = pwd.length/2
    
    let leftPassword = pwd.substringToIndex(len)
    let rightPassword = pwd.substringFromIndex(len)
    let encryptPassword = (leftPassword.md5 + rightPassword.md5).md5
    return encryptPassword
    
}

func cityParse() -> [CFCityPickerVC.CityModel] {
    
    var cityModels: [CFCityPickerVC.CityModel] = []
    var cityDic = Dictionary<String,[CFCityPickerVC.CityModel]>()
    
    if cityList.count == 0{
        return cityModels
    }
    
    for (_,city) in cityList {
        let id = city.id!
        let letter = city.letter!
        let spell = city.letter!
        let pid = Int((letter as NSString).characterAtIndex(0))
        let name = city.name!
        
        let cityModel = CFCityPickerVC.CityModel(id: id, pid: pid, name: name, spell: spell)
        
        if cityDic[spell] == nil{
            cityDic[spell] = [cityModel]
        }else{
            cityDic[spell]!.append(cityModel)
        }
    }
    
    for (key,citys) in cityDic{
        let id = Int((key as NSString).characterAtIndex(0))
        let spell = key
        let pid = 0
        let name = key
        let cityModel = CFCityPickerVC.CityModel(id: id, pid: pid, name: name, spell: spell)
        cityModel.children = citys
        cityModels.append(cityModel)
    }
    return cityModels
}
