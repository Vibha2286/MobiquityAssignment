//
//  SearchFlickrImageInteractor.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation

final class SearchFlickrImageInteractor: Intractable, SearchFlickrImageBoundary {
    
    var apiInteractor: ServiceInteractor?
 
    /// fetch photos json from flickr service by passing text and count
    func fetchPhotosForSearchText(searchText: String,
                                  pageCount: Int,
                                  success: @escaping FlickrResponse,
                                  failure: @escaping ServiceGenericFailure){
        apiInteractor.requestSearchAPI(text: searchText,
                                       count: pageCount,
                                       success: { (response: FlickrPhoto) in
            success(response)
        }, failure: { (error) in
            failure(error)
        })
    }
    
    /// fetch images from flickr service by passing url 
    func fetchImage(from urlString: String,
                    success: @escaping FlickrImageSuccess,
                    failure: @escaping ServiceGenericFailure) {
        apiInteractor.getImages(from: urlString, success: { (image) in
            success(image)
        }, failure: { (error) in
            failure(error)
        })
    }
}
