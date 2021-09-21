//
//  ServiceInteractor.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation
import UIKit

public typealias ServiceSuccess<T: Decodable> = (_ response: T) -> Void
public typealias ServiceImageSuccess<image: UIImage> = (_ image: UIImage) -> Void
public typealias EmptySuccess = () -> Void
public typealias ImageSuccess = (_ image: UIImage) -> Void
public typealias ServiceFailure = (_ error: Error) -> Void

protocol Intractable {
    var apiInteractor: ServiceInteractor? { get }
}

extension Intractable {
    var apiInteractor: ServiceInteractor {
        return ServiceInteractor()
    }
}

class ServiceInteractor {
    
    let jsonDecoder = JSONDecoder()
    var cache = NSCache<NSURL, UIImage>()
    
    // Mark:- Get images from flickr
    
    func requestSearchAPI<T: Any>(text: String,
                                  count: Int,
                                  success: @escaping ServiceSuccess<T>,
                                  failure: @escaping ServiceFailure) {
        guard let urlPath = getURLPath(text, count) else { return }
        let dataTask = URLSession.shared.dataTask(with: urlPath) { (data, response, error) in
            if let data = data {
                do {
                    let photosInfo = try self.jsonDecoder.decode(FlickrPhoto.self, from: data) as! T
                    success(photosInfo)
                } catch {
                    failure(error)
                }
            } else if let error = error {
                failure(error)
            }
        }
        dataTask.resume()
    }
    
    // Mark:- Returns cached image or loads and cache it
    
    func getImages<T: Any>(from urlString: String,
                           success: @escaping ServiceImageSuccess<T>,
                           failure: @escaping ServiceFailure) {
        
        guard let url = getSizeURLPath(urlString) else { return }
        
        DispatchQueue.global(qos: .background).async(execute: { () -> Void in
            if let image = self.cache.object(forKey: url as NSURL) {
                DispatchQueue.main.async {
                    success(image)
                }
                return
            }

            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: url as NSURL)
                        success(image)
                    }
                }
            } catch {
                failure(error)
            }
        })
    }
}

// Mark:- URL for images

extension ServiceInteractor {
    
    func getURLPath(_ tags: String, _ pageCount: Int) -> URL? {
        guard let url = URL(string: String(format: Constants.baseURL, tags, pageCount)) else {
            return nil
        }
        return url
    }
    
    func getSizeURLPath(_ urlString: String) -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
