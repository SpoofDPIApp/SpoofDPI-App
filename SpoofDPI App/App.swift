//
//  App.swift
//  SpoofDPI App
//

import FirebaseAnalytics
import FirebaseCore
import SwiftUI

@main
struct App: SwiftUI.App {
    @NSApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        MainScene()
    }
}

private extension App {
    final class Delegate: NSObject, NSApplicationDelegate {
        func applicationDidFinishLaunching(_ notification: Notification) {
            configureFirebase()
            
            _ = AutoLaunchService.instance
            _ = MenuBarIconService.instance
            _ = ProtectionService.instance
            _ = UpdateService.instance
            _ = WindowService.instance
        }
        
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            return false
        }
        
        func applicationWillTerminate(_ notification: Notification) {
            ProtectionService.instance.prepareForTermination()
        }
        
        private func configureFirebase() {
            let secretDataKeys = [
                "API_KEY",
                "GCM_SENDER_ID",
                "GOOGLE_APP_ID"
            ]
            
            guard
                let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
                let availableKeys = NSDictionary(contentsOfFile: path)?.allKeys.compactMap({ $0 as? String }),
                secretDataKeys.allSatisfy({ availableKeys.contains($0) })
            else {
                return
            }
            
            FirebaseApp.configure()
            Analytics.setAnalyticsCollectionEnabled(true)
        }
    }
}
