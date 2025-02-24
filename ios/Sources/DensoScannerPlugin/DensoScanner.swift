import Foundation

@objc public class DensoScanner: NSObject {
    
    func setupScanner(scanner: CommScanner) -> Bool {
        var error: NSError? = nil
        scanner.claim(&error)
        if (error != nil) {
            return false
        }
        return true
    }
    
    func convertDataToString(_ data: Data) -> String? {
        return data.map { String(format: "%02X", $0) }.joined()
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
}
