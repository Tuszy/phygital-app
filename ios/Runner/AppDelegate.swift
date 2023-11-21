import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
#if DEBUG
            AppCenter.start(withAppSecret: "4f3ac864-2039-446c-9b66-33767dfaa0a1", services:[
              Analytics.self,
              Crashes.self
            ])
    #else
            AppCenter.start(withAppSecret: "4f3ac864-2039-446c-9b66-33767dfaa0a1", services:[
              Analytics.self,
              Crashes.self,
              Distribute.self
            ])
      #endif
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
