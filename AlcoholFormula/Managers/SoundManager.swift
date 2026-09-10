import AVFoundation
import AudioToolbox
import SwiftUI

/// Manages background music and SFX.
/// Drop a file named party_music.mp3 (or .m4a) into the Xcode project bundle to enable music.
/// The manager falls back to a system-sound jingle if no file is found.
final class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()

    private var bgPlayer: AVAudioPlayer?
    @Published var isMusicOn: Bool = true

    private override init() {
        super.init()
        setupSession()
        loadBGMusic()
    }

    // MARK: - Session
    private func setupSession() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // MARK: - Background music
    private func loadBGMusic() {
        let names = ["party_music", "background_music", "fun_music"]
        let exts  = ["mp3", "m4a", "wav", "caf"]
        for name in names {
            for ext in exts {
                if let url = Bundle.main.url(forResource: name, withExtension: ext) {
                    bgPlayer = try? AVAudioPlayer(contentsOf: url)
                    bgPlayer?.delegate      = self
                    bgPlayer?.numberOfLoops = -1
                    bgPlayer?.volume        = 0.25
                    bgPlayer?.prepareToPlay()
                    return
                }
            }
        }
    }

    func playMusic() {
        guard isMusicOn else { return }
        if let p = bgPlayer { p.play() } else { playJingle() }
    }

    func pauseMusic() { bgPlayer?.pause() }
    func stopMusic()  { bgPlayer?.stop() }

    func toggleMusic() {
        isMusicOn.toggle()
        if isMusicOn { playMusic() } else { pauseMusic() }
    }

    // Ascending 5-note jingle fallback
    private func playJingle() {
        let notes: [SystemSoundID] = [1104, 1057, 1016, 1025, 1057]
        for (i, note) in notes.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.22) {
                AudioServicesPlaySystemSound(note)
            }
        }
    }

    // MARK: - SFX
    func playTap()     { AudioServicesPlaySystemSound(1104) }
    func playSuccess() { AudioServicesPlaySystemSound(1016) }
    func playCheer()   { AudioServicesPlaySystemSound(1025) }
    func playWhoosh()  { AudioServicesPlaySystemSound(1057) }

    func playTangEntry(_ id: Int) {
        let ids: [SystemSoundID] = [1104, 1057, 1016, 1025]
        AudioServicesPlaySystemSound(ids[min(id - 1, ids.count - 1)])
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag { bgPlayer?.play() }
    }
}
