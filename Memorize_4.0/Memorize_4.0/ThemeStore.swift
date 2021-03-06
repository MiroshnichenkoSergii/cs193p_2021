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
            insertTheme(named: "Favourite", emojis: "πΉπΊπ»π½ππΎπ€πππ€", color:Color(rgbaColor: RGBAColor(51, 255, 255, 1)))
            insertTheme(named: "Vehicles", emojis: "ππππππππ»πππππππβοΈπ«π¬π©ππΈπ²ππΆβ΅οΈπ€π₯π³β΄π’ππππππππΊπ", color: Color(rgbaColor: RGBAColor(255, 143, 20, 1)))
            insertTheme(named: "Sports", emojis: "πβΎοΈπβ½οΈπΎππ₯πβ³οΈπ₯π₯πβ·π³", color:Color(rgbaColor: RGBAColor(86, 178, 62, 1)))
            insertTheme(named: "Music", emojis: "πΌπ€πΉπͺπ₯πΊπͺπͺπ»", numberOfPairsOfCards: 5, color: Color(rgbaColor: RGBAColor(248, 218, 9, 1)))
            insertTheme(named: "Animals", emojis: "π₯π£πππππππ¦ππππππ¦π¦π¦π¦π’ππ¦π¦π¦πππ¦π¦π¦§π¦£ππ¦π¦πͺπ«π¦π¦π¦¬ππ¦ππ¦ππ©π¦?ππ¦€π¦’π¦©ππ¦π¦¨π¦‘π¦«π¦¦π¦₯πΏπ¦", color: Color(rgbaColor: RGBAColor(229, 108, 204, 1)))
            insertTheme(named: "Animal Faces", emojis: "π΅ππππΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨π―π¦π?π·πΈπ²")
            insertTheme(named: "Weather", emojis: "βοΈπ€βοΈπ₯βοΈπ¦π§βπ©π¨βοΈπ¨βοΈπ§π¦πβοΈπ«πͺ", color: Color(rgbaColor: RGBAColor(0, 128, 255, 1)))
            insertTheme(named: "COVID", emojis: "ππ¦ π·π€§π€", color: Color(rgbaColor: RGBAColor(128, 255, 0, 1)))
            insertTheme(named: "Faces", emojis: "ππππππππ€£π₯²βΊοΈππππππππ₯°πππππππππ€ͺπ€¨π§π€ππ₯Έπ€©π₯³ππππππβΉοΈπ£ππ«π©π₯Ίπ’π­π€π π‘π€―π³π₯Άπ₯ππ€π€π€­π€«π€₯π¬ππ―π§π₯±π΄π€?π·π€§π€π€ ", color: Color(rgbaColor: RGBAColor(37, 75, 240, 1)))
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
