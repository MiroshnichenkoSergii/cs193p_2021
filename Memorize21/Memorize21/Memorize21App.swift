//
//  Memorize21App.swift
//  Memorize21
//
//  Created by Sergii Miroshnichenko on 26.03.2022.
//

import SwiftUI

@main
struct Memorize21App: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
