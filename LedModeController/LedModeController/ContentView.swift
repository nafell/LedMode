//
//  ContentView.swift
//  LedModeController
//
//  Created by 長峯幸佑 on 2025/03/13.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var viewModel: AppViewModel
    @State private var showAlert = false
    
    init(viewModel: AppViewModel? = nil) {
        // 依存性注入またはデフォルト値を使用
        let vm = viewModel ?? AppViewModel(bleService: BleService())
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // RGB値コントロール（接続時のみ表示）
                if viewModel.isConnected {

                }
                
                ColorControllerView(vm: viewModel)
                
                // 接続状態表示
                HStack {
                    Image(systemName: viewModel.isConnected ? "bluetooth.connected" : "bluetooth.slash")
                        .foregroundColor(viewModel.isConnected ? .blue : .red)
                    Text(viewModel.isConnected ? "接続済み" : "未接続")
                        .foregroundColor(viewModel.isConnected ? .blue : .red)
                }
                .font(.headline)
                .padding()
                
                // スキャン/接続ボタン
                if viewModel.isConnected {
                    Spacer()
                    Button(action: {
                        viewModel.disconnect()
                    }) {
                        Text("切断")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(width: 80)
                        Spacer()
                    }
                } else {
                    Button(action: {
                        viewModel.startScanning()
                    }) {
                        Text(viewModel.isScanning ? "スキャン中..." : "デバイスに接続")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isScanning ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isScanning)
                }
                
//                // 発見したデバイスのリスト
//                if !viewModel.isConnected && !viewModel.discoveredPeripherals.isEmpty {
//                    List {
//                        ForEach(viewModel.discoveredPeripherals, id: \.identifier) { peripheral in
//                            Button(action: {
//                                viewModel.connect(to: peripheral)
//                            }) {
//                                HStack {
//                                    Text(peripheral.name ?? "不明なデバイス")
//                                    Spacer()
//                                    Image(systemName: "bluetooth")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                    .frame(height: 200)
//                }
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("エラー"),
                    message: Text(viewModel.errorMessage ?? "不明なエラー"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                if newValue != nil {
                    showAlert = true
                }
            }
        }
    }
}

struct ColorSlider: View {
    @Binding var value: Double
    let color: Color
    let label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Text("\(Int(value * 255))")
            }
            Slider(value: $value, in: 0...1)
                .accentColor(color)
        }
    }
}

struct ColorPreview: View {
    let red: Double
    let green: Double
    let blue: Double
    
    var body: some View {
        Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView(viewModel: AppViewModel(bleService: MockBleService()))
}
