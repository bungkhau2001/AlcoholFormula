# Alcohol Formula & Then - iOS App

Ung dung giai tri vui nhon ve "cong thuc" 4 tang huyen thoai cua mot dem vui.

---

## Tinh nang

| Tinh nang        | Chi tiet                                   |
|------------------|--------------------------------------------|
| Dark UI dep      | Gradient amber/gold, Spring animations     |
| Nhac nen         | Phat file party_music.mp3 tu dong          |
| Sound effects    | Am thanh khi tap, chuyen man              |
| Random mode      | Xao tron thu tu 4 tang ngau nhien          |
| Timer            | Dong ho bam gio cho tung tang             |
| Bill Calculator  | Tinh & chia bill, share cho ca ban        |
| Share            | Chia se thanh tich + bill len mang xa hoi |

---

## Cai dat Xcode

### Yeu cau
- macOS 14.0+
- Xcode 15.2+
- iOS 17.0+

### Buoc 1 - Tao project
1. Mo Xcode -> File -> New -> Project -> iOS -> App
2. Product Name: AlcoholFormula
3. Interface: SwiftUI | Language: Swift
4. Minimum Deployments: iOS 17.0

### Buoc 2 - Them source files
Copy toan bo thu muc AlcoholFormula/ keo vao Xcode Navigator.
Chon: [x] Copy items if needed  [x] Add to target: AlcoholFormula

### Buoc 3 - Them nhac nen (tuy chon)
1. Chuan bi file nhac vui nhon - dat ten: party_music.mp3
2. Keo vao Xcode -> tick "Add to target"
3. App tu nhan va phat. Neu khong co file -> phat jingle he thong tu dong

Tim nhac mien phi:
- Pixabay Music: https://pixabay.com/music/ (tim "party upbeat")
- FreeSound.org: https://freesound.org (tim "celebration jingle")
- ZapSplat: https://www.zapsplat.com (tim "fun background music")

### Buoc 4 - Build & Run
- Nhan Cmd+R de chay Simulator
- Hoac ket noi iPhone that -> Cmd+R

---

## Cau truc project

AlcoholFormula/
|-- AlcoholFormulaApp.swift
|-- ContentView.swift
|-- Extensions/
|   -- Color+Theme.swift
|-- Models/
|   -- TangModel.swift
|-- Managers/
|   |-- SoundManager.swift       <- AVFoundation music + SFX
|   -- TimerManager.swift       <- @Observable stopwatch (iOS 17+)
-- Views/
    |-- HomeView.swift
    |-- FormulaView.swift         <- Random mode toggle
    |-- TangDetailView.swift      <- Timer per tang
    |-- SummaryView.swift         <- Share feature
    |-- BillCalculatorView.swift  <- Bill splitter
    -- Components/
        |-- TangCard.swift
        |-- ParticleView.swift
        |-- EmojiRainView.swift
        -- BubbleBackgroundView.swift

---

## Navigation flow

HomeView -> FormulaView (+ shuffle) -> TangDetailView (x4, timer) -> SummaryView -> BillCalculatorView

---
Made with love and beer | Chi mang tinh giai tri. Uong co trach nhiem!
