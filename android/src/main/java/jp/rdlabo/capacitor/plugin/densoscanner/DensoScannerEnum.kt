package jp.rdlabo.capacitor.plugin.densoscanner

import com.densowave.scannersdk.Dto.RFIDScannerSettings
import java.util.Map


enum class DensoScannerEvents(val webEventName: String) {
    OnScannerStatusChanged("OnScannerStatusChanged"),
    ReadData("ReadData")
}

enum class DensoScannerStatusEvents(val status: String) {
    SCANNER_STATUS_CLAIMED("SCANNER_STATUS_CLAIMED"),
    SCANNER_STATUS_CLOSE_WAIT("SCANNER_STATUS_CLOSE_WAIT"),
    SCANNER_STATUS_CLOSED("SCANNER_STATUS_CLOSED"),
    SCANNER_STATUS_UNKNOWN("SCANNER_STATUS_UNKNOWN")
}

object TriggerModeMapper {
    private val TRIGGER_MODE_MAP = mapOf(
        "RFID_TRIGGER_MODE_AUTO_OFF" to RFIDScannerSettings.Scan.TriggerMode.AUTO_OFF,
        "RFID_TRIGGER_MODE_MOMENTARY" to RFIDScannerSettings.Scan.TriggerMode.MOMENTARY,
        "RFID_TRIGGER_MODE_ALTERNATE" to RFIDScannerSettings.Scan.TriggerMode.ALTERNATE,
        "RFID_TRIGGER_MODE_CONTINUOUS1" to RFIDScannerSettings.Scan.TriggerMode.CONTINUOUS1,
        "RFID_TRIGGER_MODE_CONTINUOUS2" to RFIDScannerSettings.Scan.TriggerMode.CONTINUOUS2
    )

    private val REVERSE_TRIGGER_MODE_MAP = TRIGGER_MODE_MAP.entries
        .associate { it.value to it.key }

    @JvmStatic
    fun fromString(mode: String?): RFIDScannerSettings.Scan.TriggerMode {
        return TRIGGER_MODE_MAP[mode] ?: RFIDScannerSettings.Scan.TriggerMode.AUTO_OFF
    }

    @JvmStatic
    fun toString(triggerMode: RFIDScannerSettings.Scan.TriggerMode): String? {
        return REVERSE_TRIGGER_MODE_MAP[triggerMode]
    }
}

object DensoScannerPolarizationMapper {
    private val POLARIZATION_MAP = mapOf(
        "POLARIZATION_V" to RFIDScannerSettings.Scan.Polarization.V,
        "POLARIZATION_H" to RFIDScannerSettings.Scan.Polarization.H,
        "POLARIZATION_BOTH" to RFIDScannerSettings.Scan.Polarization.Both
    )

    private val REVERSE_POLARIZATION_MAP = POLARIZATION_MAP.entries
        .associate { it.value to it.key }

    @JvmStatic
    fun fromString(polarization: String?): RFIDScannerSettings.Scan.Polarization {
        return POLARIZATION_MAP[polarization] ?: RFIDScannerSettings.Scan.Polarization.Both
    }

    @JvmStatic
    fun toString(polarization: RFIDScannerSettings.Scan.Polarization): String? {
        return REVERSE_POLARIZATION_MAP[polarization]
    }
}