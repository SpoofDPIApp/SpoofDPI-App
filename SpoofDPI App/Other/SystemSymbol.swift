//
//  SystemSymbol.swift
//  SpoofDPI App
//

import AppKit

enum SystemSymbol {
    case gearshape
    
    @available(macOS 14, *) case sunglasses
    @available(macOS 14, *) case sunglassesFill
    
    var name: String {
        switch self {
            case .gearshape:
                return "gearshape"
                
            case .sunglasses:
                return "sunglasses"
            case .sunglassesFill:
                return "sunglasses.fill"
        }
    }
    
    var image: NSImage {
        return .init(systemSymbolName: name, accessibilityDescription: nil)!
    }
}
