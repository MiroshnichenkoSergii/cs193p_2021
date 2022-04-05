//
//  MyMemo22App.swift
//  MyMemo22
//
//  Created by Sergii Miroshnichenko on 26.03.2022.
//

import SwiftUI

@main
struct MyMemo22App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
