//
//  MemoryGame.swift
//  MyMemo22
//
//  Created by Sergii Miroshnichenko on 27.03.2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private(set) var scores: Int = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMached
        {
            if let potentialMatchedIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[potentialMatchedIndex].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMached = true
                    cards[potentialMatchedIndex].isMached = true
                    scores += 2
                } else {
                    if scores > 0 {scores -= 1}
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMached = false
        let content: CardContent
        let id: Int
    }
}

struct Theme {
        var nameOfTheme: String
        var colorOfTheme: String
        var numberOfPairsOfCardsToShow: Int
        var emojisSetOfTheme: Array<String>
    }

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
