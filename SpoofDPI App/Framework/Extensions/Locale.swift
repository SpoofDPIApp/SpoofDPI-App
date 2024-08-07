//
//  Locale.swift
//  SpoofDPI App
//

import Foundation

extension Locale {
    static func getSupportedLanguage() -> SupportedLanguage {
        let codes: [String: SupportedLanguage] = [
            "en": .english,
            "ru": .russian
        ]
        
        return preferredLanguages.compactMap {
            let code = String(
                $0.prefix(2)
            )
            
            return codes[code]
        }.first ?? Constants.defaultLanguage
    }
    
    enum SupportedLanguage {
        case english
        case russian
    }
}
