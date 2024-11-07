import SwiftUI

struct TimerView: View {
    @StateObject private var fastingTimer = FastingTimerViewModel()
    @State var state: TimerState = .nothing
    
    @State private var selectedOption: String = "None"
    
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(fastingTimer.timeDifferenceText)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()
                .cornerRadius(12)
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .cornerRadius(16)
            
            Text("Start Time: " + fastingTimer.getDate())
                .font(.title3)
                .foregroundColor(.secondary)
                .padding()
            
            TimeMenu(title: "Adjust Time", selectedOption: $selectedOption, onTimeChange: { offset in
                fastingTimer.updateStartTime(by: offset)
            }, state: state)
            
            Button("Reset") {
                fastingTimer.resetTimer()
                state = .nothing
            }
            .styledButton()
            
            Button("Start Fasting") {
                fastingTimer.saveStartTime()
                fastingTimer.setState(state: .fasting)
                state = .fasting
            }
            .styledButton()
            
            Button("Start Eating") {
                fastingTimer.saveStartTime()
                fastingTimer.setState(state: .eating)
                state = .eating
            }
            .styledButton()
            
            Spacer()
        }
        .padding()
        .onAppear {
            state = fastingTimer.loadState()
            fastingTimer.setState(state: state)
        }
    }
}

extension Button {
    func styledButton() -> some View {
        self
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(width: 210)
            .background(Color(red: 150/255, green: 123/255, blue: 182/255))
            .cornerRadius(12)
    }
}

struct TimeMenu: View {
    let title: String
    @Binding var selectedOption: String
    var onTimeChange: (Int) -> Void
    var state: TimerState // 新增参数

    private let quickAddOptions: [(String, Int)] = [
        ("Late by 1 hour", 3600),
        ("Late by 30 mins", 1800),
        ("Late by 1 min", 60)
    ]
    
    private let quickReduceOptions: [(String, Int)] = [
        ("Early by 1 hour", -3600),
        ("Early by 30 mins", -1800),
        ("Early by 1 min", -60)
    ]

    var body: some View {
        if state != .nothing { // 只有在状态不是 nothing 时显示菜单
            Menu {
                Section(header: Text("Quick Add")) {
                    ForEach(quickAddOptions, id: \.0) { label, offset in
                        Button(label) {
                            selectedOption = "\(offset / 60) mins"
                            onTimeChange(offset)
                        }
                    }
                }

                Divider()

                Section(header: Text("Quick Reduce")) {
                    ForEach(quickReduceOptions, id: \.0) { label, offset in
                        Button(label) {
                            selectedOption = "\(offset / 60) mins"
                            onTimeChange(offset)
                        }
                    }
                }
            } label: {
                Label(title, systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    TimerView()
}
