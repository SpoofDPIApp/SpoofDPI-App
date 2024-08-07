//
//  SystemSymbol.swift
//  SpoofDPI App
//

import AppKit

enum SystemSymbol {
    static var sunglasses: NSImage { createSystemSymbol(name: "sunglasses") }
    static var sunglassesFill: NSImage { createSystemSymbol(name: "sunglasses.fill") }
    
    private static func createSystemSymbol(name: String) -> NSImage {
        return .init(systemSymbolName: name, accessibilityDescription: nil)!
    }
}
