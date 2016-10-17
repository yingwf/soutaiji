//
//  ShopViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/22.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class ShopViewController: UIViewController, UIWebViewDelegate {

    var webSite: String = "https://shop14462151.koudaitong.com/"
    
    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        
        self.webView = UIWebView(frame: self.view.frame)
        
        self.webView.delegate = self
        
        let url = NSURL(string: self.webSite)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
        self.view.addSubview(self.webView)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.setBackButton()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
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
