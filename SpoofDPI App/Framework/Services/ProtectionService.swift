//
//  ProtectionService.swift
//  SpoofDPI App
//

import Foundation
import Combine

final class ProtectionService: ObservableObject {
    static let instance = ProtectionService()
    
    @Published private(set) var status = Status.unknown
    
    private let settingsService = SettingsService.instance
    private let fileManager = FileManager.default
    
    private var isEnabledObservation: AnyCancellable?
    private var libraryReactivationTimer: Timer?
    
    private init() {
        guard !ProcessInfo.isPreview else {
            return
        }
        
        updateStatus()
        
        isEnabledObservation = settingsService.$isProtectionEnabled.sink { [weak self] in
            guard let self else { return }
            
            if $0 {
                if libraryReactivationTimer == nil {
                    startLibraryMaintaining()
                }
            } else {
                stopLibrary()
            }
        }
    }
    
    func prepareForTermination() {
        stopLibrary()
    }
    
    private func startLibraryMaintaining() {
        let reactivateIfNeeded = { [weak self] in
            guard let self else {
                return
            }
            
            updateStatus()
            
            if status == .initializing {
                let deviceArchitecture = Utils.getDeviceArchitecture()
                activateLibrary(for: deviceArchitecture)
            }
        }
        
        stopLibrary()
        
        DispatchQueue.main.async {
            reactivateIfNeeded()
        }
        
        let reactivationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            reactivateIfNeeded()
        }
        
        RunLoop.main.add(reactivationTimer, forMode: .common)
        self.libraryReactivationTimer = reactivationTimer
    }
    
    private func updateStatus() {
        if Utils.executeTerminalCommand("ps -A")?.contains(Constants.libraryProcessNamePrefix) == true {
            status = .active
        } else {
            status = settingsService.isProtectionEnabled ? .initializing : .stopped
        }
    }
    
    private func activateLibrary(for deviceArchitecture: SupportedArchitecture) {
        guard
            let path = Bundle.main.path(
                forResource: Constants.libraryProcessNamePrefix + deviceArchitecture.rawValue,
                ofType: ""
            ) else {
            return
        }
        var command = "\"" + path + "\""
        
        if settingsService.isDnsOverHttpsEnabled {
            command += " -enable-doh"
        }
        
        if !settingsService.dnsServerAddress.isEmpty {
            command += " --dns-addr " + settingsService.dnsServerAddress
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            Utils.executeTerminalCommand(command)
        }
    }
    
    private func stopLibrary() {
        libraryReactivationTimer?.invalidate()
        libraryReactivationTimer = nil
        
        SupportedArchitecture.allCases.forEach {
            Utils.executeTerminalCommand("killall " + Constants.libraryProcessNamePrefix + $0.rawValue)
        }
        
        status = .stopped
    }
}

extension ProtectionService {
    enum Status {
        case active
        case initializing
        case stopped
        
        case unknown
    }
}
