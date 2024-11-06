import SwiftUI

class FastingTimerViewModel: ObservableObject {
    private let startTimeKey = "startTime"
    private let timerStateKey = "timerState"

    
    
    
    
    func saveStartTime() {
        UserDefaults.standard.set(Date(), forKey: startTimeKey)
    }
    func setState(state: TimerState){
        UserDefaults.standard.set(state.rawValue, forKey: timerStateKey)
    }
    
    
    func resetTimer() {
        UserDefaults.standard.removeObject(forKey: startTimeKey)
    }
    
    func loadState() -> TimerState {
        let value = UserDefaults.standard.integer(forKey: timerStateKey)
        return TimerState(rawValue: value) ?? .nothing
    }
    
    
    func timeDifference(state: TimerState?) -> String {

        let eatingDuration: TimeInterval = 8 * 3600  // 8 hours in seconds
        // 从 UserDefaults 读取时间并进行类型转换
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else {
            return "00:00:00"
        }
        var timeInterval: Int
        if state == .eating {
            // 计算吃饭阶段剩余时间
            let timeSinceStart = Date().timeIntervalSince(startTime)
            timeInterval = Int(eatingDuration - timeSinceStart)
            if timeInterval < 0 {
                return "Stop Eating!!"
            }
        } else if state == .fasting {
            // 计算禁食阶段已过时间
            timeInterval = Int(Date().timeIntervalSince(startTime))
        } else {
            // 如果没有指定状态，视为禁食状态
            timeInterval = Int(Date().timeIntervalSince(startTime))
        }

        // 计算小时、分钟、秒
        let hours = timeInterval / 3600
        let minutes = (timeInterval % 3600) / 60
        let seconds = timeInterval % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
