//
//  ContentView.swift
//  168dairy
//
//  Created by Jabin on 2024/11/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // 优化标题
            Text("168 Diary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .padding()
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 3)

            TabView {
                // 第一个标签页：主页
                Text("Home")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                // 第二个标签页：计时器视图
                TimerView()
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Time")
                    }

                // 第三个标签页：喝水页面
                Text("Water")
                    .tabItem {
                        Image(systemName: "drop.fill")
                        Text("Water")
                    }
            }
            .accentColor(.purple) // 更改选中状态的颜色
        }
    }
}

#Preview {
    ContentView()
}
