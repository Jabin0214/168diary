import SwiftUI

class FastingTimerViewModel: ObservableObject {
    private let startTimeKey = "startTime"
    private let timerStateKey = "timerState"
    private var timer: Timer? // 让定时器逻辑与状态管理绑定
    @Published var timeDifferenceText: String = "00:00:00" // 使用 @Published 让 View 自动绑定更新

    func getDate() -> String {
        guard let date = UserDefaults.standard.object(forKey: startTimeKey) as? Date else {
            return "No start time set"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }

    func saveStartTime() {
        UserDefaults.standard.set(Date(), forKey: startTimeKey)
    }

    func resetTimer() {
        UserDefaults.standard.removeObject(forKey: startTimeKey)
        stopTimer()
        timeDifferenceText = "00:00:00"
    }

    func loadState() -> TimerState {
        let value = UserDefaults.standard.integer(forKey: timerStateKey)
        return TimerState(rawValue: value) ?? .nothing
    }

    func setState(state: TimerState) {
        UserDefaults.standard.set(state.rawValue, forKey: timerStateKey)
        if state != .nothing {
            startTimer(for: state)
        } else {
            stopTimer()
        }
    }

    func timeDifference(state: TimerState) -> String {
        let eatingDuration: TimeInterval = 8*60*60 // 假设为 5 秒
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else {
            return "00:00:00"
        }

        var timeInterval: Int
        switch state {
        case .eating:
            timeInterval = Int(max(eatingDuration - Date().timeIntervalSince(startTime), 0))
            if timeInterval <= 0 {
                stopTimer()
                return "Stop Eating!!"
            }
        case .fasting:
            timeInterval = Int(Date().timeIntervalSince(startTime))
        default:
            return "00:00:00"
        }

        let hours = timeInterval / 3600
        let minutes = (timeInterval % 3600) / 60
        let seconds = timeInterval % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func startTimer(for state: TimerState) {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeDifferenceText = self.timeDifference(state: state)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    func updateStartTime(by offsetInSeconds: Int) {
            // 获取当前的开始时间（如果没有，则使用当前时间作为基准）
            let currentStartTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date ?? Date()

            // 根据偏移量计算新的开始时间
            let newStartTime = Calendar.current.date(byAdding: .second, value: offsetInSeconds, to: currentStartTime) ?? Date()

            // 更新保存的开始时间
            UserDefaults.standard.set(newStartTime, forKey: startTimeKey)

            // 立即更新显示的时间差
            timeDifferenceText = timeDifference(state: loadState())
        }
}
