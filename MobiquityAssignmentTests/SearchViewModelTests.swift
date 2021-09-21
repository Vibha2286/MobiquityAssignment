//
//  SearchViewModelTests.swift
//  MobiquityAssignmentTests
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import XCTest
@testable import MobiquityAssignment

class SearchViewModelTests: XCTestCase {

    fileprivate class MockSerachImageServiceCall: SearchFlickrImageBoundary {
        var searchData: FlickrPhoto?
        var searchImage: UIImage?
        
        func fetchPhotosForSearchText(searchText: String, pageCount: Int, success: @escaping FlickrResponse, failure: @escaping ServiceGenericFailure) {
            if let data = searchData {
                success(data)
            } else {
                failure(ErrorResult.custom(string: "Somthing Went wrong"))
            }
        }
        
        func fetchImage(from urlString: String, success: @escaping FlickrImageSuccess, failure: @escaping ServiceGenericFailure) {
            if let image = searchImage {
                success(image)
            } else {
                failure(ErrorResult.custom(string: "No Image found"))
            }
        }
    }
    
    var systemUnderTest: SearchViewModel?
    var dataSource: [FlickrUrls]?
    fileprivate var service: MockSerachImageServiceCall?
    
    override func setUpWithError() throws {
        self.service = MockSerachImageServiceCall()
        self.dataSource = [FlickrUrls]()
        self.systemUnderTest = SearchViewModel(delegate: SearchViewController(), searchImageInteractor: service!)
    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil
        self.dataSource = nil
        self.service = nil
        try super.tearDownWithError()
    }
    
    func testfetchPhotos() {
        service?.searchData = searchResultsModel
        self.systemUnderTest?.fetchImageWithString("Kitten", success: {
            XCTAssert(true, "ViewModel value fetch")
        }, failure: {_ in
            XCTAssert(false, "When there is no data, expect failure.")
        })
      }
    
    func testfetchNoPhotos() {
        service?.searchData = nil
        self.systemUnderTest?.fetchImageWithString("Kitten", success: {
            XCTAssert(false, "ViewModel should not be able to fetch")
        }, failure: {_ in
            XCTAssert(true, "When there is no data, expect failure.")
        })
      }
    
    
    func testfetchImage() {
        let expectation = XCTestExpectation(description: "Image is fetched")
        service?.searchImage = UIImage()
        self.systemUnderTest?.retriveImageFromString(photosModel.imagePath() ?? "", success: { (image) in
            XCTAssert(true, "Image fatch")
            expectation.fulfill()
        }, failure: {_ in
            XCTAssert(false, "When there is no data, expect failure.")
        })
        wait(for: [expectation], timeout: 0.1)
      }
    
    func testfetchNoImage() {
        let expectation = XCTestExpectation(description: "Image fetch fail")
        service?.searchImage = nil
        self.systemUnderTest?.retriveImageFromString(photosModel.imagePath() ?? "", success: { (image) in
            XCTAssert(false, "When there is no data, expect failure.")
        }, failure: {_ in
            XCTAssert(true, "When there is no data, expect failure.")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
      }
}

private let photosModel = FlickrUrls(id: "41886638322",
                                     owner: "151109375",
                                     secret: "9e692e7e1d",
                                     server: "959",
                                     farm: 1,
                                     title: "Kitten",
                                     ispublic: 1,
                                     isfriend: 0,
                                     isfamily: 0)
private let resultsModel = FlickrPageResult(photo: [photosModel],
                                            page: 1,
                                            pages: 4,
                                            perpage: 10,
                                            total: 50)

private let searchResultsModel = FlickrPhoto(photos: resultsModel, stat: "ok")
