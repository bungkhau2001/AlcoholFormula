import SwiftUI

struct BillCalculatorView: View {
    @EnvironmentObject var sound: SoundManager
    @State private var totalText: String = ""
    @State private var people:    Int    = 4
    @State private var tipPct:    Int    = 0
    @FocusState private var focused: Bool

    private let tipOpts = [0, 5, 10, 15, 20]

    private var total:      Double { Double(totalText.replacingOccurrences(of: ",", with: "")) ?? 0 }
    private var tipAmount:  Double { total * Double(tipPct) / 100 }
    private var grandTotal: Double { total + tipAmount }
    private var perPerson:  Double { people > 0 ? grandTotal / Double(people) : 0 }

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 22) {
                    // Header
                    VStack(spacing: 6) {
                        Text("💸").font(.system(size: 60)).padding(.top, 20)
                        Text("Chia Bill")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundStyle(LinearGradient(colors: [.amber, .amberDark],
                                                            startPoint: .leading, endPoint: .trailing))
                        Text("Dung de ai tron tien nhe! 😂")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.4))
                    }

                    // Total input
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Tong tien (VND)", systemImage: "banknote.fill")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                        HStack(spacing: 8) {
                            TextField("0", text: $totalText)
                                .keyboardType(.numberPad).focused($focused)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("d").font(.system(size: 22, weight: .bold)).foregroundColor(.amber)
                        }
                        .padding(16).background(glassCard)
                        if total > 0 {
                            Text(fmtVND(total))
                                .font(.system(size: 12, weight: .medium)).foregroundColor(.amber.opacity(0.75))
                                .padding(.horizontal, 4)
                        }
                    }.padding(.horizontal, 20)

                    // People stepper
                    VStack(spacing: 12) {
                        Label("So nguoi", systemImage: "person.3.fill")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 0) {
                            Button {
                                sound.playTap(); if people > 1 { people -= 1 }
                            } label: {
                                Image(systemName: "minus.circle.fill").font(.system(size: 34))
                                    .foregroundColor(people > 1 ? .amber : .white.opacity(0.2))
                            }
                            Text("\(people) nguoi")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white).frame(maxWidth: .infinity)
                            Button {
                                sound.playTap(); if people < 20 { people += 1 }
                            } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 34)).foregroundColor(.amber)
                            }
                        }
                        .padding(16).background(glassCard)
                    }.padding(.horizontal, 20)

                    // Tip selector
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Tip / Phi dich vu", systemImage: "gift.fill")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                        HStack(spacing: 8) {
                            ForEach(tipOpts, id: \.self) { pct in
                                Button {
                                    sound.playTap()
                                    withAnimation(.spring(response: 0.3)) { tipPct = pct }
                                } label: {
                                    Text(pct == 0 ? "Khong" : "\(pct)%")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundColor(tipPct == pct ? .black : .white.opacity(0.55))
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(tipPct == pct ? Color.amber : Color.white.opacity(0.08)))
                                }
                            }
                        }
                    }.padding(.horizontal, 20)

                    // Result
                    if total > 0 {
                        VStack(spacing: 14) {
                            Text("Ket Qua")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.55))
                            VStack(spacing: 10) {
                                resultRow("Tong tien", fmtVND(total), .white.opacity(0.7))
                                if tipPct > 0 {
                                    resultRow("Tip (\(tipPct)%)", fmtVND(tipAmount), Color.amber.opacity(0.8))
                                    Divider().overlay(Color.white.opacity(0.12))
                                    resultRow("Tong cong", fmtVND(grandTotal), .white)
                                }
                                Divider().overlay(Color.white.opacity(0.12))
                                HStack {
                                    Label("Moi nguoi tra", systemImage: "person.fill")
                                        .font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white)
                                    Spacer()
                                    Text(fmtVND(perPerson))
                                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                                        .foregroundStyle(LinearGradient(colors: [.amber, .amberDark],
                                                                        startPoint: .leading, endPoint: .trailing))
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16).fill(Color.amber.opacity(0.08))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.amber.opacity(0.3), lineWidth: 1))
                            )
                        }.padding(.horizontal, 20)
                    } else {
                        Text("Nhap so tien de xem ket qua 👆")
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.28)).padding(30)
                    }

                    // Share bill
                    ShareLink(item: buildShareText()) {
                        Label("Gui Bill Cho Ca Ban 😈", systemImage: "square.and.arrow.up")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 15)
                            .background(LinearGradient(colors: [.amber, .amberDark],
                                                       startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 20).padding(.bottom, 40)
                    .simultaneousGesture(TapGesture().onEnded { sound.playSuccess() })
                }
            }
            .onTapGesture { focused = false }
        }
        .navigationTitle("Bill Calculator 💸")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark)
    }

    func resultRow(_ label: String, _ value: String, _ color: Color) -> some View {
        HStack {
            Text(label).font(.system(size: 14, design: .rounded)).foregroundColor(.white.opacity(0.55))
            Spacer()
            Text(value).font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(color)
        }
    }

    func fmtVND(_ amount: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "."
        f.maximumFractionDigits = 0
        return (f.string(from: NSNumber(value: amount)) ?? "0") + " VND"
    }

    func buildShareText() -> String {
        return """
        💸 Chia Bill Toi Nay
        ─────────────────────
        Tong tien: \(fmtVND(total))
        So nguoi: \(people) nguoi
        ─────────────────────
        🔥 Moi nguoi tra: \(fmtVND(perPerson))

        Khong the tron nhe! 😂
        #AlcoholFormula
        """
    }

    var glassCard: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
