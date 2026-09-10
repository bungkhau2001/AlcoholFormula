import SwiftUI

struct FormulaView: View {
    @EnvironmentObject var sound: SoundManager
    @State private var tangs:      [Tang] = Tang.all
    @State private var isShuffled: Bool   = false
    @State private var appeared:   Bool   = false

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 6) {
                        Text("Cong Thuc Bat Bai")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundStyle(LinearGradient(colors: [.amber, .white], startPoint: .leading, endPoint: .trailing))
                        Text(isShuffled ? "Thu tu da duoc xao tron 🎲" : "Theo dung thu tu de dat hieu qua toi da 😎")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .animation(.easeInOut, value: isShuffled)
                    }
                    .padding(.top, 16).padding(.bottom, 20)

                    // Shuffle button
                    Button {
                        sound.playWhoosh()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                            tangs = isShuffled ? Tang.all : Tang.all.shuffled()
                            isShuffled.toggle()
                        }
                    } label: {
                        Label(isShuffled ? "Ve thu tu goc" : "Random thu tu 🎲",
                              systemImage: isShuffled ? "arrow.counterclockwise" : "shuffle")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(isShuffled ? .white.opacity(0.6) : .amber)
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(Capsule().fill(Color.white.opacity(0.08)))
                    }
                    .padding(.bottom, 20)

                    // Timeline
                    VStack(spacing: 0) {
                        ForEach(Array(tangs.enumerated()), id: \.element.id) { idx, tang in
                            VStack(spacing: 0) {
                                TangCard(tang: tang)
                                    .padding(.horizontal, 20)
                                    .opacity(appeared ? 1 : 0)
                                    .offset(x: appeared ? 0 : (idx % 2 == 0 ? -60 : 60))
                                    .animation(.spring(response: 0.55, dampingFraction: 0.72)
                                        .delay(Double(idx) * 0.12), value: appeared)
                                if idx < tangs.count - 1 {
                                    VStack(spacing: 5) {
                                        ForEach(0..<3, id: \.self) { _ in
                                            Circle().fill(Color.amber.opacity(0.4)).frame(width: 4, height: 4)
                                        }
                                    }.padding(.vertical, 6)
                                }
                            }
                        }
                    }

                    // Bottom buttons
                    VStack(spacing: 12) {
                        NavigationLink(destination: SummaryView()) {
                            Label("Xem Tong Ket Ngay 🏆", systemImage: "star.fill")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.75))
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.07))
                                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.amber.opacity(0.3), lineWidth: 1))
                                )
                        }
                        .padding(.horizontal, 20)

                        NavigationLink(destination: BillCalculatorView()) {
                            Label("Tinh & Chia Bill 💸", systemImage: "creditcard.fill")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.38))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 28).padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("Cong Thuc")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark)
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { appeared = true } }
    }
}
