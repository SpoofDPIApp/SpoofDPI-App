//
//  AutoLaunchService.swift
//  SpoofDPI App
//

import Combine
import ServiceManagement

final class AutoLaunchService {
    static let instance = AutoLaunchService()
    
    private lazy var settingsService = SettingsService.instance
    private lazy var windowService = WindowService.instance
    
    private var isEnabledObservation: AnyCancellable?
    
    private init?() {
        guard !ProcessInfo.isPreview else {
            return nil
        }
        
        isEnabledObservation = settingsService.$isAutomaticLaunchEnabled.sink {
            let appService = SMAppService.mainApp
            
            if $0 {
                try? appService.register()
            } else {
                try? appService.unregister()
            }
        }
        
        if let appleEvent = NSAppleEventManager.shared().currentAppleEvent,
           appleEvent.eventID == kAEOpenApplication,
           
           let parameterDescriptor = appleEvent.paramDescriptor(forKeyword: keyAEPropData),
           parameterDescriptor.enumCodeValue == keyAELaunchedAsLogInItem
        {
            windowService.isMainWindowVisible = false
        }
    }
}
