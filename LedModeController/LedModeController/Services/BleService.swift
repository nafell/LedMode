import Foundation
import CoreBluetooth

class BleService: NSObject, BleServiceProtocol {
    // MARK: - Public properties
    var isScanning: Bool = false
    var isConnected: Bool = false
    var discoveredPeripherals: [CBPeripheral] = []
    var connectedPeripheral: CBPeripheral?
    var errorMessage: String?
    
    // MARK: - Private properties
    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var targetService: CBService?
    private var targetCharacteristic: CBCharacteristic?
    
    // MARK: - Constants
    private let targetManufacturerName = "ESP32_RGBLED3"
    
    private let serviceUUID = CBUUID(string: "16a658e2-a958-40b2-8400-a762eb0d65f2")
    private let characteristicUUID = CBUUID(string: "82e6ec24-6e44-4bac-93f9-0c2f3936f188")
    
    // MARK: - Initialization
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public methods
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            errorMessage = "Bluetoothがオフになっています。設定から有効にしてください。"
            return
        }
        
        isScanning = true
        discoveredPeripherals = []
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        
        // 10秒後にスキャンを停止
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            self?.stopScanning()
            
            guard let targetName = self?.targetManufacturerName else { return }
            
            for peripheral in self?.discoveredPeripherals ?? [] {
                guard let name = peripheral.name else { continue }
                if name.hasPrefix(targetName) {
                    self?.connect(to: peripheral)
                    return
                }
            }
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
    
    func connect(to peripheral: CBPeripheral) {
        targetPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    // RGB値を送信する（各色0-255の値）
    func sendRGBValue(red: UInt8, green: UInt8, blue: UInt8) {
        guard let peripheral = connectedPeripheral,
              let characteristic = targetCharacteristic else {
            errorMessage = "デバイスに接続されていません"
            return
        }
//        
//        // convert data to hex string
//        let hexString = [blue, green, red].map { String(format: "%02X", $0) }.joined()
//        print("Send RGB Hex: \(hexString)")
//
//        let data = hexString.data(using: .utf8)!
        let data = Data([red, green, blue])
        print("Send RGB data: ", red, green, blue)

        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    // 特定の製造者名を持つペリフェラルを探す
    private func isTargetPeripheral(_ peripheral: CBPeripheral, advertisementData: [String: Any]) -> Bool {
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            // 製造者データからデバイス名を抽出する処理
            // 注: 実際のデータフォーマットはデバイスによって異なります
            return true // 実際の実装ではここで判定ロジックを実装
        }
        
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            return localName.contains(targetManufacturerName)
        }
        
        return false
    }
}

// MARK: - CBCentralManagerDelegate
extension BleService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetoothがオンになっています")
        case .poweredOff:
            errorMessage = "Bluetoothがオフになっています"
            isConnected = false
        case .unsupported:
            errorMessage = "このデバイスはBLEをサポートしていません"
        case .unauthorized:
            errorMessage = "Bluetooth使用の権限がありません"
        case .resetting:
            errorMessage = "Bluetoothリセット中"
        case .unknown:
            errorMessage = "不明なBluetooth状態"
        @unknown default:
            errorMessage = "不明なBluetooth状態"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if isTargetPeripheral(peripheral, advertisementData: advertisementData) {
            if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
                discoveredPeripherals.append(peripheral)
                print("発見したデバイス: \(peripheral.name ?? "不明")")
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        isConnected = true
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        print("\(peripheral.name ?? "デバイス")に接続しました")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        errorMessage = "接続に失敗しました: \(error?.localizedDescription ?? "不明なエラー")"
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        connectedPeripheral = nil
        if let error = error {
            errorMessage = "切断されました: \(error.localizedDescription)"
        } else {
            print("正常に切断されました")
        }
    }
}

// MARK: - CBPeripheralDelegate
extension BleService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            errorMessage = "サービス検出エラー: \(error.localizedDescription)"
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == serviceUUID {
                targetService = service
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            errorMessage = "特性検出エラー: \(error.localizedDescription)"
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                targetCharacteristic = characteristic
                print("対象の特性を発見しました")
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            errorMessage = "書き込みエラー: \(error.localizedDescription)"
        } else {
            print("データを正常に書き込みました")
        }
    }
} 
