//
//  RegisterViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/10.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerGeneralUser: UIView!
    @IBOutlet weak var registerCoachUser: UIView!
    @IBOutlet weak var registerClubUser: UIView!

    
    var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerGeneralUser.userInteractionEnabled = true
        let tapUser = UITapGestureRecognizer(target: self, action: #selector(registerlUserAction(_:)))
        registerGeneralUser.tag = 0
        registerGeneralUser.addGestureRecognizer(tapUser)
        
        registerCoachUser.userInteractionEnabled = true
        let tapCoach = UITapGestureRecognizer(target: self, action: #selector(registerlUserAction(_:)))
        registerCoachUser.tag = 2
        registerCoachUser.addGestureRecognizer(tapCoach)
        
        registerClubUser.userInteractionEnabled = true
        let tapClub = UITapGestureRecognizer(target: self, action: #selector(registerlUserAction(_:)))
        registerClubUser.tag = 1
        registerClubUser.addGestureRecognizer(tapClub)
        
        
        self.setBackButton()
    }
    
    
    func registerlUserAction(sender: UITapGestureRecognizer) {
        guard let userType = sender.view?.tag else {
            return
        }
        let register1Controller = self.storyboard?.instantiateViewControllerWithIdentifier("Register1ViewController") as! Register1ViewController
        register1Controller.userType = userType
        self.navigationController?.pushViewController(register1Controller, animated: true)

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
