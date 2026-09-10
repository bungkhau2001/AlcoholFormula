import SwiftUI

@main
struct AlcoholFormulaApp: App {
    @StateObject private var sound = SoundManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(sound)
        }
    }
}
