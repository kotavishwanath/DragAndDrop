//
//  AppDelegate.swift
//  Drag&DropCollectionView
//
//  Created by Vishwanath Kota on 07/01/2020.
//  Copyright © 2020 Vishwanath Kota. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        proceedWithCameraAccess(identifier: "")
        return true
    }
    
    func proceedWithCameraAccess(identifier: String){
      // handler in .requestAccess is needed to process user's answer to our request
      AVCaptureDevice.requestAccess(for: .video) { success in
        if success { // if request is granted (success is true)
          DispatchQueue.main.async {
//            self.performSegue(withIdentifier: identifier, sender: nil)
          }
        } else { // if request is denied (success is false)
          // Create Alert
          let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)

          // Add "OK" Button to alert, pressing it will bring you to the settings app
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
          }))
          // Show the alert with animation
           // show alert
           let alertWindow = UIWindow(frame: UIScreen.main.bounds)
           alertWindow.rootViewController = UIViewController()
           alertWindow.windowLevel = UIWindow.Level.alert + 1;
           alertWindow.makeKeyAndVisible()
           alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
      }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

