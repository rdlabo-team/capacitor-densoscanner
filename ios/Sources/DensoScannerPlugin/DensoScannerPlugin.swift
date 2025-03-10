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
        CAPPluginMethod(name: "attach", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "detach", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "openRead", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "openInventory", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "close", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "pullData", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getSettings", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setSettings", returnType: CAPPluginReturnPromise)
    ]
    
    private let implementation = DensoScanner()
    public var scannerConnected: Bool = false
    public var isOpen: Bool = false
    public var isSearch: Bool = false
    public var commScanner: CommScanner? = nil
    public var rfidScanner: RFIDScanner? = nil
    public var connectMode: String = "MASTER"
    
    override public func load(){
        super.load()
        self.implementation.plugin = self
    }

    @objc func attach(_ call: CAPPluginCall) {
        self.connectMode = call.getString("connectMode", "MASTER");
        
        if scannerConnected {
            call.resolve([:])
        }
        
        if call.getString("searchType", "INITIAL") == "INITIAL" {
            guard let scanners = CommManager.getScanners() else {
                CommManager.sharedInstance().addAcceptStatusListener(listener: self)
                return
            }
            
            for scanner in scanners {
                if implementation.setupScanner(scanner: scanner) {
                    if let model = scanner.getBTLocalName(), model.contains(AppConstant.deviceSP1) {
                        break
                    } else {
                        // 目的のデバイスでないため解除
                        self.detach(call)
                    }
                }
            }
        } else if (!isSearch) {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            CommManager.sharedInstance().startAccept()
            isSearch = true
        }
        
        call.resolve([:])
    }
    
    @objc func detach(_ call: CAPPluginCall) {
        self.endAccept();
        
        commScanner?.removeStatusListener(self)
        
        var error: NSError? = nil
        commScanner?.close(&error)
        
        if (error != nil) {
            call.reject(error!.localizedDescription);
            return
        }
        
        call.resolve([:]);
    }
    
    @objc func openInventory(_ call: CAPPluginCall) {
        guard let rfidScanner = rfidScanner else {
            call.reject("scanner not connected")
            return;
        }
        
        if (!isOpen) {
            isOpen = true
            rfidScanner.setDataDelegate(delegate: self)
            
            
            var error: NSError? = nil
            rfidScanner.openInventory(&error)
            
            if (error != nil) {
                call.reject(error!.localizedDescription)
                return
            }
            call.resolve()
        } else {
            // すでに読み込みを開始しているため、何もせずにresolveを返す
            call.resolve()
        }
    }
    
    @objc func pullData(_ call: CAPPluginCall) {
        guard let rfidScanner = rfidScanner else {
            call.reject("scanner not connected")
            return;
        }
        
        if (!isOpen) {
            isOpen = true
            rfidScanner.setDataDelegate(delegate: self)
            
            var error: NSError? = nil
            rfidScanner.pullData(1, error: &error)
            
            if (error != nil) {
                call.reject(error!.localizedDescription)
                return
            }
            call.resolve()
        } else {
            // すでに読み込みを開始しているため、何もせずにresolveを返す
            call.resolve()
        }
    }
    
    
    @objc func close(_ call: CAPPluginCall) {
        guard let rfidScanner = rfidScanner else {
            call.reject("scanner not connected")
            return;
        }
        
        if (isOpen) {
            isOpen = false
            rfidScanner.setDataDelegate(delegate: nil)
            
            var error: NSError? = nil
            rfidScanner.close(&error)
            
            if (error != nil) {
                call.reject(error!.localizedDescription)
                return
            }
        }
        call.resolve()
    }
    
    @objc func getSettings(_ call: CAPPluginCall) {
        guard let scanner = commScanner else {
            call.reject("scanner not connected")
            return
        }
        
        var error: NSError? = nil
        
        // Get scanner setting value
        // If the error is not output, the obtained value is treated as not nil
        let settings = scanner.getRFIDScanner().getSettings(&error)
        let btSettings = scanner.getBtSettings(&error)
        
        if (error != nil) {
            call.reject(error!.localizedDescription)
            return
        }
        call.resolve(implementation.receiveCommScannerSettings(settings: settings!, btSettings: btSettings!))
    }
    
    @objc func setSettings(_ call: CAPPluginCall) {
        guard let scanner = commScanner else {
            call.reject("scanner not connected")
            return
        }
        
        var error: NSError? = nil
        
        let settings = scanner.getRFIDScanner().getSettings(&error)
        var btSettings = scanner.getBtSettings(&error)
        if (error != nil) {
            call.reject(error!.localizedDescription)
            return
        }
        
        if (call.getString("triggerMode") != nil) {
            settings!.scan.triggerMode = switch call.getString("triggerMode") {
            case DensoScannerTriggerMode.RFID_TRIGGER_MODE_AUTO_OFF.rawValue:
                .RFID_TRIGGER_MODE_AUTO_OFF
            case DensoScannerTriggerMode.RFID_TRIGGER_MODE_MOMENTARY.rawValue:
                .RFID_TRIGGER_MODE_MOMENTARY
            case DensoScannerTriggerMode.RFID_TRIGGER_MODE_ALTERNATE.rawValue:
                .RFID_TRIGGER_MODE_ALTERNATE
            case DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1.rawValue:
                .RFID_TRIGGER_MODE_CONTINUOUS1
            case DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS2.rawValue:
                .RFID_TRIGGER_MODE_CONTINUOUS2
            default:
                // Handle the default case (e.g., log, throw an error, or assign a default value)
                .RFID_TRIGGER_MODE_AUTO_OFF  // Example default value
            }
        }
        
        if (call.getInt("powerLevelRead") != nil) {
            settings!.scan.powerLevelRead = Int32(call.getInt("powerLevelRead")!)
        }
        
        if (call.getInt("session") != nil) {
            settings!.scan.sessionFlag = switch call.getInt("session") {
            case 0:
                SessionFlag.SESSION_FLAG_S0
            case 1:
                SessionFlag.SESSION_FLAG_S1
            case 2:
                SessionFlag.SESSION_FLAG_S2
            case 3:
                SessionFlag.SESSION_FLAG_S3
            default:
                SessionFlag.SESSION_FLAG_S1
            }
        }
        
        if (call.getString("polarization") != nil) {
            settings!.scan.polarization = switch call.getString("polarization") {
            case DensoScannerPolarization.POLARIZATION_V.rawValue:
                .POLARIZATION_V
            case DensoScannerPolarization.POLARIZATION_H.rawValue:
                .POLARIZATION_H
            case DensoScannerPolarization.POLARIZATION_BOTH.rawValue:
                .POLARIZATION_BOTH
            default:
                .POLARIZATION_BOTH
            }
        }
        
        scanner.getRFIDScanner().setSettings(settings, error: &error)
        if (error != nil) {
            call.reject(error!.localizedDescription)
            return
        }
        
        if (call.getString("connectMode") != nil) {
            btSettings = implementation.updateConnectMode(scanner: scanner, connectMode: call.getString("connectMode")!)
        }
        
        call.resolve(implementation.receiveCommScannerSettings(settings: settings!, btSettings: btSettings!))
    }
    
    public func OnScannerAppeared(scanner: CommScanner!) {
        let scannerSetup = implementation.setupScanner(scanner: scanner)
        if !scannerSetup {
            return
        }
        self.endAccept()
    }
    
    
    public func endAccept()-> Void {
        if (self.isSearch) {
            self.isSearch = false;
            CommManager.sharedInstance().endAccept()
            CommManager.sharedInstance().removeAcceptStatusListener(listener: self)
        }
    }
    
    public func OnRFIDDataReceived(scanner: CommScanner!, rfidEvent: RFIDDataReceivedEvent!) {
        let rfidDataArray = rfidEvent.getRFIDData()
            
        // 空チェック
        guard let rfidDataArray = rfidEvent.getRFIDData(), !rfidDataArray.isEmpty else {
            return
        }
            
        // すべてのデータを変換して配列に格納
        var uiiStrings: [String] = []
        var hexStrings: [String] = []
        for data in rfidDataArray {
            if let uiiString = implementation.convertDataToString(data.getUII()) {
                uiiStrings.append(uiiString)
            }
            
            if let hexString = implementation.convertDataTohexString(data.getUII()) {
                hexStrings.append(hexString)
            }
        }
            
        // 空の結果になっても通知する（必要に応じて条件変更）
        notifyListeners(DensoScannerEvents.ReadData.rawValue, data: ["codes": uiiStrings, "hexValues": hexStrings])
    }
    
    public func OnScannerStatusChanged(scanner: CommScanner!, state: CommStatusChangedEvent!) {
        let scannerStatus = state.getStatus()
        
        if scannerStatus == .SCANNER_STATUS_CLAIMED {
            notifyListeners(DensoScannerEvents.OnScannerStatusChanged.rawValue, data: ["status":DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue])
        } else if scannerStatus == .SCANNER_STATUS_CLOSE_WAIT {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            CommManager.sharedInstance().startAccept()
            scannerConnected = false
            notifyListeners(DensoScannerEvents.OnScannerStatusChanged.rawValue, data: ["status":DensoScannerStatusEvents.SCANNER_STATUS_CLOSE_WAIT.rawValue])
        } else if scannerStatus == .SCANNER_STATUS_CLOSED {
            CommManager.sharedInstance().endAccept()
            CommManager.sharedInstance().removeAcceptStatusListener(listener: self)
            scannerConnected = false
            notifyListeners(DensoScannerEvents.OnScannerStatusChanged.rawValue, data: ["status":DensoScannerStatusEvents.SCANNER_STATUS_CLOSED.rawValue])
        } else {
            notifyListeners(DensoScannerEvents.OnScannerStatusChanged.rawValue, data: ["status":DensoScannerStatusEvents.SCANNER_STATUS_UNKNOWN.rawValue])
        }
    }
}


