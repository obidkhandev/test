import UIKit
import Flutter
import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    YMKMapKit.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
    YMKMapKit.setApiKey("cca96377-c6c8-4a4d-9e78-34732bedf7f9") // Your generated API key
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}