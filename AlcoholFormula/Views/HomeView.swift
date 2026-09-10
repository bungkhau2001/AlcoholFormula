import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sound: SoundManager
    @State private var beerScale:    CGFloat = 0.3
    @State private var beerRotation: Double  = -15
    @State private var showTitle = false
    @State private var showSub   = false
    @State private var showBtn   = false
    @State private var pulseGlow = false
    @State private var bubbles: [BubbleItem] = []

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red:0.10,green:0.10,blue:0.18), Color(red:0.05,green:0.05,blue:0.12)],
                startPoint: .top, endPoint: .bottom
            ).ignoresSafeArea()

            BubbleBackgroundView(items: bubbles)

            VStack(spacing: 28) {
                Spacer()

                // Beer emoji with spring + glow
                Text("🍺")
                    .font(.system(size: 110))
                    .scaleEffect(beerScale)
                    .rotationEffect(.degrees(beerRotation))
                    .shadow(color: .amber.opacity(pulseGlow ? 0.7 : 0.15), radius: pulseGlow ? 30 : 8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: beerScale)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulseGlow)

                // Title
                VStack(spacing: 6) {
                    Text("Alcohol Formula")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [.amber, .amberDark],
                                                        startPoint: .leading, endPoint: .trailing))
                    Text("& Then... 🎉")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
                .opacity(showTitle ? 1 : 0)
                .offset(y: showTitle ? 0 : 24)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: showTitle)

                Text("Cong thuc bat bai cua moi cuoc vui 🔥")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(showSub ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.6), value: showSub)

                Spacer()

                // Music toggle
                HStack {
                    Spacer()
                    Button {
                        sound.toggleMusic(); sound.playTap()
                    } label: {
                        Image(systemName: sound.isMusicOn ? "music.note" : "music.note.slash")
                            .font(.system(size: 20))
                            .foregroundColor(sound.isMusicOn ? .amber : .white.opacity(0.4))
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }
                }
                .padding(.horizontal, 24)

                // Start button
                NavigationLink(destination: FormulaView()) {
                    Label("BAT DAU HANH TRINH", systemImage: "arrow.right.circle.fill")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [.amber, .amberDark], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.amber.opacity(0.5), radius: 18, y: 6)
                }
                .padding(.horizontal, 28)
                .opacity(showBtn ? 1 : 0)
                .scaleEffect(showBtn ? 1 : 0.85)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.9), value: showBtn)
                .simultaneousGesture(TapGesture().onEnded { sound.playTap() })

                // Bill shortcut
                NavigationLink(destination: BillCalculatorView()) {
                    Label("Tinh tien / Chia bill", systemImage: "creditcard.fill")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.38))
                }
                .simultaneousGesture(TapGesture().onEnded { sound.playTap() })
                .padding(.bottom, 4)

                Text("*Chi mang tinh giai tri. Uong co trach nhiem! 😄")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.2))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) { beerScale = 1; beerRotation = 0 }
            showTitle = true; showSub = true; showBtn = true; pulseGlow = true
            bubbles = (0..<20).map { _ in
                BubbleItem(emoji: ["🍺","🎵","✨","🍜","🎤","💫"].randomElement()!,
                           x: .random(in: 0...1), y: .random(in: 0...1),
                           size: .random(in: 16...32), opacity: .random(in: 0.05...0.18))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { sound.playMusic() }
        }
    }
}
