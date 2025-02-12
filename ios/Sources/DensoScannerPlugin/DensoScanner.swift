import Foundation

@objc public class DensoScanner: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
