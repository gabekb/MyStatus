//
//  AppDelegate.swift
//  MyStatus
//
//  Created by GKB on 4/12/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit
import CoreData
import Parse
import UserNotifications
import FBSDKCoreKit
import GoogleMobileAds
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BWWalkthroughViewControllerDelegate{

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
   
        FirebaseApp.configure()
        
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "94df590cc1a134ba0011d714dfca139d4d257bc8"
            ParseMutableClientConfiguration.clientKey = "c86acd1bf3caa15325ec5677c9c9f69cb37136ce"
            ParseMutableClientConfiguration.server = "http://ec2-54-149-195-80.us-west-2.compute.amazonaws.com:80/parse"
            
            
        })
        
        Parse.initialize(with: parseConfiguration)
        
        
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            /*
             let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
             let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
             var noPushPayload = false;
             if let options = launchOptions {
             noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
             }
             if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
             PFAnalytics.trackAppOpened(launchOptions: launchOptions)
             }
             */
        }
        
        
        
        registerForRemoteNotification()
        
        //registerForPushNotifications(application: application)
        
        
        FBSDKApplicationDelegate.sharedInstance()
        FBSDKAppEvents.activateApp()
        
        
        
        if PFUser.current() != nil {
            print(PFUser.current()!)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabPageVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            
            let query : PFQuery = PFUser.query()!
            
            query.whereKey("objectId", equalTo: PFUser.current()?.objectId!)
            query.findObjectsInBackground(block: { (object, error) in
                if error != nil {
                    
                    
                }else {
                    for item in object! {
                        if let x = item as? PFObject{
                            x.setObject(PFInstallation.current()!, forKey: "Installation")
                            x.saveInBackground()
                        }
                        
                    }
                    
                }
            })

        }
        
        
        
        
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2927420295620779~6081108847")
        
        
        
        let installation = PFInstallation.current()
        
        if installation?.badge != 0{
            installation?.badge = 0
            installation?.saveInBackground(block: { (success, error) in
                if error != nil{
                    
                    print("Badge could not be cleared")
                }else{
                    
                  UIApplication.shared.applicationIconBadgeNumber = 0
                    
                }
            })
        }
        
        
        
        return true
        
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self as? UNUserNotificationCenterDelegate
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UNNotificationSettings) {
        if notificationSettings.alertSetting != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        //installation?.setObject(PFUser.current()!, forKey: "user")
        installation?.saveInBackground()
        
        
        
        PFPush.subscribeToChannel(inBackground: "") { (succeeded, error) in // (succeeded: Bool, error: NSError?) is now (succeeded, error)
            
            if succeeded {
                print("myStatus successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("myStatus failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error!)
            }
        }
        
        
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handle(userInfo)
        
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if PFUser.current() != nil {
            print(PFUser.current()!)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabPageVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        let installation = PFInstallation.current()
        
        if installation?.badge != 0{
            installation?.badge = 0
            installation?.saveInBackground(block: { (success, error) in
                if error != nil{
                    
                    print("Badge could not be cleared")
                }else{
                    
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    
                }
            })
        }
        
        
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyStatus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

