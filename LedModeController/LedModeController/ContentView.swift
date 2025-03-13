//
//  ContentView.swift
//  LedModeController
//
//  Created by 長峯幸佑 on 2025/03/13.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var bleService = BleService()
    @State private var redValue: Double = 0
    @State private var greenValue: Double = 0
    @State private var blueValue: Double = 0
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 接続状態表示
                HStack {
                    Image(systemName: bleService.isConnected ? "bluetooth.connected" : "bluetooth.slash")
                        .foregroundColor(bleService.isConnected ? .blue : .red)
                    Text(bleService.isConnected ? "接続済み" : "未接続")
                        .foregroundColor(bleService.isConnected ? .blue : .red)
                }
                .font(.headline)
                .padding()
                
                // スキャン/接続ボタン
                if bleService.isConnected {
                    Button(action: {
                        bleService.disconnect()
                    }) {
                        Text("切断")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                        bleService.startScanning()
                    }) {
                        Text(bleService.isScanning ? "スキャン中..." : "デバイスをスキャン")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(bleService.isScanning ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(bleService.isScanning)
                }
                
                // 発見したデバイスのリスト
                if !bleService.isConnected && !bleService.discoveredPeripherals.isEmpty {
                    List {
                        ForEach(bleService.discoveredPeripherals, id: \.identifier) { peripheral in
                            Button(action: {
                                bleService.connect(to: peripheral)
                            }) {
                                HStack {
                                    Text(peripheral.name ?? "不明なデバイス")
                                    Spacer()
                                    Image(systemName: "bluetooth")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }
                
                // RGB値コントロール（接続時のみ表示）
                if bleService.isConnected {
                    VStack(spacing: 20) {
                        ColorPreview(red: redValue, green: greenValue, blue: blueValue)
                            .frame(height: 100)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        ColorSlider(value: $redValue, color: .red, label: "赤")
                        ColorSlider(value: $greenValue, color: .green, label: "緑")
                        ColorSlider(value: $blueValue, color: .blue, label: "青")
                        
                        Button(action: {
                            sendColor()
                        }) {
                            Text("色を送信")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("LED コントローラー")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("エラー"),
                    message: Text(bleService.errorMessage ?? "不明なエラー"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: bleService.errorMessage) { newValue in
                if newValue != nil {
                    showAlert = true
                }
            }
        }
    }
    
    private func sendColor() {
        let red = UInt8(redValue * 255)
        let green = UInt8(greenValue * 255)
        let blue = UInt8(blueValue * 255)
        
        bleService.sendRGBValue(red: red, green: green, blue: blue)
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
    ContentView()
}
