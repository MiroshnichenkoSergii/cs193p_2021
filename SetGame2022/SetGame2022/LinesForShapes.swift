//
//  LinesForShapes.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 18.04.2022.
//

import SwiftUI

struct LinesForShapes<SymbolShape>: View where SymbolShape: Shape {
    let numberOfStripes: Int = 9
    let borderLineWidth: CGFloat = 2
    
    let shape: SymbolShape
    let color: Color
    let spacingColor = Color.white
    
    var body: some View {
        VStack(spacing: 0.65) {
            ForEach(0..<numberOfStripes, id:\.self) { _ in
                spacingColor
                color
            }
            spacingColor
        }
        .mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderLineWidth))
    }
}
