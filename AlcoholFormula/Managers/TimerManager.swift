import SwiftUI

/// Async-based stopwatch using Swift Concurrency. Requires iOS 17+ (@Observable).
@Observable
final class TimerManager {
    var elapsed:   Int  = 0
    var isRunning: Bool = false

    private var task: Task<Void, Never>?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        task = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled { elapsed += 1 }
            }
        }
    }

    func pause() { task?.cancel(); task = nil; isRunning = false }
    func reset() { pause(); elapsed = 0 }

    var formatted: String {
        let h = elapsed / 3600
        let m = (elapsed % 3600) / 60
        let s = elapsed % 60
        if h > 0 { return String(format: "%02d:%02d:%02d", h, m, s) }
        return String(format: "%02d:%02d", m, s)
    }

    deinit { task?.cancel() }
}
