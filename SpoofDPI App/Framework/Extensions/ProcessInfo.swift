//
//  Process.swift
//  SpoofDPI App
//

import Foundation

extension ProcessInfo {
    static var isPreview: Bool {
        return processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
