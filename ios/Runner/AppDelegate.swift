import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let path = Bundle.main.path(forResource: "GoogleMapsAPIKey", ofType: "xcconfig") {
        if let content = try? String(contentsOfFile: path),
           let key = content.components(separatedBy: "=").last?.trimmingCharacters(in: .whitespacesAndNewlines) {
            GMSServices.provideAPIKey(key)
        }
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
