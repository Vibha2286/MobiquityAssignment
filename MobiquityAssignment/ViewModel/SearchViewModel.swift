//
//  SearchViewModel.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import Foundation
import UIKit

protocol SearchViewModelDelegate: NSObject {
    func reloadWithHistoryTag(_ title: String)
    func showErrorMessage(_ errorMessage: String?)
}

final class SearchViewModel {
    
    private weak var delegate: SearchViewModelDelegate?
    private(set) var searchImageInteractor: SearchFlickrImageBoundary
    var pageCount = 0
    var tag = "kitten"
    var imageData = [FlickrUrls]()
    var history = [String]()
    
    init(delegate: SearchViewModelDelegate,
         searchImageInteractor: SearchFlickrImageBoundary) {
        self.delegate = delegate
        self.searchImageInteractor = searchImageInteractor
    }
    
    func fetchImageWithString(_ string: String,
                              success: @escaping EmptySuccess,
                              failure: @escaping ServiceFailure) {
        updateHistory(text: tag)
        searchImageInteractor.fetchPhotosForSearchText(searchText: string.removeSpaceFromString, pageCount: pageCount) { [weak self] (result) in
            self?.imageData.append(contentsOf: result.photos?.photo ?? [])
            success()
        } failure: { [weak self] (error) in
            self?.delegate?.showErrorMessage(error.localizedDescription)
            failure(error)
        }
    }
    
    func retriveImageFromString(_ urlString: String,
                                success: @escaping ImageSuccess,
                                failure: @escaping ServiceFailure) {
        searchImageInteractor.fetchImage(from: urlString) { (image) in
            success(image)
        } failure: { (error) in
            failure(error)
        }
    }
    
    private func updateHistory(text: String) {
        if history.contains(text), let index = history.firstIndex(of: text) {
            history.remove(at: index)
        }
        
        history.insert(text, at: 0)
        LocalStorageUtils.historyList = history
    }
}

extension SearchViewModel {    
    var resetImagesData : Void {
        imageData.removeAll()
        tag = ""
        pageCount = 0
    }
}
