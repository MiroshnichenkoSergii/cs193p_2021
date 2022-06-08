//
//  EmojiMemoryGameView.swift
//  Memorize_4.0
//
//  Created by Sergii Miroshnichenko on 24.05.2022.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var alertToShow: IdentifiableAlert?
    
    var body: some View {
        VStack {
            score
            gameBody
            restart.padding()
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            
            if !game.endGame {
                if card.isMatched && !card.isFaceUp {
                    withAnimation {
                        Color.clear
                    }
                } else {
                    CardView(card: card)
                        .padding(5)
                        .onTapGesture {
                            withAnimation {
                                game.choose(card)
                            }
                        }
                }
            }
        }
        .foregroundStyle(LinearGradient(gradient: Gradient(
            colors: [Color(rgbaColor: game.chosenTheme.color), Color.brown]),
                                        startPoint: .topLeading,
                                        endPoint: .trailing))
        .padding()
        .alert(item: $alertToShow) { alertToShow in
            alertToShow.alert()
        }
        .onChange(of: game.endGame) { status in
            switch status {
            case true:
                endGameAlert()
            default:
                break
            }
        }
    }
    
    private func endGameAlert() {
        alertToShow = IdentifiableAlert(id: "End Game", alert: {
            Alert(
                title: Text("Game Over"),
                message: Text("Your score \(game.score)"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
    
    var restart: some View {
        Button {
            withAnimation {
                game.restart(game.cards)
                game.shuffle(game.cards)
            }
        } label: {
            Label("", systemImage: "repeat")
        }
        .font(Font.system(size: 40))
    }
    
    var score: some View {
        Text("SCORE: \(game.score)")
            .font(Font.system(size: 30))
            .foregroundColor(.blue)
    }
    
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
                        .scaleEffect(card.isMatched ? 1.3 : 1)
                        .animation(Animation.linear(duration: 0.5).repeatCount(4, autoreverses: false), value: card.isMatched)
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
    
}

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
    
    init(id: String, alert: @escaping () -> Alert) {
        self.id = id
        self.alert = alert
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemeStore(named: "Default").themes[0])
        EmojiMemoryGameView(game: game)
    }
}
