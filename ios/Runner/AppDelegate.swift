import UIKit
import Flutter
import GoogleMobileAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["0D96772D-E496-417F-8039-E9CFA525627F"] /// added this line
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
