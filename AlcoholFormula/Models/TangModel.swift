import SwiftUI

struct Tang: Identifiable, Hashable {
    let id: Int
    let title: String
    let emoji: String
    let shortDesc: String
    let fullDesc: String
    let gradientStart: Color
    let gradientEnd: Color
    let funFact: String
    let meterLabel: String
    let meterValue: Double
    let particleEmoji: String
    let tips: [String]

    static func == (lhs: Tang, rhs: Tang) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Tang {
    static let all: [Tang] = [
        Tang(
            id: 1, title: "Ruou", emoji: "🍺",
            shortDesc: "Uong cho tinh cam thang hoa",
            fullDesc:  "Uong cho tinh cam thang hoa, noi chuyen gi cung thay hop ly.",
            gradientStart: Color(red: 0.96, green: 0.65, blue: 0.14),
            gradientEnd:   Color(red: 0.90, green: 0.40, blue: 0.10),
            funFact: "Ly 1: hoi tham suc khoe 🤝\nLy 2: ke chuyen doi tu 😅\nLy 3: giai thich tai sao minh moi la dung 🧠\nLy 4+: moi thu deu co the thuong luong! 🤔",
            meterLabel: "Do hop ly cua moi chuyen",
            meterValue: 0.97,
            particleEmoji: "🍺",
            tips: ["Uong co trach nhiem nhe 😄", "Nuoc loc la ban tot nhat", "Khong lai xe sau khi uong!"]
        ),
        Tang(
            id: 2, title: "Karaoke tay vin", emoji: "🎤",
            shortDesc: "Phong thai nhu ca si hang A",
            fullDesc:  "Giong hat chua chac hay, nhung phong thai phai nhu ca si hang A. 😂",
            gradientStart: Color(red: 0.60, green: 0.20, blue: 0.90),
            gradientEnd:   Color(red: 0.30, green: 0.10, blue: 0.70),
            funFact: "Chua bao gio hat dung note 🎵\nNhung luon duoc vo tay vi... phong thai! 👏\nBi quyet: hat TO thi nghe hay hon 😂\nMic cam chac, dung de roi 🎤",
            meterLabel: "Do tu tin ca si",
            meterValue: 1.0,
            particleEmoji: "🎵",
            tips: ["Chon bai tu ngay tu dau", "Nhuong mic cho ban be doi luc", "Dung hat qua 3 bai lien tiep 😅"]
        ),
        Tang(
            id: 3, title: "Massage", emoji: "💆",
            shortDesc: "Bao duong co the sau cong hien",
            fullDesc:  "Sau khi da cong hien het minh cho nghe thuat, tien hanh bao duong co the.",
            gradientStart: Color(red: 0.06, green: 0.73, blue: 0.62),
            gradientEnd:   Color(red: 0.00, green: 0.48, blue: 0.48),
            funFact: "Co the dang o che do: Bao tri khan cap 🔧\nSau 2 tang hao ton, day la luc sac pin ⚡\nNgu gat trong massage: 80% kha nang! 😴",
            meterLabel: "Do thu gian",
            meterValue: 0.88,
            particleEmoji: "✨",
            tips: ["Dung ngu say qua nhe", "Thu gian dau oc, tam quen hoa don", "Uong them nuoc sau massage"]
        ),
        Tang(
            id: 4, title: "An dem", emoji: "🍜",
            shortDesc: "Nap lai nang luong & kiem diem",
            fullDesc:  "Nap lai nang luong, tranh thu chem gio va kiem diem lai nhung quyet dinh thieu sang suot cua 3 tang truoc. 🤣",
            gradientStart: Color(red: 0.91, green: 0.30, blue: 0.24),
            gradientEnd:   Color(red: 0.70, green: 0.18, blue: 0.14),
            funFact: "Menu dem: khong quan trong an gi 🍜\nQuan trong la ai tra tien 💸\nMoi mon deu ngon hon binh thuong 10 lan!\nBung doi sau 3 tang = an duoc ca ban 😂",
            meterLabel: "Do doi sau 3 tang",
            meterValue: 1.0,
            particleEmoji: "🍜",
            tips: ["Goi du cho ca ban nhe", "Tranh thu nhac lai ky niem toi nay", "Ai goi nhieu nhat thi tra tien 🤣"]
        )
    ]
}
