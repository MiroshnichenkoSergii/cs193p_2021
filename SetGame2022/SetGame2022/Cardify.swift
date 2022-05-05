//
//  Cardify.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 12.04.2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool, isChosen: Bool, isMatchedSet: Bool, isNotMatched: Bool) {
        rotation = isFaceUp ? 0 : 180
        chosen = isChosen
        haveNoSet = isNotMatched
        haveSet = isMatchedSet
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    var chosen: Bool
    var haveSet: Bool
    var haveNoSet: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrowingConstans.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrowingConstans.lineWidth)
                if chosen {
                    shape.fill().foregroundColor(.init(DrowingConstans.colorChosen))
                    shape.strokeBorder(lineWidth: DrowingConstans.lineWidth+1).foregroundColor(.init(DrowingConstans.colorChosenBoder))
                }
                if haveNoSet {
                    shape.fill().foregroundColor(.init(DrowingConstans.colorNoSet))
                    shape.strokeBorder(lineWidth: DrowingConstans.lineWidth+2).foregroundColor(.init(DrowingConstans.colorNoSetBorder))
                }
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    private struct DrowingConstans {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        
        static let colorChosen = UIColor(r: 204.0, g: 255.0, b: 229.0)
        static let colorChosenBoder = UIColor(r: 51.0, g: 255.0, b: 153.0) // green for border
        static let colorNoSet = UIColor(r: 255.0, g: 204.0, b: 204.0) // red for unset
        static let colorNoSetBorder = UIColor(r: 255.0, g: 153.0, b: 153.0)
    }
}

extension View {
    func cardify(isFaceUp: Bool, isChosen: Bool, isMatchedSet: Bool, isNotMatched: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isChosen: isChosen, isMatchedSet: isMatchedSet, isNotMatched: isNotMatched))
    }
}

extension UIColor {
     convenience init(r: CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1) {
         self.init(
             red: r / 255.0,
             green: g / 255.0,
             blue: b / 255.0,
             alpha: a
         )
     }
 }
