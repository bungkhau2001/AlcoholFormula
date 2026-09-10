import SwiftUI

struct TangCard: View {
    let tang: Tang
    @EnvironmentObject var sound: SoundManager
    @State private var pressed = false

    var body: some View {
        NavigationLink(destination: TangDetailView(tang: tang)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [tang.gradientStart, tang.gradientEnd],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 52, height: 52)
                    Text("\(tang.id)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded)).foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(tang.emoji).font(.system(size: 22))
                        Text("Tang \(tang.id) - \(tang.title)")
                            .font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(.white)
                    }
                    Text(tang.shortDesc)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.52)).lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [tang.gradientStart.opacity(0.22), tang.gradientEnd.opacity(0.08)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(tang.gradientStart.opacity(0.35), lineWidth: 1))
            )
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { pressed = true } }
                .onEnded { _ in
                    sound.playTap()
                    withAnimation(.easeInOut(duration: 0.15)) { pressed = false }
                }
        )
    }
}
