import Foundation
import Capacitor
import DENSOScannerSDK

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DensoScannerPlugin)
public class DensoScannerPlugin: CAPPlugin, CAPBridgedPlugin, ScannerAcceptStatusListener, ScannerStatusListener, RFIDDataDelegate {
    
    public let identifier = "DensoScannerPlugin"
    public let jsName = "DensoScanner"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startRead", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopRead", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = DensoScanner()
    
    private var scannerConnected: Bool = false
    private var scannerRead: Bool = false
    private(set) var commScanner: CommScanner? = nil

    @objc func initialize(_ call: CAPPluginCall) {
        guard let scanners = CommManager.getScanners() else {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            return
        }

        for scanner in scanners {
            if setupScanner(scanner: scanner) {
                if let model = scanner.getBTLocalName(), model.contains(AppConstant.deviceSP1) {
                    scannerConnected = true
                    commScanner = scanner
                    notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue, data: [:])
                    break
                }
            }
        }

        if !scannerConnected {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
        }
        
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    
    @objc func startRead(_ call: CAPPluginCall) {
        if (scannerConnected && !scannerRead) {
            CommManager.sharedInstance()?.startAccept()
            scannerRead = true
            call.resolve()
        } else if (scannerRead) {
            // すでに読み込みを行っているため、何もせずにresolveを返す
            call.resolve()
        } else {
            call.reject("scanner not connected")
        }
    }
    
    
    @objc func stopRead(_ call: CAPPluginCall) {
        if (scannerRead) {
            CommManager.sharedInstance()?.endAccept()
        }
        call.resolve()
    }
    
    
    
    public func OnScannerAppeared(scanner: CommScanner!) {
        notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue, data: [:])
    }
    
    
    public func OnRFIDDataReceived(scanner: CommScanner!, rfidEvent: RFIDDataReceivedEvent!) {
        guard let data = rfidEvent.getRFIDData().first else {
            return
        }
        
        guard let uiiString = convertDataToString(data.getUII()) else {
            return
        }
        
        notifyListeners(DensoScannerEvents.ReadData.rawValue, data: [ "code": uiiString])
    }
    
    public func OnScannerStatusChanged(scanner: CommScanner!, state: CommStatusChangedEvent!) {
        let scannerStatus = state.getStatus()
        
        if scannerStatus == .SCANNER_STATUS_CLAIMED {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue, data: [:])
        } else if scannerStatus == .SCANNER_STATUS_CLOSE_WAIT {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            CommManager.sharedInstance().startAccept()
            scannerConnected = false
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLOSE_WAIT.rawValue, data: [:])
        } else if scannerStatus == .SCANNER_STATUS_CLOSED {
            CommManager.sharedInstance().endAccept()
            CommManager.sharedInstance().removeAcceptStatusListener(listener: self)
            scannerConnected = false
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLOSED.rawValue, data: [:])
        } else {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_UNKNOWN.rawValue, data: [:])
        }
    }
    
    private func setupScanner(scanner: CommScanner) -> Bool {
        var error: NSError? = nil
        scanner.claim(&error)
        if (error != nil) {
            return false
        }
        
        // TODO: notification
        return true
    }
    
    func convertDataToString(_ data: Data) -> String? {
        return data.map { String(format: "%02X", $0) }.joined()
    }
}

struct AppConstant {
    static let appTitle = "SP1 DemoSDK"
    static let deviceSP1 = "SP1"
    static let locateTagTitle = "Locate Tag"
    static let bluetoothTitle = "Bluetooth"
    static let barcodeTitle = "Barcode"
    static let rfidTitle = "Rfid"
    static let dBm = "dBm"
    static let noValue = "No Value"
    static let uiiKey = "uiiKey"
    static let done = "Done"
    static let cancel = "Cancel"
    static let loading = "Loading"
    static let wavExtension = "wav"
    static let isConnected = "isConnected"
    static let track1SoundName = "track1"
    static let track2SoundName = "track2"
    static let track3SoundName = "track3"
    static let track4SoundName = "track4"
    static let track5SoundName = "track5"
    static let buttonWidth = 88
    static let buttonHeight = 35
    static let waitingTime = TimeInterval(exactly: 0.6)
}

public enum DensoScannerEvents: String {
    case OnScannerStatusChanged = "OnScannerStatusChanged"
    case ReadData = "ReadData"
}


public enum DensoScannerStatusEvents: String {
    case SCANNER_STATUS_CLAIMED = "SCANNER_STATUS_CLAIMED"
    case SCANNER_STATUS_CLOSE_WAIT = "SCANNER_STATUS_CLOSE_WAIT"
    case SCANNER_STATUS_CLOSED = "SCANNER_STATUS_CLOSED"
    case SCANNER_STATUS_UNKNOWN = "SCANNER_STATUS_UNKNOWN"
}
