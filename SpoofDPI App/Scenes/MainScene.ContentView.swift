//
//  MainScene.ContentView.swift
//  SpoofDPI App
//

import SwiftUI

extension MainScene {
    struct ContentView: View {
        private typealias LocalizedString = SpoofDPI_App.LocalizedString.Scene.Main
        
        @ObservedObject private var protectionService = ProtectionService.instance
        @ObservedObject private var settingsService = SettingsService.instance
        
        @State private var areSettingsVisible = false
        
        @State private var settingsLibraryParameters = ""
        @State private var settingsLibraryParametersTextFieldID = 0
        
        var body: some View {
            VStack(spacing: 14) {
                HStack {
                    let settingsSymbol = SystemSymbol.gearshape
                    
                    Toggle(LocalizedString.protectionToggle, isOn: $settingsService.isProtectionEnabled)
                        .toggleStyle(.switch)
                    
                    Button("", systemImage: settingsSymbol.name) {
                        settingsLibraryParameters = settingsService.libraryParameters
                        areSettingsVisible = true
                    }
                    .buttonStyle(.borderless)
                    .padding(.bottom, 4)
                    .alert("", isPresented: $areSettingsVisible) {
                        let fixLibraryParametersTextFieldInitialStates = {
                            // Fixes a mysterious SwiftUI bug
                            settingsLibraryParametersTextFieldID += 1
                        }
                        
                        TextField(
                            LocalizedString.SettingsAlert.libraryParameters,
                            text: $settingsLibraryParameters
                        )
                        .autocorrectionDisabled()
                        .id(settingsLibraryParametersTextFieldID)
                        
                        Button(LocalizedString.SettingsAlert.Buttons.save) {
                            settingsService.libraryParameters = settingsLibraryParameters
                            
                            areSettingsVisible = false
                            fixLibraryParametersTextFieldInitialStates()
                        }
                        
                        Button(LocalizedString.SettingsAlert.Buttons.cancel) {
                            areSettingsVisible = false
                            fixLibraryParametersTextFieldInitialStates()
                        }
                    }
                    .dialogIcon(
                        .init(nsImage: settingsSymbol.image)
                    )
                }
                
                switch protectionService.status {
                    case .active:
                        HStack(spacing: 6) {
                            Text("😎")
                            
                            Text(LocalizedString.Status.active)
                                .bold()
                        }
                        .padding(.top, -8)
                        
                    case .initializing:
                        VStack(spacing: 8) {
                            HStack(spacing: 6) {
                                ProgressView()
                                    .controlSize(.small)
                                
                                Text(LocalizedString.Status.initialization)
                            }
                            
                            Text(LocalizedString.vpnHint)
                                .bold()
                        }
                        
                    case .stopped, .unknown:
                        EmptyView()
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
