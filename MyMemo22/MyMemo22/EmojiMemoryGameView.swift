//
//  EmojiMemoryGameView.swift
//  MyMemo22
//
//  Created by Sergii Miroshnichenko on 26.03.2022.
//


import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                VStack {
                    Text("Memorize \(game.chosenTheme.nameOfTheme)!").font(.system(size: 26))
                    Text("Scores: \(game.scores)").font(.system(size: 20))
                }
                gameBody
                HStack {
                    shuffle
                    Spacer()
                    newGame
                }.font(.system(size: 26))
            }
            .padding()
            deckBody
        }
        .foregroundStyle(game.themeStyle)
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMached && !card.isFaceUp {
                Color.clear
            } else {
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
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .scale))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                        deal(card)
                }
            }
        }
    }
    
    var newGame: some View {
        Button (action: {
            withAnimation {
                dealt = []
                game.startNewGame()
            }
        }, label: {
                VStack {
                    Image(systemName: "repeat")
                    Text("New Game").font(.subheadline)
                }
            }
        )
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

//    func widthWithBestFits() -> CGFloat {
//        var bestFits: CGFloat
//        let cardCount = game.cards.count
//        switch cardCount {
//            case 8: bestFits = 80
//            case 10...16: bestFits = 65
//            case 18...24: bestFits = 55
//            default: bestFits = 70
//        }
//        return bestFits
//    }


struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMached ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMached)
                    .font(Font.system(size: DrowingConstans.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrowingConstans.fontSize / DrowingConstans.fontScale)
    }
    
    private struct DrowingConstans {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}










//Button(action: {
//    //
//}, label: {
//    VStack {
//        Image(systemName: "car.circle")
//        Text("Vehicles").font(.footnote).foregroundColor(Color.blue)
//    }
//})
//
//Button(action: {
//    //
//}, label: {
//    VStack {
//        Image(systemName: "bicycle.circle")
//        Text("Sport").font(.footnote).foregroundColor(Color.blue)
//    }
//})
//
//Button(action: {
//    //
//}, label: {
//    VStack {
//        Image(systemName: "takeoutbag.and.cup.and.straw")
//        Text("Food").font(.footnote).foregroundColor(Color.blue)
//    }
//})
