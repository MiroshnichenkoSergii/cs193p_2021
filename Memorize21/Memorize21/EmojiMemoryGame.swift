//
//  EmojiMemoryGame.swift
//  Memorize21
//
//  Created by Sergii Miroshnichenko on 27.03.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚁", "🛵", "🚢", "🚀", "🚜", "🏍", "✈️", "🚅", "🛰", "🚃", "🚂", "🛸", "🚚", "🚲", "⛵️", "🚞", "🚖", "🛻", "🚤", "🛺", "🛴", "🛶", "🚈", "🚐"]
    
    private static func createMemoryGame() -> MemoryGame<String>{
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}

