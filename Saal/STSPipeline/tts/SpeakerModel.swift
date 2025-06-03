//
//  SpeakerModel.swift
//  Koa Heal
//
//  Created by Husein Hakim on 26/05/25.
//

import Foundation

struct Speaker: Identifiable {
    let id: Int
    let name: String

    var flag: String {
        if name.lowercased() == "none" {
            return "⚪️" // Empty/None speaker icon
        }

        guard name.count >= 2 else { return "🏳️" }
        let country = name.prefix(1)

        // Determine country flag
        let countryFlag: String
        switch country {
        case "a": countryFlag = "🇺🇸" // USA
        case "b": countryFlag = "🇬🇧" // British
        case "e": countryFlag = "🇪🇸" // Spain
        case "f": countryFlag = "🇫🇷" // French
        case "h": countryFlag = "🇮🇳" // Hindi
        case "i": countryFlag = "🇮🇹" // Italian
        case "j": countryFlag = "🇯🇵" // Japanese
        case "p": countryFlag = "🇧🇷" // Brazil
        case "z": countryFlag = "🇨🇳" // Chinese
        default: countryFlag = "🏳️"
        }

        return countryFlag
    }

    var displayName: String {
        if name.lowercased() == "none" {
            return "None" // Special case for None option
        }

        guard name.count >= 2 else { return name }
        let cleanName = name.dropFirst(3).capitalized
        return "\(cleanName)"
    }
}
