import Foundation
import CoreBluetooth

class MockBleService: BleServiceProtocol {
    // MARK: - Public properties
    var isScanning: Bool = false
    var isConnected: Bool = false
    var discoveredPeripherals: [CBPeripheral] = []
    var connectedPeripheral: CBPeripheral?
    var errorMessage: String?
    
    // モック用のデバイス
    private var mockPeripherals: [CBPeripheral] = []
    
    // MARK: - Initialization
    init() {
        // モックデータの初期化
        // 実際のCBPeripheralはモックできないため、テスト時は別の方法が必要
    }
    
    // MARK: - Public methods
    func startScanning() {
        isScanning = true
        
        // モックデバイスを発見したと仮定
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // モックデバイスを追加
            // 実際のテストでは、CBPeripheralのモックが必要
//            let mockPeripheral = CBPeripheral()
//            
//            discoveredPeripherals = [mockPeripheral]
            
            self.stopScanning()
        }
    }
    
    func stopScanning() {
        isScanning = false
    }
    
    func connect(to peripheral: CBPeripheral) {
        // 接続成功を模擬
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.connectedPeripheral = peripheral
            self?.isConnected = true
        }
    }
    
    func disconnect() {
        connectedPeripheral = nil
        isConnected = false
    }
    
    // RGB値を送信する（各色0-255の値）
    func sendRGBValue(red: UInt8, green: UInt8, blue: UInt8) {
        if !isConnected {
            errorMessage = "デバイスに接続されていません"
            return
        }
        
        print("モック: RGB値を送信しました - R:\(red) G:\(green) B:\(blue)")
    }
} 
