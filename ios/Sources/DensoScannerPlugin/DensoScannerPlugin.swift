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
    
    private var scannerConnected: Bool = false
    private var isOpen: Bool = false
    private(set) var commScanner: CommScanner? = nil
    private(set) var rfidScanner: RFIDScanner? = nil

    @objc func attach(_ call: CAPPluginCall) {
        guard let scanners = CommManager.getScanners() else {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
            return
        }

        for scanner in scanners {
            if implementation.setupScanner(scanner: scanner) {
                if let model = scanner.getBTLocalName(), model.contains(AppConstant.deviceSP1) {
                    scannerConnected = true
                    commScanner = scanner
                    rfidScanner = scanner.getRFIDScanner()
                    notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue, data: [:])
                    scanner.addStatusListener(self)
                    break
                }
            }
        }

        if !scannerConnected {
            CommManager.sharedInstance().addAcceptStatusListener(listener: self)
        }
        
        call.resolve([:])
    }
    
    @objc func detach(_ call: CAPPluginCall) {
        if (isOpen) {
            CommManager.sharedInstance()?.endAccept()
        }
        
        commScanner?.removeStatusListener(self)
        
        var error: NSError? = nil
        commScanner?.close(&error)
        
        if (error != nil) {
            call.reject(error!.localizedDescription);
            return
        }
        
        call.resolve([:]);
    }
    
    @objc func openRead(_ call: CAPPluginCall) {
        guard let rfidScanner = rfidScanner else {
            call.reject("scanner not connected")
            return;
        }
        
        if (!isOpen) {
            isOpen = true
            rfidScanner.setDataDelegate(delegate: self)
            
            let address = Int16(0)
            let pass = "00000000"
            var error: NSError? = nil
            
            guard let password = implementation.stringToBytes(pass), let uii = implementation.stringToBytes("") else {
                call.reject("scanner not connected")
                return;
            }
            
            rfidScanner.openRead(.RFID_BANK_UII,
                             addr: address,
                             size: Int16(Data(uii).count),
                             pwd: Data(password),
                             uii: Data(uii),
                             error: &error)
            
            call.resolve()
        } else {
            // すでに読み込みを開始しているため、何もせずにresolveを返す
            call.resolve()
        }
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
    
    @objc func pullData(_ call: CAPPluginCall) {
        guard let rfidScanner = rfidScanner else {
            call.reject("scanner not connected")
            return;
        }
        
        var error: NSError? = nil
        rfidScanner.pullData(1, error: &error)
        
        if (error != nil) {
            call.reject(error!.localizedDescription)
            return
        }
        call.resolve()
    }
    
    @objc func getSettings(_ call: CAPPluginCall) {
        var dataSetStruct = SettingDataSet.init()
        
        guard let scanner = commScanner else {
            call.reject("scanner not connected")
            return
        }
        
        var error: NSError? = nil
        
        // Get scanner setting value
        // If the error is not output, the obtained value is treated as not nil
        let settings = scanner.getRFIDScanner().getSettings(&error)
        if (error != nil) {
            call.reject(error!.localizedDescription)
            return
        }
        call.resolve(implementation.receiveCommScannerSettings(settings: settings!))
    }
    
    @objc func setSettings(_ call: CAPPluginCall) {
        
    }
    
    public func OnScannerAppeared(scanner: CommScanner!) {
        let scannerSetup = implementation.setupScanner(scanner: scanner)
        if !scannerSetup {
            return
        }
        
        CommManager.sharedInstance().endAccept()
        CommManager.sharedInstance().removeAcceptStatusListener(listener: self)
        
        scannerConnected = true
        commScanner = scanner
        rfidScanner = scanner.getRFIDScanner()
        notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.rawValue, data: [:])
        scanner.addStatusListener(self)
    }
    
    public func OnRFIDDataReceived(scanner: CommScanner!, rfidEvent: RFIDDataReceivedEvent!) {
        guard let data = rfidEvent.getRFIDData().first else {
            return
        }
        
        guard let uiiString = implementation.convertDataToString(data.getUII()) else {
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
}


