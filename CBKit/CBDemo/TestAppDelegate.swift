//
//  TestAppDelegate.swift
//  CBDemo
//
//  Created by 李笑清 on 2021/1/2.
//  Copyright © 2021 李笑清. All rights reserved.
//

import Foundation

@objcMembers
class TestAppDelegate:  CBAppDelegate{
    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NSLog("xxx");
        return true;
    }
}
