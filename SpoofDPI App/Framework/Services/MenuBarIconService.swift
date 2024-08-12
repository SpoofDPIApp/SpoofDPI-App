//
//  MenuBarIconService.swift
//  SpoofDPI App
//

import AppKit
import Combine

final class MenuBarIconService {
    static let instance = MenuBarIconService()
    
    private let correspondingItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.squareLength
    )
    
    private let protectionService = ProtectionService.instance
    private let settingsService = SettingsService.instance
    
    private var isVisibleObservation: AnyCancellable?
    private var isProtectionActiveObservation: AnyCancellable?
    
    private init?() {
        guard !ProcessInfo.isPreview else {
            return nil
        }
        
        let menu = NSMenu()
        
        menu.addItem(
            withTitle: LocalizedString.MenuBarIcon.openButton(appName: Bundle.main.name),
            action: #selector(applicationDelegate?.openMenuBarIconAction),
            keyEquivalent: ""
        )
        
        menu.addItem(
            withTitle: LocalizedString.MenuBarIcon.quitButton,
            action: #selector(applicationDelegate?.quitMenuBarIconAction),
            keyEquivalent: ""
        )
        
        correspondingItem.menu = menu
        
        isVisibleObservation = settingsService.$isMenuBarIconEnabled.sink { [correspondingItem] in
            correspondingItem.isVisible = $0
        }
        
        isProtectionActiveObservation = protectionService.$isActive.sink { [correspondingItem] in
            let image: NSImage
            
            if #available(macOS 14, *) {
                image = $0 ? SystemSymbol.sunglassesFill : SystemSymbol.sunglasses
            } else {
                let imageResources = ImageResource.MenuBarIcon.self
                image = .init(resource: $0 ? imageResources.filled : imageResources.regular)
            }
            
            correspondingItem.button?.image = image
        }
    }
    
    private var applicationDelegate: App.Delegate? {
        NSApplication.shared.delegate as? App.Delegate
    }
}

fileprivate extension App.Delegate {
    @objc func openMenuBarIconAction() {
        WindowService.instance.isMainWindowVisible = true
    }
    
    @objc func quitMenuBarIconAction(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}
