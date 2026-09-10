import SwiftUI

struct ParticleData: Identifiable {
    let id    = UUID()
    let x:     CGFloat
    let size:  CGFloat
    let speed: Double
    let delay: Double
}

struct ParticleView: View {
    let emoji: String
    @State private var items: [ParticleData] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(items) { p in
                    FloatingParticle(data: p, emoji: emoji, height: geo.size.height)
                }
            }
            .onAppear {
                items = (0..<14).map { _ in
                    ParticleData(x: .random(in: 0...geo.size.width),
                                 size: .random(in: 14...26),
                                 speed: .random(in: 5...10),
                                 delay: .random(in: 0...5))
                }
            }
        }
    }
}

private struct FloatingParticle: View {
    let data: ParticleData
    let emoji: String
    let height: CGFloat
    @State private var y:       CGFloat = 0
    @State private var opacity: Double  = 0

    var body: some View {
        Text(emoji).font(.system(size: data.size))
            .position(x: data.x, y: y).opacity(opacity)
            .onAppear {
                y = height + 40
                withAnimation(.linear(duration: data.speed).repeatForever(autoreverses: false).delay(data.delay)) {
                    y = -40
                }
                withAnimation(.easeIn(duration: 0.6).delay(data.delay)) { opacity = 0.17 }
            }
    }
}
