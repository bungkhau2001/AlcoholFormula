import SwiftUI

struct RainItem: Identifiable {
    let id    = UUID()
    let x:     CGFloat
    let emoji: String
    let size:  CGFloat
    let speed: Double
    let delay: Double
}

struct EmojiRainView: View {
    @State private var items: [RainItem] = []
    private let pool = ["🍺","🎤","💆","🍜","🎉","✨","💫","🎵","🤣","🥳","🎊","🔥"]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(items) { item in FallingEmoji(item: item, height: geo.size.height) }
            }
            .onAppear {
                items = (0..<22).map { _ in
                    RainItem(x: .random(in: 0...geo.size.width),
                             emoji: pool.randomElement()!,
                             size: .random(in: 18...34),
                             speed: .random(in: 3...6),
                             delay: .random(in: 0...5))
                }
            }
        }
    }
}

private struct FallingEmoji: View {
    let item:   RainItem
    let height: CGFloat
    @State private var y:       CGFloat = -50
    @State private var opacity: Double  = 0

    var body: some View {
        Text(item.emoji).font(.system(size: item.size))
            .position(x: item.x, y: y).opacity(opacity)
            .onAppear {
                withAnimation(.linear(duration: item.speed).repeatForever(autoreverses: false).delay(item.delay)) {
                    y = height + 50
                }
                withAnimation(.easeIn(duration: 0.5).delay(item.delay)) { opacity = 0.22 }
            }
    }
}
