//
//  LedModeControllerApp.swift
//  LedModeController
//
//  Created by 長峯幸佑 on 2025/03/13.
//

import SwiftUI

@main
struct LedModeControllerApp: App {
    // 実際のBLEサービスを使用
    private let bleService = BleService()
    
    // ViewModelの初期化
    @StateObject private var viewModel: AppViewModel
    
    init() {
        // ViewModelの初期化
        let vm = AppViewModel(bleService: bleService)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
