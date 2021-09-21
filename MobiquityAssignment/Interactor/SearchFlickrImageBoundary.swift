//
//  SearchFlickrImageBoundary.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation
import UIKit

typealias FlickrResponse = (_ photo: FlickrPhoto) -> Void
typealias FlickrImageSuccess = (_ image: UIImage) -> Void
typealias ServiceGenericFailure = (Error) -> Void

protocol SearchFlickrImageBoundary {
    func fetchPhotosForSearchText(searchText: String,
                                  pageCount: Int,
                                  success: @escaping FlickrResponse,
                                  failure: @escaping ServiceGenericFailure)
    func fetchImage(from urlString: String,
                    success: @escaping FlickrImageSuccess,
                    failure: @escaping ServiceGenericFailure)
}
