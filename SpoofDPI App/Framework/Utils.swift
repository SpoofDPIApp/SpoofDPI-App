//
//  Utils.swift
//  SpoofDPI App
//

import Foundation

final class Utils {
    private init() { }
    
    @discardableResult static func executeTerminalCommand(_ command: String) -> String? {
        guard !ProcessInfo.isPreview else {
            return nil
        }
        
        let process = Process().with {
            $0.arguments = ["-c", command]
            $0.currentDirectoryPath = "~/"
            $0.launchPath = "/bin/sh"
        }
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        let fileHandle = pipe.fileHandleForReading
        process.launch()
        
        let outputData = fileHandle.readDataToEndOfFile()
        return .init(data: outputData, encoding: .utf8)
    }
    
    static func getDeviceArchitecture() -> SupportedArchitecture {
        return executeTerminalCommand("uname -m")?.contains("arm") == true ? .arm : .x64
    }
}

enum SupportedArchitecture: String, CaseIterable {
    case arm
    case x64
}
