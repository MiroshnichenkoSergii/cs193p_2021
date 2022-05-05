//
//  SetGameM.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 12.04.2022.
//

import Foundation

struct SetGameM<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes> where CardSymbolShape: Hashable, CardSymbolColor: Hashable, CardSymbolPattern: Hashable {
    
    private(set) var cards: Array<Card>
    
    private var chosenCards = [Card]()
    
    private(set) var scores: Int = 0
    
    private(set) var isEndOfGame = false
    
//    private var indexPreviousChosenCard: Int? {
//        get { cards.indices.filter({ cards[$0].isChosen }).previousElement }
//        set { cards.indices.forEach { cards[$0].isChosen = ($0 == newValue) } }
//    }
    
    init(creatCardContent: @escaping (Int) -> Card.CardContent) {
        let numberOfCards: Int = 81
        cards = []
        for index in 0..<numberOfCards {
            let content = creatCardContent(index)
            cards.append(Card(symbol: content, id: index))
        }
        cards.shuffle()
    }
    
    mutating func resetChosenCards() {
        if formSet(by: chosenCards) {
            chosenCards.forEach { card in
                let index = cards.firstIndex(of: card)!
                cards[index].isChosen = false
            }
        } else {
            chosenCards.forEach { card in
                let index = cards.firstIndex(of: card)!
                cards[index].isChosen = false
                cards[index].isNotMatched = false
                cards[index].isMatchedSet = false
            }
        }
        chosenCards = []
    }
    
    mutating func choose(_ card: Card) {
        
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            
            if chosenCards.count == 3 { resetChosenCards() }
            
            if !cards[chosenIndex].isChosen {
                cards[chosenIndex].isChosen = true
                chosenCards.append(cards[chosenIndex])
                if chosenCards.count == 3 {
                    if formSet(by: chosenCards) {
                        chosenCards.forEach { card in
                            let index = cards.firstIndex(of: card)!
                            cards[index].isMatchedSet = true
                            cards[index].isNotMatched = false
                        }
                        scores += 10
                        
                    } else {
                        chosenCards.forEach { card in
                            let index = cards.firstIndex(of: card)!
                            cards[index].isMatchedSet = false
                            cards[index].isNotMatched = true
                        }
                    }
                }
            } else {
                cards[chosenIndex].isChosen = false
            }
        }
    }
    
    mutating func formSet(by cards: [Card]) -> Bool {
            var shapes = Set<CardSymbolShape>()
            var colors = Set<CardSymbolColor>()
            var patterns = Set<CardSymbolPattern>()
            var numberOfShapes = Set<Int>()
            
            cards.forEach { card in
                shapes.insert(card.symbol.shape)
                colors.insert(card.symbol.color)
                patterns.insert(card.symbol.pattern)
                numberOfShapes.insert(card.symbol.numberOfShapes)
            }
            
            if shapes.count == 2 || colors.count == 2 ||
                patterns.count == 2 || numberOfShapes.count == 2 || (shapes.count == 1 && colors.count == 1 && patterns.count == 1 && numberOfShapes.count == 1){
                return false
            }
            return true
        }
    
    mutating func flipTheCard(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
        }
    }
    
    
    struct Card: Identifiable, Equatable {
        var isFaceUp: Bool = false
        var isChosen: Bool = false
        var isMatchedSet: Bool = false
        let symbol: CardContent
        let id: Int
        
        var isNotMatched = false
        
        struct CardContent: Equatable {
                    let shape: CardSymbolShape
                    let color: CardSymbolColor
                    let pattern: CardSymbolPattern
                    let numberOfShapes: Int
                }
        
        static func == (lhs: SetGameM<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card, rhs: SetGameM<CardSymbolShape, CardSymbolColor, CardSymbolPattern, NumberOfShapes>.Card) -> Bool {
                    lhs.id == rhs.id
                }
    }
}

//extension Array {
//    var previousElement: Element? {
//        if count == 1 {
//            return first
//        } else if count == 2 {
//            return last
//        } else {
//            return nil
//        }
//    }
//}
