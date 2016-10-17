//
//  SetTableViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/3.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {

    let helpContent = "搜太极网，是中国第一个将全国各地的太极会馆企业、专业太极拳教练以及太极文化、健康生态相关产品，集中推广展现和多方供求互通的专业平台，在这里，太极企业可以得到充分地展示和推广，同时还可以在这个平台寻找到优秀的太极教练；同样，太极教练在这里得到全面展示的同时，还可以寻找到理想中的太极会馆企业；对于各地有学习太极拳需求的个人和集团企业，可以在这个平台寻求优质可靠的太极会馆企业或聘用私人太极拳教练为其做团队太极拳培训；还有，对于所有用户，在这里可以买到独具特色、质优价廉的太极文化及健康生态相关产品。"
    let versionContent = "当前版本1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.setBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            return 5
//        case 1,2,4:
//            return 44
//        case 3:
//            return 27
//        default:
//            break
//        }
//        return 44
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let helpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
            helpViewController.title = "使用帮助"
            helpViewController.content = self.helpContent
            self.navigationController?.pushViewController(helpViewController, animated: true)
        } else if indexPath.row == 2 {
            let helpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
            helpViewController.title = "版本信息"
            helpViewController.content = self.versionContent
            self.navigationController?.pushViewController(helpViewController, animated: true)
        }
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        userInfoStore.isLogin = false
        UserDefaultsUtil.saveUserInfo(userInfoStore)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    

}
