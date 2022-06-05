//
//  EmojiMemoryGame.swift
//  Memorize_4.0
//
//  Created by Sergii Miroshnichenko on 24.05.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    typealias Card = MemoryGame<String>.Card
    
    let chosenTheme: Theme
    
    static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.map { String($0) }
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    init(theme: Theme) {
        chosenTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
    
    var cards: Array<Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var endGame: Bool {
        model.endGame
    }
    
    //MARK: intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func restart(_ cards: [Card]) {
        model.restart()
    }
    
    func shuffle(_ cards: [Card]) {
        model.shuffle()
    }
    
}
