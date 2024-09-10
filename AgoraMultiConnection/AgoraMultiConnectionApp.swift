//
//  AgoraMultiConnectionApp.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/5.
//

import SwiftUI

@main
struct AgoraMultiConnectionApp: App {
    @StateObject var agoraVM = AgoraViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(agoraVM)
        }
    }
}
