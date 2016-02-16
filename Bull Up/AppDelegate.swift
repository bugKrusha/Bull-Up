//
//  AppDelegate.swift
//  Bull Up
//
//  Created by Jon-Tait Beason on 1/27/16.
//  Copyright © 2016 IOBI Education. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions:[NSObject: AnyObject]?) -> Bool {
        UINavigationBar.bu_stylize()
        return true
    }
}

extension UINavigationBar {
    private static func bu_stylize() {
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().setBackgroundImage(UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}