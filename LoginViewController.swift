//
//  LoginViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

enum UserType: Int {
    case GeneralUser = 0, ClubUser, CoachUser
}

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var userGeneralButton: RadioButton!
    @IBOutlet weak var userCoachButton: RadioButton!
    @IBOutlet weak var userClubButton: RadioButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var userType: Int?
    var forLoginHint = false
    var isAutoLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userGeneralButton.groupButtons = [userGeneralButton,userClubButton,userCoachButton]
        
        closeButton.hidden = !forLoginHint
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //读取上次配置
        userNameField.text = userInfoStore.userName
        passwordField.text = userInfoStore.password
        userType = userInfoStore.userType
        
        if userType == 0 {
            userGeneralButton.selected = true
        }else if userType == 2 {
            userCoachButton.selected = true
        }else if userType == 1 {
            userClubButton.selected = true
        }
    }
    
    func autoLogin() {
        
        isAutoLogin = true
        
        let url = LOGIN
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType] as [String : AnyObject]
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if(response.data != nil && response.result.isSuccess){
                let json=SwiftyJSON.JSON(response.result.value!)
                self.praseResult(json)
            }
        }
        
    }

    @IBAction func registerAction(sender: AnyObject) {
        let registerController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController")
        self.navigationController?.pushViewController(registerController!, animated: true)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if (userNameField.text!.isEmpty){
            self.displayAlertControllerWithMessage("请输入用户名")
            return
        }
        if passwordField.text!.isEmpty{
            self.displayAlertControllerWithMessage("请输入密码")
            return
        }
        guard (self.userType != nil) else{
            self.displayAlertControllerWithMessage("请选择用户类型")
            return
        }
        isAutoLogin = false
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        userInfoStore.userName = userNameField.text!
        userInfoStore.password = passwordField.text!
        userInfoStore.userType = self.userType!
        
        let url = LOGIN
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType] as [String : AnyObject]
        debugPrint(parameters)
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if(response.data != nil && response.result.isSuccess){
                let json=SwiftyJSON.JSON(response.result.value!)
                self.praseResult(json)
            }
            else{
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.displayAlertControllerWithMessage("服务器连接错误，请重新登录")
            }
        }
    }

    func praseResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            let guid = json["json"][0]["Guid"].string
            NSUserDefaults.standardUserDefaults().setObject(guid, forKey: "guid")
            self.getUserInfo()
        }else{
            if !isAutoLogin {
                displayAlertControllerWithMessage("用户名或密码错误，请重新登录")
            }
        }
    }
    
    func getUserInfo() {
        
        let url = getUser
        let parameters =  ["username":userInfoStore.userName,"password":encryptPassword(userInfoStore.password),"userType":userInfoStore.userType] as [String : AnyObject]
        
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if(response.data != nil && response.result.isSuccess){
                let json=SwiftyJSON.JSON(response.result.value!)
                self.praseUserInfoResult(json)
            }
            else{
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if !self.isAutoLogin {
                    self.displayAlertControllerWithMessage("服务器连接错误，请重新登录")
                }
                
            }
        }

    }
    
    
    func praseUserInfoResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        
        if status {
            guard let _ = json["user"].dictionary else {
                return
            }
            
            userInfoStore.isLogin = true
            
            UserDefaultsUtil.saveUserInfo(userInfoStore)
            
            switch userInfoStore.userType {
            case 0:
                //general user
                let userInfo = UserInfo(json: json["user"])
                
                let userViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralViewController") as! UserGeneralViewController
                userViewController.userInfo = userInfo
                
                self.navigationController?.pushViewController(userViewController, animated: true)
                userViewController.navigationItem.hidesBackButton = true
                
            case 1:
                let userInfo = ClubInfo(json: json["user"])
                //coach user
                let userClubViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserClubViewController") as! UserClubViewController
                userClubViewController.userinfo = userInfo
                
                self.navigationController?.pushViewController(userClubViewController, animated: true)
                userClubViewController.navigationItem.hidesBackButton = true
                
            case 2:
                let userInfo = CoachInfo(json: json["user"])
                //coach user
                let myCoachTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyCoachTableViewController") as! MyCoachTableViewController
                myCoachTableViewController.userInfo = userInfo
                
                self.navigationController?.pushViewController(myCoachTableViewController, animated: true)
                myCoachTableViewController.navigationItem.hidesBackButton = true
            default:
                break
            }
            
            if forLoginHint {
                userInfoStore.isLogin = true
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            
        }else{
            if !self.isAutoLogin {
                self.displayAlertControllerWithMessage("用户名或密码错误，请重新登录")
            }
        }
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func gotoFindPassword(sender: AnyObject) {
        let findPasswordViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FindPasswordViewController") as! FindPasswordViewController
        self.navigationController?.pushViewController(findPasswordViewController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func userTypeChanged(sender: AnyObject) {
        self.userType = sender.tag
        userInfoStore.userType = self.userType!
    }

    

}
