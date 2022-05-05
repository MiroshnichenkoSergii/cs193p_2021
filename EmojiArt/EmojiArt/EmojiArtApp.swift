//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Sergii Miroshnichenko on 02.05.2022.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
