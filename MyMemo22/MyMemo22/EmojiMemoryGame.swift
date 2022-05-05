//
//  EmojiMemoryGame.swift
//  MyMemo22
//
//  Created by Sergii Miroshnichenko on 27.03.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    static private let colors = ["indigo", "gray", "red", "green", "blue", "orange",
                         "yellow", "pink", "purple", "mint", "fushia", "beige", "gold"]
    
    static func chooseColor(_ chosenColor: String) -> Color {
        switch chosenColor {
        case "indigo": return .indigo
        case "gray": return .gray
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "yellow": return .yellow
        case "pink": return .pink
        case "purple": return .purple
        case "mint": return .mint
        default: return .cyan
        }
    }
    
    static func createTheme(_ nameOfTheme: String, numberOfPairsOfCardsToShow: Int, _ emojisSetOfTheme: [String]) -> Theme {
        let colorOfTheme = colors.randomElement()!
        var numberOfPairsOfCards = numberOfPairsOfCardsToShow
        if emojisSetOfTheme.count < numberOfPairsOfCardsToShow {
            numberOfPairsOfCards = emojisSetOfTheme.count
        }
        return Theme(nameOfTheme: nameOfTheme, colorOfTheme: colorOfTheme, numberOfPairsOfCardsToShow: numberOfPairsOfCards, emojisSetOfTheme: emojisSetOfTheme.shuffled())
    }
    
    static var themes: [Theme] {
        var themes = [Theme]()
        
        let numberOfPairsOfCardsToShow = Int.random(in: 8...12)
        themes.append(createTheme("Sport", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["⚽️", "🏈", "🏀", "🎾", "🎱", "🏓", "🥊", "🏋🏻‍♀️", "🪂", "🚴‍♂️", "🏂", "🥇", "🏒", "🤿", "🪁", "🎣", "🛷", "🛹", "⛷", "🏇"]))
        themes.append(createTheme("Vehicles", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["🚁", "🛵", "🚢", "🚀", "🚜", "🏍", "✈️", "🚅", "🛰", "🚃", "🚂", "🛸", "🚚", "🚲", "⛵️", "🚞", "🚖", "🛻", "🚤", "🛺", "🛴", "🛶", "🚈", "🚐"]))
        themes.append(createTheme("Food", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["🍩", "🍫", "🍔", "🌯", "🍣", "🫕", "🥐", "🍳", "🥘", "🍺", "🍪", "🥟", "🥖", "🍗", "🍱", "🧀", "🍿", "🥫", "🍢", "🍭", "🍤", "🧁", "🥩"]))
        themes.append(createTheme("Smiles", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["😀", "😆", "🥹", "😅", "😂", "☺️", "😇", "😍", "😘", "😋", "😝", "😜", "🤪", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😭", "🤬", "🤯", "🥶"]))
        themes.append(createTheme("Enimals", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐥", "🦆", "🦅", "🦄", "🐝", "🦖", "🦋"]))
        themes.append(createTheme("Things", numberOfPairsOfCardsToShow: numberOfPairsOfCardsToShow, ["⌚️", "📱", "💻", "🖥", "🖨", "🕹", "💽", "💾", "📷", "📺", "⏰", "💡", "🔨", "🔦", "🎙", "📻", "📡", "⏳", "🦠", "⚙️", "🔪", "⚖️", "🧲"]))
        
        return themes
    }
    
    static func createMemoryGame(of chosenTheme: Theme) -> MemoryGame<String> {
        let numberOfPairsOfCards = chosenTheme.numberOfPairsOfCardsToShow
        return MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards) { chosenTheme.emojisSetOfTheme[$0]}
    }
    
    private(set) var chosenTheme: Theme
    private(set) var chosenColor: Color?
    private(set) var themeStyle: LinearGradient
    
    @Published private var model: MemoryGame<String>
    
    init() {
        chosenTheme = EmojiMemoryGame.chooseTheme()
        model = EmojiMemoryGame.createMemoryGame(of: chosenTheme)
        chosenColor = EmojiMemoryGame.chooseColor(chosenTheme.colorOfTheme)
        themeStyle = LinearGradient(gradient: Gradient(
            colors: [EmojiMemoryGame.chooseColor(EmojiMemoryGame.chooseTheme().colorOfTheme), Color.brown]),
                                        startPoint: .topLeading,
                                        endPoint: .trailing)
        
    }
    
    var cards: Array<Card> {
        model.cards
    }
    
    var scores: Int {
        model.scores
    }
    
    static func chooseTheme() -> Theme {
        EmojiMemoryGame.themes.randomElement()!
    }
        
    // Mark: intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func startNewGame() {
        chosenTheme = EmojiMemoryGame.chooseTheme()
        model = EmojiMemoryGame.createMemoryGame(of: chosenTheme)
        chosenColor = EmojiMemoryGame.chooseColor(chosenTheme.colorOfTheme)
        themeStyle = LinearGradient(gradient: Gradient(
            colors: [EmojiMemoryGame.chooseColor(EmojiMemoryGame.chooseTheme().colorOfTheme), Color.brown]),
                                        startPoint: .topLeading,
                                        endPoint: .trailing)
    }
}

