//
//  HistoryViewModel.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import Foundation

struct HistoryViewModel {
    
    var historyData: [String] {
        get {
            return  LocalStorageUtils.historyList
        }
        set {
            LocalStorageUtils.historyList = newValue
        }
    }
    
    mutating func removeHistoryAtIndex(index: Int) {
        LocalStorageUtils.historyList.remove(at: index)
    }
}

