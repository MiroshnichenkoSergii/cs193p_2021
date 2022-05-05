//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by Sergii Miroshnichenko on 03.05.2022.
//

import SwiftUI

// syntactic sugar to be able to pass an optional UIImage to Image
// (normally it would only take a non-optional UIImage)
struct OptionalImage: View {
    var uiImage: UIImage?
    
    // body is a viewBuilder so it can have an empty view only
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}
