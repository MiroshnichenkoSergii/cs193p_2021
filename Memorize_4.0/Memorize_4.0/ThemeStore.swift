//
//  ThemeStore.swift
//  Memorize_4.0
//
//  Created by Sergii Miroshnichenko on 26.05.2022.
//

import SwiftUI

struct Theme: Codable, Identifiable, Hashable {
    var name: String
    var emojis: String
    var removedEmojis: String
    var numberOfPairsOfCards: Int
    var color: RGBAColor
    let id: Int
    
    fileprivate init(name: String, emojis: String, numberOfPairsOfCards: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.removedEmojis = ""
        self.numberOfPairsOfCards = min(numberOfPairsOfCards, emojis.count)
        self.color = color
        self.id = id
    }
}

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

class ThemeStore: ObservableObject {
    
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            print("Uh-oh empty themes...inserting defaults...")
            insertTheme(named: "Favourite", emojis: "👹👺👻👽🎃👾🤖😈🌞🤑", color:Color(rgbaColor: RGBAColor(51, 255, 255, 1)))
            insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: Color(rgbaColor: RGBAColor(255, 143, 20, 1)))
            insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color:Color(rgbaColor: RGBAColor(86, 178, 62, 1)))
            insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", numberOfPairsOfCards: 5, color: Color(rgbaColor: RGBAColor(248, 218, 9, 1)))
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: Color(rgbaColor: RGBAColor(229, 108, 204, 1)))
            insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: Color(rgbaColor: RGBAColor(0, 128, 255, 1)))
            insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒", color: Color(rgbaColor: RGBAColor(128, 255, 0, 1)))
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: Color(rgbaColor: RGBAColor(37, 75, 240, 1)))
        }
    }

    
    // MARK: - Save & Load Themes
    
    private var userDefaultsKey: String { "ThemeStore" + name }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodeThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodeThemes
        }
    }
    
    // MARK: - Intent(s)
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    
    func insertTheme(named name: String, emojis: String? = nil, numberOfPairsOfCards: Int = Int.random(in: 4...14), color: Color = Color(rgbaColor: RGBAColor(243, 63, 63, 1)), at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", numberOfPairsOfCards: numberOfPairsOfCards, color: RGBAColor(color: color), id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
    
    func removeTheme(at index: Int) {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
    }
}
