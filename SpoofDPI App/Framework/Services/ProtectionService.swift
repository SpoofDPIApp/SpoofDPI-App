//
//  ProtectionService.swift
//  SpoofDPI App
//

import Foundation

final class ProtectionService: ObservableObject {
    static let instance = ProtectionService()
    
    @Published private(set) var isActive = false
    
    private let fileManager = FileManager.default
    
    private init() {
        guard !ProcessInfo.isPreview else {
            return
        }
        
        maintainProcess()
    }
    
    func prepareForTermination() {
        deactivateLibrary()
    }
    
    private func maintainProcess() {
        deactivateLibrary()
        
        let checkStatusAndReactivateIfNeeded = { [weak self] in
            guard let self else {
                return
            }
            
            isActive = Utils.executeTerminalCommand("ps -A")?.contains(Constants.libraryProcessNamePrefix) == true
            
            if !isActive {
                let deviceArchitecture = Utils.getDeviceArchitecture()
                activateLibrary(for: deviceArchitecture)
            }
        }
        
        DispatchQueue.main.async {
            checkStatusAndReactivateIfNeeded()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            checkStatusAndReactivateIfNeeded()
        }
    }
    
    private func activateLibrary(for deviceArchitecture: SupportedArchitecture) {
        guard
            let path = Bundle.main.path(
                forResource: Constants.libraryProcessNamePrefix + deviceArchitecture.rawValue,
                ofType: ""
            )
        else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            Utils.executeTerminalCommand("\"" + path + "\"")
        }
    }
    
    private func deactivateLibrary() {
        SupportedArchitecture.allCases.forEach {
            Utils.executeTerminalCommand("killall " + Constants.libraryProcessNamePrefix + $0.rawValue)
        }
    }
}
