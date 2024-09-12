//
//  MenuBarIconService.swift
//  SpoofDPI App
//

import AppKit
import Combine

final class MenuBarIconService {
    private typealias LocalizedString = SpoofDPI_App.LocalizedString.MenuBarIcon
    
    static let instance = MenuBarIconService()
    
    private let correspondingItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.squareLength
    )
    
    private lazy var protectionService = ProtectionService.instance
    private lazy var settingsService = SettingsService.instance
    private lazy var windowService = WindowService.instance
    
    private var isVisibleObservation: AnyCancellable?
    
    private var isProtectionEnabledObservation: AnyCancellable?
    private var isProtectionActiveObservation: AnyCancellable?
    
    private init?() {
        guard !ProcessInfo.isPreview else {
            return nil
        }
        
        let menu = NSMenu()
        
        menu.items = [
            createProtectionMenuItem(),
            .separator(),
            
            .init(
                title: LocalizedString.openButton(appName: Bundle.main.name),
                action: #selector(showApp),
                keyEquivalent: ""
            ),
            
            .init(
                title: LocalizedString.quitButton,
                action: #selector(quitApp),
                keyEquivalent: ""
            )
        ].map {
            $0.target = self
            return $0
        }
        
        correspondingItem.menu = menu
        
        isVisibleObservation = settingsService.$isMenuBarIconEnabled.sink { [correspondingItem] in
            correspondingItem.isVisible = $0
        }
        
        isProtectionActiveObservation = protectionService.$status.sink { [correspondingItem] in
            let image: NSImage
            let isActive = $0 == .active
            
            if #available(macOS 14, *) {
                let systemSymbol: SystemSymbol = isActive ? .sunglassesFill : .sunglasses
                image = systemSymbol.image
            } else {
                let imageResources = ImageResource.MenuBarIcon.self
                image = .init(resource: isActive ? imageResources.filled : imageResources.regular)
            }
            
            correspondingItem.button?.image = image
        }
    }
    
    private func createProtectionMenuItem() -> NSMenuItem {
        let containerView = NSView()
        let titleLabel = NSTextField(labelWithString: LocalizedString.protectionToggle)
        
        let switchView = NSSwitch().with {
            $0.action = #selector(toggleProtection)
            $0.target = self
        }
        
        isProtectionEnabledObservation = settingsService.$isProtectionEnabled.sink {
            switchView.state = $0 ? .on : .off
        }
        
        [containerView, titleLabel, switchView].forEach {
            if $0 != containerView {
                containerView.addSubview($0)
            }
            
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let insets: (horizontal: CGFloat, vertical: CGFloat) = (14, 2)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: insets.horizontal),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            switchView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            switchView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -insets.horizontal),
            switchView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: insets.vertical),
            switchView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -insets.vertical)
        ])
        
        let menuItem = NSMenuItem()
        menuItem.view = containerView
        
        return menuItem
    }
    
    @objc func toggleProtection() {
        settingsService.isProtectionEnabled.toggle()
    }
    
    @objc func showApp() {
        windowService.isMainWindowVisible = true
    }
    
    @objc func quitApp(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}
