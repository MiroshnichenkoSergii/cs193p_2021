//
//  SetGame2022App.swift
//  SetGame2022
//
//  Created by Sergii Miroshnichenko on 12.04.2022.
//

import SwiftUI

@main
struct SetGame2022App: App {
    let game = SetGameVM()
    
    var body: some Scene {
        WindowGroup {
            SetGameViewV(game: game)
        }
    }
}
