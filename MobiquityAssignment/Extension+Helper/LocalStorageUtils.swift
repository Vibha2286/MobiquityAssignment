//
//  LocalStorageUtils.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import Foundation

/// save and retrive data to show history
class LocalStorageUtils {
    static let historyObjectKey = "HistoryData"
    static var historyList: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: historyObjectKey) ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: historyObjectKey)
        }
    }
}
