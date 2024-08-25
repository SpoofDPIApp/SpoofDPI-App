//
//  SettingsService.swift
//  SpoofDPI App
//

import SwiftUI

final class SettingsService: ObservableObject {
    static let instance = SettingsService()
    
    private init() { }
    
    @AppStorage("isProtectionEnabled") private static var isProtectionEnabled = true
    
    @Published var isProtectionEnabled = isProtectionEnabled {
        didSet {
            Self.isProtectionEnabled = isProtectionEnabled
        }
    }
    
    @AppStorage("isAutomaticLaunchEnabled") private static var isAutomaticLaunchEnabled = true
    
    @Published var isAutomaticLaunchEnabled = isAutomaticLaunchEnabled {
        didSet {
            Self.isAutomaticLaunchEnabled = isAutomaticLaunchEnabled
        }
    }
    
    @AppStorage("isMenuBarIconEnabled") private static var isMenuBarIconEnabled = true
    
    @Published var isMenuBarIconEnabled = isMenuBarIconEnabled {
        didSet {
            Self.isMenuBarIconEnabled = isMenuBarIconEnabled
        }
    }

    @AppStorage("isDnsOverHttpsEnabled") private static var isDnsOverHttpsEnabled = false
    
    @Published var isDnsOverHttpsEnabled = isDnsOverHttpsEnabled {
        didSet {
            Self.isDnsOverHttpsEnabled = isDnsOverHttpsEnabled
        }
    }
    
    @AppStorage("dnsServerAddress") private static var dnsServerAddress = ""
    
    @Published var dnsServerAddress = dnsServerAddress {
        didSet {
            Self.dnsServerAddress = dnsServerAddress
        }
    }

    @AppStorage("latestKnownActualBuildNumber") var latestKnownActualBuildNumber = 0
}
