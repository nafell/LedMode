import Foundation
import CoreBluetooth

protocol BleServiceProtocol {
    // デバイス検出・接続関連
    func startScanning()
    func stopScanning()
    func connect(to peripheral: CBPeripheral)
    func disconnect()
    
    // データ送信関連
    func sendRGBValue(red: UInt8, green: UInt8, blue: UInt8)
    
    // 状態取得用プロパティ
    var isScanning: Bool { get }
    var isConnected: Bool { get }
    var discoveredPeripherals: [CBPeripheral] { get }
    var connectedPeripheral: CBPeripheral? { get }
    var errorMessage: String? { get set }
} 
