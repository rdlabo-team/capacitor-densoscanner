import Foundation
import Capacitor
import DENSOScannerSDK

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DensoScannerPlugin)
public class DensoScannerPlugin: CAPPlugin, CAPBridgedPlugin, ScannerAcceptStatusListener {
    public let identifier = "DensoScannerPlugin"
    public let jsName = "DensoScanner"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = DensoScanner()
    
    private var scannerConnected: Bool = false
    private(set) var commScanner: CommScanner? = nil

    @objc func echo(_ call: CAPPluginCall) {
        guard let scanners = CommManager.getScanners() else {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            CommManager.sharedInstance().startAccept()
            return
        }

        for scanner in scanners {
            if setupScanner(scanner: scanner) {
                if let model = scanner.getBTLocalName(), model.contains(AppConstant.deviceSP1) {
                    scannerConnected = true
                    commScanner = scanner
                    
                    // TODO: notification
                    break
                }
            }
        }

        if !scannerConnected {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            CommManager.sharedInstance().startAccept()
        }
        
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    
    public func OnScannerAppeared(scanner: CommScanner!) {
        // TODO: notification
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
