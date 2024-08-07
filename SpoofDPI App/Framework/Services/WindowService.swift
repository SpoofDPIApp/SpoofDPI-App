//
//  WindowService.swift
//  SpoofDPI App
//

import AppKit

final class WindowService {
    static let instance = WindowService()
    
    private var mainWindow: NSWindow
    private var mainWindowVisibilityObservation: NSKeyValueObservation
    
    private init() {
        mainWindow = NSApp.windows.first!
        
        mainWindowVisibilityObservation = mainWindow.observe(\.isVisible) { window, _ in
            NSApp.setActivationPolicy(window.isVisible ? .regular : .accessory)
            
            if window.isVisible {
                NSApp.activate(ignoringOtherApps: true)
            } else {
                NSApp.windows
                    .filter { $0 != window && $0.hasCloseBox }
                    .forEach { $0.setIsVisible(false) }
            }
        }
    }
    
    var isMainWindowVisible: Bool {
        get {
            mainWindow.isVisible
        } set {
            mainWindow.setIsVisible(newValue)
        }
    }
}
