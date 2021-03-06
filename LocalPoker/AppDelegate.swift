//
//  AppDelegate.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/17/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		let navigationController = window?.rootViewController as! UINavigationController
		navigationController.navigationBar.tintColor = UIColor.whiteColor()
		
		let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
		application.registerUserNotificationSettings(notificationSettings)
		application.registerForRemoteNotifications()
		
		subscribeToNewEvents()
		
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
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		if let pushInfo = userInfo as? [String: NSObject] {
			let notification = CKNotification(fromRemoteNotificationDictionary: pushInfo)
			
			print(notification)
		}
	}

	private func subscribeToNewEvents() {
		if !NSUserDefaults.standardUserDefaults().boolForKey("subscribedToEvents") {
			let predicate = NSPredicate(value: true)
			let subscription = CKSubscription(recordType: "Event", predicate: predicate, options: .FiresOnRecordCreation)
			let notification = CKNotificationInfo()
			notification.alertBody = "New Poker event has been scheduled, confirm your attendance."
			notification.soundName = UILocalNotificationDefaultSoundName
			notification.shouldBadge = true
			subscription.notificationInfo = notification
			
			CKContainer.defaultContainer().publicCloudDatabase.saveSubscription(subscription, completionHandler: { (result, error) -> Void in
				if let error = error {
					print(error)
				} else if let _ = result {
					NSUserDefaults.standardUserDefaults().setBool(true, forKey: "subscribedToEvents")
				}
			})
		}
	}
}

