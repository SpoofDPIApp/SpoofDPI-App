//
//  LocalizedString.swift
//  SpoofDPI App
//

import SwiftUI

enum LocalizedString {
    enum Scene {
        enum Main {
            enum MenuBar {
                static func aboutButton(appName: String) -> String {
                    let template = String(localized: "Scene.Main.MenuBar.AboutButton.Template")
                    return .init(format: template, appName)
                }
                
                static let updatesButton = String(localized: "Scene.Main.MenuBar.UpdatesButton")
                static let repositoryButton = String(localized: "Scene.Main.MenuBar.RepositoryButton")
            }
            
            enum AboutWindow {
                static let repositoryButton = String(localized: "Scene.Main.AboutWindow.RepositoryButton")
            }
            
            enum SettingsAlert {
                static let libraryParameters = String(localized: "Scene.Main.SettingsAlert.LibraryParameters")
                
                enum Buttons {
                    static let cancel = String(localized: "Scene.Main.SettingsAlert.Buttons.Cancel")
                    static let save = String(localized: "Scene.Main.SettingsAlert.Buttons.Save")
                }
            }
            
            static let protectionToggle = String(localized: "Scene.Main.ProtectionToggle")
            
            enum Status {
                static let initialization = String(localized: "Scene.Main.Status.Initialization")
                static let active = String(localized: "Scene.Main.Status.Active")
            }
            
            static let vpnHint = String(localized: "Scene.Main.VPNHint")
            
            enum Toggles {
                static let automaticLaunch = String(localized: "Scene.Main.Toggles.AutomaticLaunch")
                static let menuBarIcon = String(localized: "Scene.Main.Toggles.MenuBarIcon")
            }
        }
    }
    
    enum MenuBarIcon {
        static let protectionToggle = String(localized: "MenuBarIcon.ProtectionToggle")
        
        static func openButton(appName: String) -> String {
            let template = String(localized: "MenuBarIcon.OpenButton.Template")
            return .init(format: template, appName)
        }
        
        static let quitButton = String(localized: "MenuBarIcon.QuitButton")
    }
    
    enum Updates {
        enum Alert {
            static func title(appName: String) -> String {
                let template = String(localized: "Updates.Alert.Title.Template")
                return .init(format: template, appName)
            }
            
            static let description = String(localized: "Updates.Alert.Description")
            
            enum Buttons {
                static let close = String(localized: "Updates.Alert.Buttons.Close")
                static let update = String(localized: "Updates.Alert.Buttons.Update")
            }
        }
    }
}
