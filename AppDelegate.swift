//
//  AppDelegate.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/28.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        userInfoStore = UserDefaultsUtil.loadUserInfo()
        WXApi.registerApp("wxed773271e809777d")
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool{
        
        WXApi.handleOpenURL(url, delegate:self)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { dic in
                print(dic)
            })
        } else {
            return WXApi.handleOpenURL(url, delegate:self)
        }
        
        return true
    }
    
    // for 9.0
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: AliPayController.resultHandlerBlock)
        } else {
            return WXApi.handleOpenURL(url, delegate:self)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

