//
//  Memorize_4_0App.swift
//  Memorize_4.0
//
//  Created by Sergii Miroshnichenko on 24.05.2022.
//

import SwiftUI

@main
struct Memorize_4_0App: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
