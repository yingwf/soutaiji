//
//  HomeViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UITabBarController {
    
    let tabDefaultImageArray = ["ic_tab_taiji_off", "ic_tab_teach_off","ic_tab_mine_off"]
    let tabSelectedImageArray = ["ic_tab_taiji_on", "ic_tab_teach_on","ic_tab_mine_on"]
    let titleArray=["首页", "悬赏指正","我的"]
    let tabDefaultController = ["nav_TaijiSquareViewController","nav_QuestionViewController","nav_LoginViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = []
        for i in 0 ... tabDefaultController.count - 1{
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier(tabDefaultController[i])
            self.viewControllers?.append(controller!)
        }
        global.loginViewController = (self.viewControllers![2] as! UINavigationController).childViewControllers.first as! LoginViewController


        // Do any additional setup after loading the view.
        if let items = self.tabBar.items{
            for i in 0 ... items.count - 1{
                
                var image:UIImage = UIImage(named: tabDefaultImageArray[i])!
                var selectedimage:UIImage = UIImage(named: tabSelectedImageArray[i])!
                let item = items[i]
                item.title=titleArray[i]
                item.setTitleTextAttributes([NSForegroundColorAttributeName :
                    UIColor(red: 0xff/255, green: 0xff/255, blue: 0xff/255, alpha: 0.44)], forState: UIControlState.Normal)
                item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 0xff/255, green: 0xff/255, blue: 0xff/255, alpha: 1)], forState: UIControlState.Selected)
                
                image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
                selectedimage = selectedimage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
                item.selectedImage = selectedimage;
                item.image = image;
                
            }
        }

        //读取城市列表
        doRequest(getNewCityListByLetter, parameters: nil, praseMethod: praseCityList)
        if userInfoStore.isLogin {
            global.loginViewController?.autoLogin()
        }
    }
    
    func praseCityList(json: SwiftyJSON.JSON){
        if json["success"]{
            let list = json["cityList"].array
            if list != nil && list!.count > 0{
                for index in 0...list!.count - 1{
                    let cityId = list![index]["id"].int!
                    let city = cityInfo()
                    city.getCityInfo(list![index])
                    cityList[cityId] = city
                }
            }
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("item selected")
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
