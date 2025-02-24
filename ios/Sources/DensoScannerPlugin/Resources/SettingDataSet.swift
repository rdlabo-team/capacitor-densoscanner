//
//  SettingDataSet.swift
//  DensoScannerSDK_Demo
//
//  Created by SP1 on 2018/06/18.
//  Copyright © 2018年 SP1. All rights reserved.
//

import UIKit

// Data set of SettingData
class SettingDataSet: Codable {
	var readPowerLevel:     SettingDataWithNumberPicker!
	var session:            SettingDataWithStringPicker!
	var reportUniqueTags:   SettingDataWithSwitch!
	var channels:           SettingDataWithChannels!
	var qFactor:            SettingDataWithNumberPicker!
	var linkProfile:        SettingDataWithStringPicker!
	var autoLinkProfile:    SettingDataWithSwitch!
	var polarization:       SettingDataWithStringPicker!
	var powerSaveExt:       SettingDataWithSwitch!
	var rfid:            	SettingDataWithHeader!
	var triggerModeRFID:    SettingDataWithStringPicker!
	var buzzer:             SettingDataWithSwitch!
	var buzzerVolume:       SettingDataWithStringPicker!
	var barcode:            SettingDataWithHeader!
	var triggerMode:        SettingDataWithStringPicker!
	var enableAll1DCode:    SettingDataWithSwitch!
	var enableAll2DCode:    SettingDataWithSwitch!
	
	/// Initialize as an empty data set
	init() {
		readPowerLevel = nil
		session = nil
		reportUniqueTags = nil
		channels = nil
		qFactor = nil
		autoLinkProfile = nil
		linkProfile = nil
		polarization = nil
		powerSaveExt = nil
		rfid = nil
		triggerModeRFID = nil
		buzzer = nil
		buzzerVolume = nil
		barcode = nil
		triggerMode = nil
		enableAll1DCode = nil
		enableAll2DCode = nil
	}
	
	/// an array of all the elements arranged in definition order
	var values: [SettingData] {
		get {
			let result: [SettingData] = [
				readPowerLevel,
				session,
				reportUniqueTags,
				channels,
				qFactor,
				autoLinkProfile,
				linkProfile,
				polarization,
				powerSaveExt,
				rfid,
				triggerModeRFID,
				buzzer,
				buzzerVolume,
				barcode,
				triggerMode,
				enableAll1DCode,
				enableAll2DCode,
				]
			return result
		}
		set(v) {
			var i = 0
			readPowerLevel      = v[i] as? SettingDataWithNumberPicker; i += 1
			session             = v[i] as? SettingDataWithStringPicker; i += 1
			reportUniqueTags    = v[i] as? SettingDataWithSwitch;       i += 1
			channels            = v[i] as? SettingDataWithChannels;     i += 1
			qFactor             = v[i] as? SettingDataWithNumberPicker; i += 1
			autoLinkProfile     = v[i] as? SettingDataWithSwitch;       i += 1
			linkProfile         = v[i] as? SettingDataWithStringPicker; i += 1
			polarization        = v[i] as? SettingDataWithStringPicker; i += 1
			powerSaveExt        = v[i] as? SettingDataWithSwitch;       i += 1
			rfid                = v[i] as? SettingDataWithHeader;       i += 1
			triggerModeRFID     = v[i] as? SettingDataWithStringPicker; i += 1
			buzzer              = v[i] as? SettingDataWithSwitch;       i += 1
			buzzerVolume        = v[i] as? SettingDataWithStringPicker; i += 1
			barcode             = v[i] as? SettingDataWithHeader;       i += 1
			triggerMode         = v[i] as? SettingDataWithStringPicker; i += 1
			enableAll1DCode     = v[i] as? SettingDataWithSwitch;       i += 1
			enableAll2DCode     = v[i] as? SettingDataWithSwitch;       i += 1
		}
	}
}

/// Base of configuration data
protocol SettingData: Codable {
	var height: CGFloat {get}
}

/// Common processing of picker data
protocol SettingDataWithPicker {
	var _headerText: String { get set }
	var _item: String { get set }
	var _allItems: [String] { get set }
	var _unit: String { get set }
}

/// Configuration data for header only
class SettingDataWithHeader: SettingData {
	
	var headerText: String = ""
	
	var height: CGFloat { get { return 64.0 } }
}

/// Configuration data for picking text
class SettingDataWithStringPicker: SettingData, SettingDataWithPicker {
	
	var headerText: String = ""
	var item: String = ""
	var allItems: [String] = []
	var unit: String = ""
	
	var height: CGFloat { get { return 64.0 } }
	
	var _headerText: String { get { return headerText } set(v) { headerText = v } }
	var _item: String { get { return item } set(v) { item = v } }
	var _allItems: [String] { get { return allItems } set(v) { allItems = v } }
	var _unit: String { get { return unit } set(v) { unit = v } }
}

/// Configuration data for picking consecutive integers
class SettingDataWithNumberPicker: SettingData, SettingDataWithPicker {
	
	var headerText: String = ""
	var value: Int = 0
	var minValue: Int = 0
	var maxValue: Int = 0
	var unit: String = ""
	
	var height: CGFloat { get { return 64.0 } }
	
	var _headerText: String { get { return headerText } set(v) { headerText = v } }
	var _item: String { get { return String(value) } set(v) { value = Int(v)! } }
	var _allItems: [String] {
		get {
			// Create all elements from minimum and maximum
			var allItems: [String] = []
			for value in minValue ... maxValue {
				allItems.append(String(value))
			}
			return allItems
		} set(v) {
			// Find minimum value and maximum value from all elements
			if (v.count < 1) {
				return
			}
			
			var itemValue = Int(v[0])!
			minValue = itemValue
			maxValue = itemValue
			
			for i in 1 ..< v.count {
				itemValue = Int(v[i])!
				minValue = itemValue < minValue ? itemValue : minValue
				maxValue = itemValue > maxValue ? itemValue : maxValue
			}
		}
	}
	var _unit: String { get { return unit } set(v) { unit = v } }
}

/// Configuration data for switch
class SettingDataWithSwitch: SettingData {
	
	var headerText: String = ""
	var isEnabled: Bool = false
	
	var height: CGFloat { get { return 64.0 } }
}

/// Configuration data for channel
class SettingDataWithChannels: SettingData {
	
	var channelDataSet: [String: Bool] = [
		SettingsChannelName.channel5.rawValue:  false,
		SettingsChannelName.channel11.rawValue: false,
		SettingsChannelName.channel17.rawValue: false,
		SettingsChannelName.channel23.rawValue: false,
		SettingsChannelName.channel24.rawValue: false,
		SettingsChannelName.channel25.rawValue: false,
		]
	
	var height: CGFloat { get { return 261.0 } }
	static var itemOnRow: Int {
		return 2
	}
	
	static var rowHeight: Int {
		return 261 / (6 / itemOnRow)
	}
}
