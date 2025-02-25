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

public enum DensoScannerTriggerMode: String {
    case RFID_TRIGGER_MODE_AUTO_OFF = "RFID_TRIGGER_MODE_AUTO_OFF"
    case RFID_TRIGGER_MODE_MOMENTARY = "RFID_TRIGGER_MODE_MOMENTARY"
    case RFID_TRIGGER_MODE_ALTERNATE = "RFID_TRIGGER_MODE_ALTERNATE"
    case RFID_TRIGGER_MODE_CONTINUOUS1 = "RFID_TRIGGER_MODE_CONTINUOUS1"
    case RFID_TRIGGER_MODE_CONTINUOUS2 = "RFID_TRIGGER_MODE_CONTINUOUS2"
}

public enum DensoScannerPolarization: String {
    case POLARIZATION_V = "POLARIZATION_V"
    case POLARIZATION_H = "POLARIZATION_H"
    case POLARIZATION_BOTH = "POLARIZATION_BOTH"
}

public enum DensoScannerConnectMode: String {
    case MASTER = "MASTER"
    case SLAVE = "SLAVE"
    case AUTO = "AUTO"
}
