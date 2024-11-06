import SwiftUI

struct TimerView: View {
    @StateObject private var fastingTimer = FastingTimerViewModel()
    @State private var timeDifferenceText: String = "00:00:00"
    @State private var timer: Timer?
    @State var state: TimerState = .nothing

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text(timeDifferenceText)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .shadow(radius: 5)
            
            Text("Start Time: " + fastingTimer.getDate())
                .font(.title3)
                .padding()
            

            Spacer()

            Button("Reset") {
                fastingTimer.resetTimer()
                fastingTimer.setState(state: .nothing)
            }
            .styledButton()

            Button("Start Fasting") {
                fastingTimer.saveStartTime()
                restartTimer(state: .fasting)
            }
            .styledButton()

            Button("Start Eating") {
                fastingTimer.saveStartTime()
                restartTimer(state: .eating)
            }
            .styledButton()

            Spacer()
        }
        .padding()
        .onAppear {
            timeDifferenceText=fastingTimer.timeDifference(state: state)
            state = fastingTimer.loadState()
            if state != .nothing {
                restartTimer(state: state)
            }
        }
    }

    func restartTimer(state: TimerState) {
        fastingTimer.setState(state: state)
        timer?.invalidate() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeDifferenceText = fastingTimer.timeDifference(state: state)
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

#Preview {
    TimerView()
}
