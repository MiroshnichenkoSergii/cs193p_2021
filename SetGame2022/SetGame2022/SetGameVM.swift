//
//  SetGameVM.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 12.04.2022.
//

import SwiftUI

class SetGameVM: ObservableObject {
    typealias Card = SetGameM<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes>.Card
    
    private static var symbols: [Card.CardContent] = {
        var contents = [Card.CardContent]()
        
        for shape in ContentShape.allCases {
            for color in ContentColor.allCases {
                for pattern in ContentPattern.allCases {
                    for numberOfShapes in NumberOfContentShapes.allCases {
                        contents.append(Card.CardContent( shape: shape, color: color, pattern: pattern, numberOfShapes: numberOfShapes.rawValue))
                    }
                }
            }
        }
        return contents.shuffled()
    }()
    
    private static func createSetGame() -> SetGameM<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes> {
        SetGameM<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes>() { cardIndex in
            symbols[cardIndex]
        }
    }
    
    @Published private var model = createSetGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    var scores: Int {
        model.scores
    }
    
    
    //MARK: - intents
    
    func choose(_ card: SetGameVM.Card) {
        model.choose(card)
    }
    
    func restart() {
        model = SetGameVM.createSetGame()
    }
    
    func flipTheCard(_ card: SetGameM<ContentShape, ContentColor, ContentPattern, NumberOfContentShapes>.Card) {
        model.flipTheCard(card)
    }
    
    
    
    enum ContentShape: CaseIterable {
            case roundedRectangle
            case diamond
            case squiggle
        }
        
    enum ContentColor: CaseIterable {
        case red
        case green
        case purple
        
        func getColor() -> Color {
            switch self {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .purple:
                return Color.purple
            }
        }
    }
    
    enum ContentPattern: CaseIterable {
        case filled
        case stroked
        case shaded
    }
    
    enum NumberOfContentShapes: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
}













//    private static var symbols = ["💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎",
//                                  "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎",
//                                  "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎",
//                                  "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎",
//                                  "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎", "💎",
//                                  "💎", "💎", "💎", "💎", "💎", "💎"]
