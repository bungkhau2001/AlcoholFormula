import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var sound: SoundManager
    @State private var trophy = false
    @State private var show   = false
    @State private var rain   = false

    private let stats: [(String, String, String)] = [
        ("🧠", "Bo nho con lai",          "0%"),
        ("💸", "Nho hoa don",             "100%"),
        ("🎤", "Muon hat lan nua",        "99%"),
        ("😴", "Muon ve ngu",             "∞"),
        ("🤝", "Ban moi quen toi nay",    "12 nguoi"),
        ("🤔", "Quyet dinh hoi han",      "Vo so 😂"),
    ]

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            if rain { EmojiRainView().ignoresSafeArea().allowsHitTesting(false) }

            ScrollView {
                VStack(spacing: 22) {
                    // Trophy
                    Text("🏆").font(.system(size: 90))
                        .scaleEffect(trophy ? 1 : 0.1)
                        .rotationEffect(.degrees(trophy ? 0 : -30))
                        .animation(.spring(response: 0.5, dampingFraction: 0.4), value: trophy)
                        .padding(.top, 30)

                    // Title
                    VStack(spacing: 6) {
                        Text("HOAN THANH!")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundColor(.amber).tracking(4)
                        Text("Tong Ket 4 Tang\nHuyen Thoai 🔥")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white).multilineTextAlignment(.center)
                    }
                    .opacity(show ? 1 : 0).offset(y: show ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: show)

                    // Verdict card
                    Text("Di du 4 tang thi sang hom sau khong nho toi qua an gi,\nbut chac chan nho... hoa don bao nhieu! 😂")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.85)).multilineTextAlignment(.center)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 18).fill(Color.amber.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.amber.opacity(0.3), lineWidth: 1))
                        )
                        .padding(.horizontal, 20)
                        .opacity(show ? 1 : 0)

                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Array(stats.enumerated()), id: \.offset) { i, stat in
                            StatCard(emoji: stat.0, label: stat.1, value: stat.2)
                                .opacity(show ? 1 : 0).offset(y: show ? 0 : 20)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7)
                                    .delay(0.1 + Double(i) * 0.07), value: show)
                        }
                    }.padding(.horizontal, 20)

                    // Formula recap
                    VStack(spacing: 14) {
                        Text("Cong Thuc Da Ap Dung")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.55))
                        HStack(spacing: 6) {
                            ForEach(Tang.all, id: \.id) { t in
                                VStack(spacing: 3) {
                                    Text(t.emoji).font(.system(size: 26))
                                    Text("T\(t.id)").font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.4))
                                }
                                if t.id < 4 { Text("→").foregroundColor(.white.opacity(0.22)).font(.system(size: 16)) }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity).padding(18)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                    .padding(.horizontal, 20)

                    // Bill button
                    NavigationLink(destination: BillCalculatorView()) {
                        Label("Tinh & Chia Bill 💸", systemImage: "creditcard.fill")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.amber.opacity(0.35), lineWidth: 1))
                            )
                    }
                    .padding(.horizontal, 20)
                    .simultaneousGesture(TapGesture().onEnded { sound.playTap() })

                    // Share button
                    ShareLink(item: buildShareText()) {
                        Label("Chia Se Thanh Tich 🎉", systemImage: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(LinearGradient(colors: [.amber, .amberDark],
                                                       startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.amber.opacity(0.4), radius: 14, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .simultaneousGesture(TapGesture().onEnded { sound.playSuccess() })

                    Text("Lan sau dung quen mang du tien 😂")
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.22))
                        .padding(.bottom, 44)
                }
            }
        }
        .navigationTitle("Tong Ket 🏆")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark)
        .onAppear {
            sound.playCheer(); trophy = true; rain = true
            withAnimation(.easeOut(duration: 0.4).delay(0.35)) { show = true }
        }
    }

    func buildShareText() -> String {
        return """
        🍺 Alcohol Formula & Then
        ─────────────────────────
        Toi vua hoan thanh 4 tang huyen thoai! 🏆

        🍺 Tang 1: Ruou ✅
        🎤 Tang 2: Karaoke tay vin ✅
        💆 Tang 3: Massage ✅
        🍜 Tang 4: An dem ✅

        📊 Ket qua cuoi ngay:
        🧠 Bo nho con lai: 0%
        💸 Nho hoa don: 100%

        'Khong nho toi qua an gi,
        nhung chac chan nho hoa don bao nhieu!' 😂

        #AlcoholFormula #4Tang #HuyenThoai
        """
    }
}

// MARK: - StatCard
struct StatCard: View {
    let emoji, label, value: String
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji).font(.system(size: 28))
            Text(value).font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundColor(.white)
            Text(label).font(.system(size: 10, weight: .medium)).foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center).lineLimit(2)
        }
        .frame(maxWidth: .infinity).padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
    }
}
