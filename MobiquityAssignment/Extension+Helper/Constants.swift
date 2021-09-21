//
//  Constants.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation
import UIKit

class Constants {
    static let reuseIdentifier = "FlickrImageCell"
    static let historyReuseIdentifier = "HistoryCell"
    static let reuseIdentifierSearch = "SearchBar"
    static let flickrKey = "7f9488614d9454af5e5d47d9fbade374"
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@.jpg"
    static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&tags=%@&page=%d&format=json&nojsoncallback=1"
    static let reloadCount = 10
}
