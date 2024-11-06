import SwiftUI

class FastingTimerViewModel: ObservableObject {
    private let startTimeKey = "startTime"
    private let timerStateKey = "timerState"

    

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

        let eatingDuration: TimeInterval = 5  // 8 hours in seconds
        // 从 UserDefaults 读取时间并进行类型转换
        guard let startTime = UserDefaults.standard.object(forKey: startTimeKey) as? Date else {
            return "00:00:00"
        }
        
        var timeInterval: Int
        
        switch state {
        case .eating:
            timeInterval = Int(eatingDuration - Date().timeIntervalSince(startTime))
            if timeInterval == 0 {
                sendEndOfEatingNotification()
                return "Stop Eating!!"
            }
        case .fasting:
            timeInterval = Int(Date().timeIntervalSince(startTime))
        default:
            return "00:00:00"
        }
        

        // 计算小时、分钟、秒
        let hours = timeInterval / 3600
        let minutes = (timeInterval % 3600) / 60
        let seconds = timeInterval % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
