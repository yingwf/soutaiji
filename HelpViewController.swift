//
//  HelpViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/3.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    
    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String?
    var navTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let content = self.content {
            contentLabel.text = content
            contentLabel.sizeToFit()
        }
        if let navTitle = self.navTitle {
            self.navigationItem.title = navTitle
        }
        self.setBackButton()
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
