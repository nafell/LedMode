import Foundation
import CoreBluetooth
import Combine

class AppViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var isScanning: Bool = false
    @Published var isConnected: Bool = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var errorMessage: String?
    
    @Published var redValue: Double = 0
    @Published var greenValue: Double = 0
    @Published var blueValue: Double = 0
    
    @Published var selectedColor: ColorModel = ColorModel(id: "Black", label: "オフ", red: 0, green: 0, blue: 0)
    
    // MARK: - Private properties
    private var bleService: BleServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    // MARK: - Initialization
    init(bleService: BleServiceProtocol) {
        self.bleService = bleService
        setupBindings()
    }
    
    // MARK: - Private methods
    private func setupBindings() {
        // BleServiceの状態変化を監視
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // BleServiceの状態を反映
                self.isScanning = self.bleService.isScanning
                self.isConnected = self.bleService.isConnected
                self.discoveredPeripherals = self.bleService.discoveredPeripherals
                self.connectedPeripheral = self.bleService.connectedPeripheral
                
                // エラーメッセージの監視
                if let errorMessage = self.bleService.errorMessage {
                    self.errorMessage = errorMessage
                    self.bleService.errorMessage = nil // エラーメッセージをクリア
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public methods
    func startScanning() {
        bleService.startScanning()
    }
    
    func stopScanning() {
        bleService.stopScanning()
    }
    
    func connect(to peripheral: CBPeripheral) {
        bleService.connect(to: peripheral)
    }
    
    func disconnect() {
        bleService.disconnect()
    }
    
    func sendColor() {
        let red = UInt8(redValue * 255)
        let green = UInt8(greenValue * 255)
        let blue = UInt8(blueValue * 255)
        
        bleService.sendRGBValue(red: red, green: green, blue: blue)
    }
    
    func sendColor(color: ColorModel) {
        selectedColor = color
        let (newRed, newGreen, newBlue) = convertToLedColor(red: color.red, green: color.green, blue: color.blue)
        bleService.sendRGBValue(red: newRed, green: newGreen, blue: newBlue)
    }
    
    private func convertToLedColor(red: UInt8, green: UInt8, blue: UInt8) -> (UInt8, UInt8, UInt8) {
        return (red,green,blue)
    }
}
