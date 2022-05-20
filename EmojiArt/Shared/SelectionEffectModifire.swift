//
//  SelectionEffectModifire.swift
//  EmojiArt_2
//
//  Created by Sergii Miroshnichenko on 18.05.2022.
//

import SwiftUI

struct SelectionEffectModifire: ViewModifier {
    var emoji: EmojiArtModel.Emoji
    var selectedEmoji: Set<EmojiArtModel.Emoji>
    
    func body(content: Content) -> some View {
        content
            .overlay(
                selectedEmoji.contains(emoji) ? RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3).foregroundColor(.cyan) : nil)
    }
}

extension View {
    func selectionEffectModifire(for emoji: EmojiArtModel.Emoji, in selectedEmoji: Set<EmojiArtModel.Emoji>) -> some View {
        modifier(SelectionEffectModifire(emoji: emoji, selectedEmoji: selectedEmoji))
    }
}

