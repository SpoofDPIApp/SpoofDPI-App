//
//  MainScene.ContentView.swift
//  SpoofDPI App
//

import SwiftUI

extension MainScene {
    struct ContentView: View {
        typealias LocalizedString = SpoofDPI_App.LocalizedString.Scene.Main
        
        @ObservedObject private var protectionService = ProtectionService.instance
        @ObservedObject private var settingsService = SettingsService.instance
        @ObservedObject private var updateService = UpdateService.instance
        
        var body: some View {
            VStack(spacing: 14) {
                if updateService.areUpdatesAvailable {
                    Button(LocalizedString.updateButton) {
                        NSWorkspace.shared.open(Constants.repositoryURL)
                    }
                }
                
                if protectionService.isActive {
                    HStack(spacing: 6) {
                        Text("😎")
                        
                        Text(LocalizedString.Status.active)
                            .bold()
                    }
                } else {
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            ProgressView()
                                .controlSize(.small)
                            
                            Text(LocalizedString.Status.initialization)
                        }
                        
                        Text(LocalizedString.vpnHint)
                            .bold()
                    }
                }
                
                VStack {
                    Toggle(LocalizedString.Toggles.automaticLaunch, isOn: $settingsService.isAutomaticLaunchEnabled)
                    Toggle(LocalizedString.Toggles.menuBarIcon, isOn: $settingsService.isMenuBarIconEnabled)
                }
            }
            .fixedSize()
            .padding()
        }
    }
}

#Preview {
    MainScene.ContentView()
}
