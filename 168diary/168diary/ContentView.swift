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
            Text("168 Dairy")
                .font(.title)
            
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
            }
        }
    }
}

#Preview {
    ContentView()
}
