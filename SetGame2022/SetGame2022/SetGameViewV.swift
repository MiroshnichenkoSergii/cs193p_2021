//
//  SetGameViewV.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 12.04.2022.
//

import SwiftUI

struct SetGameViewV: View {
    @ObservedObject var game: SetGameVM
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                discardPileBody
                gameBody
                HStack {
                    restart
                    Spacer()
                    Text("Scores: \(game.scores)")
                }
                .font(.system(size: 26))
            }
            deckBody
        }
        .padding()
        .foregroundColor(Color.blue)
    }
    
    @State private var dealt = Set<Int>()
    @State private var unDealtCards = Set<Int>()
    
    private func deal(_ card: SetGameVM.Card) {
        dealt.insert(card.id)
    }
    
    private func unDeal(_ card: SetGameVM.Card) {
        //dealt.remove(card.id)
        unDealtCards.insert(card.id)
    }
    
    private func isMatchedCard(_ card: SetGameVM.Card) -> Bool {
        card.isMatchedSet
    }
    
    private func isDealt(_ card: SetGameVM.Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private func isUndealt(_ card: SetGameVM.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: SetGameVM.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SetGameVM.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if !card.isMatchedSet {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            } 
        }
        .foregroundColor(CardConstants.color)
        .padding(5)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .offset(x: CGFloat(card.id) * 0.1, y: CGFloat(card.id) * 0.1)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            if dealt.count == 0 {
                for card in game.cards {
                    if dealt.count < 12 {
                        withAnimation(dealAnimation(for: card)) {
                            deal(card)
                            game.flipTheCard(card)
                        }
                    }
                }
            } else {
                if dealt.count < 81 && dealt.count >= 12 {
                    for card in Array(game.cards[dealt.count..<dealt.count+3]) {
                        withAnimation(dealAnimation(for: card)) {
                            deal(card)
                            game.flipTheCard(card)
                        }
                    }
                }
            }
        }
    }
    
    var discardPileBody: some View {
        ZStack {
            ForEach(game.cards) { card in
                if card.isMatchedSet {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .offset(x: CGFloat(card.id) * 0.1, y: CGFloat(card.id) * 0.1)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1)) {
                                game.flipTheCard(card)
                            }
                        }
                }
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
    }
    
    private struct CardConstants {
        static let color = Color.mint
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
}

struct CardView: View {
    let card: SetGameVM.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ForEach(0..<card.symbol.numberOfShapes, id: \.self) { _ in
                        createSymbol(for: card)
                            .scaleEffect(scale(thatFits: geometry.size))
                    }
                }
            }
            .cardify(isFaceUp: card.isFaceUp, isChosen: card.isChosen, isMatchedSet: card.isMatchedSet, isNotMatched: card.isNotMatched)
        }
    }
    
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / DrawingConstants.forSymbolScale
    }
    
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let forSymbolScale: CGFloat = 110
        static let symbolCornerRadius: CGFloat = 50
        static let symbolAspectRatio: CGFloat = 3/1
        static let symbolOpacity: Double = 0.7
        static let defaultLineWidth: CGFloat = 2
        static let effectLineWidth: CGFloat = 3
        static let effectOpacity: Double = 0.1
    }
    
    @ViewBuilder
    func createSymbol(for card: SetGameVM.Card) -> some View {
        switch card.symbol.shape {
        case .roundedRectangle:
            createSymbolView(of: card.symbol, shape: RoundedRectangle(cornerRadius: DrawingConstants.symbolCornerRadius))
        case .squiggle:
            createSymbolView(of: card.symbol, shape: Wave())
        case .diamond:
            createSymbolView(of: card.symbol, shape: Romb())
        }
    }
    
    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: SetGameVM.Card.CardContent, shape: SymbolShape) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .shaded:
            LinesForShapes(shape: shape, color: symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .stroked:
            shape.stroke(lineWidth: DrawingConstants.defaultLineWidth).foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameVM()
        return SetGameViewV(game: game)
    }
}
