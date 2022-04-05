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
        MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // Mark: - intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}

