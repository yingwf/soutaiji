//
//  Register1ViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class Register1ViewController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConformField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var userType = 0
    
    var isCheckRead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkImage.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkRead))
        checkImage.addGestureRecognizer(tap)
        
        self.setBackButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkRead(){
        isCheckRead = !isCheckRead
        
        if isCheckRead {
            self.checkImage.image = UIImage(named: "ic_checkbox_on")
        }else{
            self.checkImage.image = UIImage(named: "ic_checkbox_off")
        }
        
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        
        if (userNameField.text!.isEmpty){
            let alert = UIAlertView()
            alert.message = "请输入用户名"
            alert.addButtonWithTitle("确定")
            alert.show()
            return
        }
        if passwordField.text!.isEmpty{
            let alert = UIAlertView()
            alert.message = "请输入密码"
            alert.addButtonWithTitle("确定")
            alert.show()
            return
        }
        if passwordConformField.text!.isEmpty{
            let alert = UIAlertView()
            alert.message = "请输入确认密码"
            alert.addButtonWithTitle("确定")
            alert.show()
            return
        }
        if passwordField.text! != passwordConformField.text!{
            let alert = UIAlertView()
            alert.message = "确认密码输入不正确，请重新输入"
            alert.addButtonWithTitle("确定")
            alert.show()
            return
        }
        if emailField.text!.isEmpty{
            let alert = UIAlertView()
            alert.message = "请输入邮箱"
            alert.addButtonWithTitle("确定")
            alert.show()
            return
        }
        
        self.registerBtn.enabled = false
        self.registerBtn.setTitle("", forState: UIControlState.Normal)
        let url = REGISTER
        //let userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as! Int
        let parameters =  [ "username":userNameField.text!,"password":encryptPassword(passwordField.text!),"email":emailField.text!,"userType":self.userType ] as [String : AnyObject]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Alamofire.request(.POST, url, parameters: parameters).responseJSON { response in
            if(response.data != nil && response.result.isSuccess){
                let json=SwiftyJSON.JSON(response.result.value!)
                self.registerBtn.setTitle("注册", forState: UIControlState.Normal)
                self.registerBtn.enabled = true
                self.praseResult(json)
            }
            else{
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.registerBtn.setTitle("注册", forState: UIControlState.Normal)
                self.registerBtn.enabled = true                
                let alert = UIAlertView()
                alert.message = "注册失败，请重新注册"
                alert.addButtonWithTitle("确定")
                alert.show()
            }
            
        }
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let status = json["success"].boolValue
        if status {
            //设置存储信息
            NSUserDefaults.standardUserDefaults().setObject(self.userNameField.text, forKey: "userName")
            NSUserDefaults.standardUserDefaults().setObject(self.passwordField.text, forKey: "password")
            NSUserDefaults.standardUserDefaults().setObject(userType, forKey: "userType")
            
            switch userType {
            case 0:
                let userModifyInfoViewController=self.storyboard?.instantiateViewControllerWithIdentifier("UserGeneralModifyInfoViewController") as! UserGeneralModifyInfoViewController
                self.navigationController?.pushViewController(userModifyInfoViewController, animated: true)
            case 1:
                let userClubModifyInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserClubModifyInfoViewController") as! UserClubModifyInfoViewController
                self.navigationController?.pushViewController(userClubModifyInfoViewController, animated: true)
            case 2:
                let userCoachModifyInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserCoachModifyInfoViewController") as! UserCoachModifyInfoViewController
                self.navigationController?.pushViewController(userCoachModifyInfoViewController, animated: true)
            default:
                break
            }

        }else{
            let alert = UIAlertView()
            alert.message = "注册失败，" + json["message"].string!
            alert.addButtonWithTitle("确定")
            alert.show()
        }
    }
    



}
