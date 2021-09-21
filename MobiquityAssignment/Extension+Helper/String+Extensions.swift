//
//  String+Extensions.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import Foundation

extension String {
    
    /// Remove spaces from string
    var removeSpaceFromString: String {
        return self.components(separatedBy: .whitespaces).joined()
    }
    
    /// localized string to support differnt languages
    func localized() -> String {
        return localized(withComment: "")
    }
    
    func localized(withComment: String) -> String {
        var localized = Bundle.main.localizedString(forKey: self, value: withComment, table: "Default")
        if localized == self {
            localized = Bundle.main.localizedString(forKey: self, value: withComment, table: nil)
        }
        return localized
    }
}
