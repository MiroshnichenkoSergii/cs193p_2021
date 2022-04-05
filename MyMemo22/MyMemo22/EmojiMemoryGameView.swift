//
//  EmojiMemoryGameView.swift
//  MyMemo22
//
//  Created by Sergii Miroshnichenko on 26.03.2022.
//


import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        VStack {
            Text("Memorize \(game.chosenTheme.nameOfTheme)!").font(.largeTitle)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                if card.isMached && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
            HStack {
                Text("Scores: \(game.scores)")
                Spacer()
                Button (action: {
                    game.startNewGame()
                }, label: {
                        VStack {
                            Image(systemName: "repeat")
                            Text("New Game").font(.subheadline)
                        }
                    }
                )
            }.font(.system(size: 26))
        }
        .foregroundStyle(game.themeStyle)
        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
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
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader(content: {geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrowingConstans.cornerRadius)
                if card.isFaceUp {
                    shape.fill(.white)
                    shape.strokeBorder(lineWidth: DrowingConstans.lineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(5).opacity(DrowingConstans.circleOpacity)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMached {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        })
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrowingConstans.fontScale)
    }
    
    private struct DrowingConstans {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let circleOpacity: CGFloat = 0.5
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
