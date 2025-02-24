//
//  SettingsChannelName.swift
//  DensoScannerSDK_Demo
//
//  Created by SP1 on 2018/06/14.
//  Copyright © 2018年 SP1. All rights reserved.
//

import Foundation

enum ComRegion: Int {
	case none 		= 0
	case regionIN 	= 3
	case regionEU 	= 4
	case regionIL 	= 5
	case regionJP 	= 6
	
	init(region: String?) {
		switch region {
		case "IN":
			self = .regionIN
		case "EU":
			self = .regionEU
		case "IL":
			self = .regionIL
		case "JP":
			self = .regionJP
		default:
			self = .none
		}
	}
	
	func level() -> Int {
		return rawValue
	}
}

/// Channel name
enum SettingsChannelName: String, Codable {
    case channel5 = "ch5"
    case channel11 = "ch11"
    case channel17 = "ch17"
    case channel23 = "ch23"
    case channel24 = "ch24"
    case channel25 = "ch25"
	
	func chanelDesc(region: ComRegion? = nil) -> String {
		let region = region ?? .none
		switch region {
		case .regionEU:
			return chanelEUDesc()
		case .regionIN, .regionIL:
			return chanelILINDesc()
		default:
			return chanelDefaultDesc()
		}
	}
	
	private func chanelDefaultDesc() -> String {
		switch self {
		case .channel5:
			return "Setting_Channel_5"
		case .channel11:
			return "Setting_Channel_11"
		case .channel17:
			return "Setting_Channel_17"
		case .channel23:
			return "Setting_Channel_23"
		case .channel24:
			return "Setting_Channel_24"
		case .channel25:
			return "Setting_Channel_25"
		}
	}
	
	private func chanelEUDesc() -> String {
		switch self {
		case .channel5:
			return "Setting_Channel_5EU"
		case .channel11:
			return "Setting_Channel_11EU"
		case .channel17:
			return "Setting_Channel_17EU"
		case .channel23:
			return "Setting_Channel_23EU"
		case .channel24:
			return "Setting_Channel_24"
		case .channel25:
			return "Setting_Channel_25"
		}
	}
	
	private func chanelILINDesc() -> String {
		switch self {
		case .channel5:
			return "Setting_Channel_5I"
		case .channel11:
			return "Setting_Channel_11I"
		case .channel17:
			return "Setting_Channel_17I"
		case .channel23:
			return "Setting_Channel_23I"
		case .channel24:
			return "Setting_Channel_24I"
		case .channel25:
			return "Setting_Channel_25"
		}
	}
    
    /// An array of all the elements arranged in the expected display order
    public static let values: [SettingsChannelName] = [channel5, channel11, channel17, channel23, channel24, channel25]
}
