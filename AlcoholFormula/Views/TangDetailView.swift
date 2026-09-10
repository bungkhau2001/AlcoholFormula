import SwiftUI

struct TangDetailView: View {
    let tang: Tang
    @EnvironmentObject var sound: SoundManager
    @State private var timerMgr  = TimerManager()
    @State private var meterVal:  Double = 0
    @State private var emojiPop:  Bool   = false
    @State private var show:      Bool   = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [tang.gradientStart.opacity(0.28), Color.bg],
                           startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            ParticleView(emoji: tang.particleEmoji).ignoresSafeArea().allowsHitTesting(false)

            ScrollView {
                VStack(spacing: 22) {
                    // Big emoji
                    Text(tang.emoji).font(.system(size: 100))
                        .scaleEffect(emojiPop ? 1 : 0.2)
                        .rotationEffect(.degrees(emojiPop ? 0 : -20))
                        .animation(.spring(response: 0.5, dampingFraction: 0.45), value: emojiPop)
                        .padding(.top, 22)

                    // Badge
                    Text("TANG \(tang.id)")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundColor(tang.gradientStart).tracking(4)
                        .padding(.horizontal, 14).padding(.vertical, 6)
                        .background(Capsule().fill(tang.gradientStart.opacity(0.15))
                            .overlay(Capsule().stroke(tang.gradientStart.opacity(0.45), lineWidth: 1)))

                    // Title
                    Text("\(tang.emoji) \(tang.title)")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)

                    // Description
                    Text(tang.fullDesc)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20).padding(.vertical, 18)
                        .background(glassCard).padding(.horizontal, 20)

                    // Timer
                    VStack(spacing: 12) {
                        Label("Timer - Tang \(tang.id)", systemImage: "timer")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.55))
                        Text(timerMgr.formatted)
                            .font(.system(size: 46, weight: .heavy, design: .monospaced))
                            .foregroundStyle(LinearGradient(colors: [tang.gradientStart, tang.gradientEnd],
                                                            startPoint: .leading, endPoint: .trailing))
                            .contentTransition(.numericText())
                        HStack(spacing: 14) {
                            Button {
                                sound.playTap()
                                if timerMgr.isRunning { timerMgr.pause() } else { timerMgr.start() }
                            } label: {
                                Label(timerMgr.isRunning ? "Dung" : "Bat dau",
                                      systemImage: timerMgr.isRunning ? "pause.fill" : "play.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 22).padding(.vertical, 10)
                                    .background(LinearGradient(colors: [tang.gradientStart, tang.gradientEnd],
                                                               startPoint: .leading, endPoint: .trailing))
                                    .clipShape(Capsule())
                            }
                            Button {
                                sound.playTap(); timerMgr.reset()
                            } label: {
                                Label("Reset", systemImage: "arrow.counterclockwise")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.65))
                                    .padding(.horizontal, 20).padding(.vertical, 10)
                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity).padding(18).background(glassCard).padding(.horizontal, 20)

                    // Meter
                    VStack(spacing: 10) {
                        HStack {
                            Text(tang.meterLabel)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.65))
                            Spacer()
                            Text("\(Int(meterVal * 100))%")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(tang.gradientStart)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.1)).frame(height: 12)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(LinearGradient(colors: [tang.gradientStart, tang.gradientEnd],
                                                         startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * meterVal, height: 12)
                            }
                        }.frame(height: 12)
                    }.padding(.horizontal, 20)

                    // Fun fact
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Fun Fact", systemImage: "lightbulb.fill")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(tang.gradientStart)
                        Text(tang.funFact)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(18)
                    .background(RoundedRectangle(cornerRadius: 16).fill(tang.gradientStart.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(tang.gradientStart.opacity(0.3), lineWidth: 1)))
                    .padding(.horizontal, 20)

                    // Tips
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Tips", systemImage: "checkmark.seal.fill")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.65))
                        ForEach(tang.tips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•").foregroundColor(tang.gradientStart)
                                Text(tip).font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.62))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18).background(glassCard).padding(.horizontal, 20)

                    // Navigation buttons
                    VStack(spacing: 12) {
                        if tang.id < 4 {
                            let next = Tang.all[tang.id] // id 1->index 1 (Tang 2), etc.
                            NavigationLink(destination: TangDetailView(tang: next)) {
                                HStack {
                                    Text("Tiep: Tang \(next.id) - \(next.title)")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                    Text(next.emoji).font(.system(size: 18))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding(.vertical, 16)
                                .background(LinearGradient(colors: [tang.gradientStart, tang.gradientEnd],
                                                           startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .simultaneousGesture(TapGesture().onEnded { sound.playTap() })
                        } else {
                            NavigationLink(destination: SummaryView()) {
                                Label("🎉 Xem Tong Ket!", systemImage: "star.fill")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                                    .background(LinearGradient(colors: [.amber, .amberDark],
                                                               startPoint: .leading, endPoint: .trailing))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .simultaneousGesture(TapGesture().onEnded { sound.playCheer() })
                        }

                        NavigationLink(destination: BillCalculatorView()) {
                            Label("Tinh & Chia Bill 💸", systemImage: "creditcard.fill")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.06)))
                        }
                        .simultaneousGesture(TapGesture().onEnded { sound.playTap() })
                    }
                    .padding(.horizontal, 20).padding(.bottom, 40)
                }
                .opacity(show ? 1 : 0).offset(y: show ? 0 : 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark)
        .onAppear {
            sound.playTangEntry(tang.id)
            withAnimation(.easeOut(duration: 0.35)) { show = true }
            emojiPop = true
            withAnimation(.spring(response: 1.2, dampingFraction: 0.7).delay(0.5)) { meterVal = tang.meterValue }
        }
        .onDisappear { timerMgr.pause() }
    }

    var glassCard: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
