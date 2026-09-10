import SwiftUI

struct BubbleItem: Identifiable {
    let id      = UUID()
    let emoji:   String
    let x:       CGFloat   // 0-1 relative
    let y:       CGFloat   // 0-1 relative
    let size:    CGFloat
    let opacity: Double
}

struct BubbleBackgroundView: View {
    let items: [BubbleItem]
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(items) { b in
                    Text(b.emoji).font(.system(size: b.size))
                        .position(x: b.x * geo.size.width, y: b.y * geo.size.height)
                        .opacity(b.opacity)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
