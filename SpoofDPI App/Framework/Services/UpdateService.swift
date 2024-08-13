//
//  UpdateService.swift
//  SpoofDPI App
//

import Foundation

final class UpdateService: ObservableObject {
    static let instance = UpdateService()
    
    @Published private(set) var areUpdatesAvailable = false
    
    private let settingsService = SettingsService.instance
    
    private init() {
        guard !ProcessInfo.isPreview else {
            return
        }
        
        updateState()
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard
                let self,
                let data = try? String(contentsOf: Constants.actualBuildNumberURL),
                let actualBuildNumber = Int(data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.settingsService.latestKnownActualBuildNumber = actualBuildNumber
                self.updateState()
            }
        }
    }
    
    private func updateState() {
        guard let currentBuildNumber = Bundle.main.buildNumber else {
            return
        }
        
        areUpdatesAvailable = currentBuildNumber < settingsService.latestKnownActualBuildNumber
    }
}
