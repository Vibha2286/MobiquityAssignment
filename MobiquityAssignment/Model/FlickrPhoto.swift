//
//  FlickrPhoto.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation

struct FlickrPhoto: Codable {
    let photos: FlickrPageResult?
    let stat: String
}

struct FlickrPageResult: Codable {
    let photo: [FlickrUrls]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
}

struct FlickrUrls: Codable {
    let id, owner, secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    func imagePath() -> String? {
        return String(format: Constants.imageURL,
                             farm,
                             server,
                             id,
                             secret)
    }
}
