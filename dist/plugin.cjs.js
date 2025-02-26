'use strict';

var core = require('@capacitor/core');

exports.DensoOnScannerStatusChangedEvent = void 0;
(function (DensoOnScannerStatusChangedEvent) {
    DensoOnScannerStatusChangedEvent["SCANNER_STATUS_CLAIMED"] = "SCANNER_STATUS_CLAIMED";
    DensoOnScannerStatusChangedEvent["SCANNER_STATUS_CLOSE_WAIT"] = "SCANNER_STATUS_CLOSE_WAIT";
    DensoOnScannerStatusChangedEvent["SCANNER_STATUS_CLOSED"] = "SCANNER_STATUS_CLOSED";
    DensoOnScannerStatusChangedEvent["SCANNER_STATUS_UNKNOWN"] = "SCANNER_STATUS_UNKNOWN";
})(exports.DensoOnScannerStatusChangedEvent || (exports.DensoOnScannerStatusChangedEvent = {}));
exports.DensoScannerEvent = void 0;
(function (DensoScannerEvent) {
    DensoScannerEvent["OnScannerStatusChanged"] = "OnScannerStatusChanged";
    DensoScannerEvent["ReadData"] = "ReadData";
})(exports.DensoScannerEvent || (exports.DensoScannerEvent = {}));
exports.DensoScannerTriggerMode = void 0;
(function (DensoScannerTriggerMode) {
    DensoScannerTriggerMode["RFID_TRIGGER_MODE_AUTO_OFF"] = "RFID_TRIGGER_MODE_AUTO_OFF";
    DensoScannerTriggerMode["RFID_TRIGGER_MODE_MOMENTARY"] = "RFID_TRIGGER_MODE_MOMENTARY";
    DensoScannerTriggerMode["RFID_TRIGGER_MODE_ALTERNATE"] = "RFID_TRIGGER_MODE_ALTERNATE";
    DensoScannerTriggerMode["RFID_TRIGGER_MODE_CONTINUOUS1"] = "RFID_TRIGGER_MODE_CONTINUOUS1";
    DensoScannerTriggerMode["RFID_TRIGGER_MODE_CONTINUOUS2"] = "RFID_TRIGGER_MODE_CONTINUOUS2";
})(exports.DensoScannerTriggerMode || (exports.DensoScannerTriggerMode = {}));
exports.DensoScannerPolarization = void 0;
(function (DensoScannerPolarization) {
    DensoScannerPolarization["POLARIZATION_V"] = "POLARIZATION_V";
    DensoScannerPolarization["POLARIZATION_H"] = "POLARIZATION_H";
    DensoScannerPolarization["POLARIZATION_BOTH"] = "POLARIZATION_BOTH";
})(exports.DensoScannerPolarization || (exports.DensoScannerPolarization = {}));
exports.DensoScannerAttachSearchType = void 0;
(function (DensoScannerAttachSearchType) {
    DensoScannerAttachSearchType["INITIAL"] = "INITIAL";
    DensoScannerAttachSearchType["RECONNECT"] = "RECONNECT";
})(exports.DensoScannerAttachSearchType || (exports.DensoScannerAttachSearchType = {}));
exports.DensoScannerAttachConnectMode = void 0;
(function (DensoScannerAttachConnectMode) {
    DensoScannerAttachConnectMode["MASTER"] = "MASTER";
    DensoScannerAttachConnectMode["SLAVE"] = "SLAVE";
    DensoScannerAttachConnectMode["AUTO"] = "AUTO";
})(exports.DensoScannerAttachConnectMode || (exports.DensoScannerAttachConnectMode = {}));

const DensoScanner = core.registerPlugin('DensoScanner', {
    web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.DensoScannerWeb()),
});

class DensoScannerWeb extends core.WebPlugin {
    async attach() {
        console.log('attach');
    }
    async detach() {
        console.log('detach');
    }
    async openInventory() {
        console.log('openInventory');
    }
    async close() {
        console.log('stopScan');
    }
    async pullData() {
        console.log('pullData');
    }
    async getSettings() {
        return {
            triggerMode: exports.DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
            powerLevelRead: 30,
            session: 0,
            polarization: exports.DensoScannerPolarization.POLARIZATION_BOTH,
            connectMode: exports.DensoScannerAttachConnectMode.AUTO,
        };
    }
    async setSettings(options) {
        console.log(options);
        return {
            triggerMode: exports.DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
            powerLevelRead: 30,
            session: 0,
            polarization: exports.DensoScannerPolarization.POLARIZATION_BOTH,
            connectMode: exports.DensoScannerAttachConnectMode.AUTO,
        };
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    DensoScannerWeb: DensoScannerWeb
});

exports.DensoScanner = DensoScanner;
//# sourceMappingURL=plugin.cjs.js.map
