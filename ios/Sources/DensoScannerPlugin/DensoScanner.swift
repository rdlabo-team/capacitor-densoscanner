import Foundation
import Capacitor
import DENSOScannerSDK

@objc public class DensoScanner: NSObject {
    weak var plugin: DensoScannerPlugin?
    
    func setupScanner(scanner: CommScanner) -> Bool {
        var error: NSError? = nil
        scanner.claim(&error)
        if (error != nil) {
            return false
        }
        
        plugin!.notifyListeners(DensoScannerEvents.OnScannerStatusChanged.rawValue, data: ["status":DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue])
        plugin!.scannerConnected = true
        plugin!.commScanner = scanner
        plugin!.rfidScanner = scanner.getRFIDScanner()
        scanner.addStatusListener(plugin!)
        updateConnectMode(scanner: scanner, connectMode: plugin!.connectMode)
        
        return true
    }
    
    func updateConnectMode(scanner: CommScanner, connectMode: String) -> CommScannerBtSettings {
        var error: NSError? = nil
        
        let btSettings = scanner.getBtSettings(&error)
        if(plugin!.connectMode == DensoScannerConnectMode.SLAVE.rawValue && btSettings?.mode != .MODE_SLAVE) {
            btSettings?.mode = .MODE_SLAVE
            scanner.setBtSettings(btSettings, error: &error)
        } else if (plugin!.connectMode == DensoScannerConnectMode.MASTER.rawValue && btSettings?.mode != .MODE_MASTER) {
            btSettings?.mode = .MODE_MASTER
            scanner.setBtSettings(btSettings, error: &error)
        }
        
        return btSettings!
    }
    
    func convertDataToString(_ data: Data) -> String? {
        return data.map { String(format: "%02X", $0) }.joined()
    }
    
    func convertDataTohexString(_ data: Data) -> String? {
        return data.map { String(format: "%02X", $0) }.joined(separator: " ")
    }
    
    func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    func receiveCommScannerSettings(settings: RFIDScannerSettings, btSettings: CommScannerBtSettings) -> JSObject {
        
        let triggerMode: String = switch settings.scan.triggerMode {
            case .RFID_TRIGGER_MODE_AUTO_OFF:
                DensoScannerTriggerMode.RFID_TRIGGER_MODE_AUTO_OFF.rawValue
            case .RFID_TRIGGER_MODE_MOMENTARY:
                DensoScannerTriggerMode.RFID_TRIGGER_MODE_MOMENTARY.rawValue
            case .RFID_TRIGGER_MODE_ALTERNATE:
                DensoScannerTriggerMode.RFID_TRIGGER_MODE_ALTERNATE.rawValue
            case .RFID_TRIGGER_MODE_CONTINUOUS1:
                DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1.rawValue
            case .RFID_TRIGGER_MODE_CONTINUOUS2:
                DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS2.rawValue
            }
        
        let session: Int = switch settings.scan.sessionFlag {
        case SessionFlag.SESSION_FLAG_S0:
            0
        case SessionFlag.SESSION_FLAG_S1:
           1
        case SessionFlag.SESSION_FLAG_S2:
            2
        case SessionFlag.SESSION_FLAG_S3:
            3
        }
        
        let connectMode : String = switch btSettings.mode {
        case .MODE_MASTER : DensoScannerConnectMode.MASTER.rawValue
        case .MODE_SLAVE : DensoScannerConnectMode.SLAVE.rawValue
        case .MODE_AUTO : DensoScannerConnectMode.AUTO.rawValue
        }
        
        
        return [
            "triggerMode": triggerMode,
            "powerLevelRead": Int(settings.scan.powerLevelRead),
            "session": session,
            "polarization": settings.scan.polarization.des(),
            "connectMode": connectMode,
        ]
    }
}

extension Polarization {
    func des() -> String {
        switch self {
        case .POLARIZATION_V:
            return DensoScannerPolarization.POLARIZATION_V.rawValue
        case .POLARIZATION_H:
            return DensoScannerPolarization.POLARIZATION_H.rawValue
        case .POLARIZATION_BOTH:
            return DensoScannerPolarization.POLARIZATION_BOTH.rawValue
        }
    }
}
