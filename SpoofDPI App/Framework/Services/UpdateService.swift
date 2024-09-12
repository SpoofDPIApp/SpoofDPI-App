//
//  UpdateService.swift
//  SpoofDPI App
//

import AppKit

final class UpdateService: ObservableObject {
    static let instance = UpdateService()
    
    private lazy var settingsService = SettingsService.instance
    private lazy var windowService = WindowService.instance
    
    private init() {
        guard !ProcessInfo.isPreview else {
            return
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            self.checkAvailability()
        }
        
        let timer = Timer.scheduledTimer(
            withTimeInterval: Constants.updatesCheckingFrequency,
            repeats: true
        ) { [weak self] _ in
            self?.checkAvailability()
        }
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func checkAvailability() {
        DispatchQueue.global(qos: .utility).async {
            guard
                let data = try? String(contentsOf: Constants.actualBuildNumberURL),
                let actualBuildNumber = Int(data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.settingsService.latestKnownActualBuildNumber = actualBuildNumber
                self.showAlertIfNeeded()
            }
        }
    }
    
    private func showAlertIfNeeded() {
        guard
            let currentBuildNumber = Bundle.main.buildNumber,
            currentBuildNumber < settingsService.latestKnownActualBuildNumber
        else {
            return
        }
        
        windowService.isMainWindowVisible = true
        
        let alert = NSAlert().with {
            typealias LocalizedString = SpoofDPI_App.LocalizedString.Updates.Alert
            
            $0.messageText = LocalizedString.title(appName: Bundle.main.name)
            $0.informativeText = LocalizedString.description
            
            $0.addButton(withTitle: LocalizedString.Buttons.update)
            $0.addButton(withTitle: LocalizedString.Buttons.close)
            
            $0.alertStyle = .warning
        }
        
        switch alert.runModal() {
            case .alertFirstButtonReturn:
                NSWorkspace.shared.open(Constants.repositoryURL)
                
            default:
                break
        }
    }
}
