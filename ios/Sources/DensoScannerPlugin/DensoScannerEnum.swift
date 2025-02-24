struct AppConstant {
    static let deviceSP1 = "SP1"
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
