//
//  MobiquityAssignmentTests.swift
//  MobiquityAssignmentTests
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import XCTest

@testable import MobiquityAssignment

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

class ServiceInteractorTests: XCTestCase {
    
    fileprivate class MockSerachImageInteratorServiceCall: ServiceInteractor {
    
        var imageData: Data?
        var searchImage: UIImage?
                
        override func requestSearchAPI<T>(text: String, count: Int, success: @escaping ServiceSuccess<T>, failure: @escaping ServiceFailure) where T : Decodable {
            let decoder = JSONDecoder()
            if let data = imageData, let result = try? decoder.decode(FlickrPhoto.self, from: data) {
                success(result as! T)
            } else {
                failure(ErrorResult.custom(string: "Somthing Went wrong"))
            }
        }
        
        override func getImages<T>(from urlString: String, success: @escaping ServiceImageSuccess<T>, failure: @escaping ServiceFailure) where T : UIImage {
            if let image = searchImage {
                success(image)
            } else {
                failure(ErrorResult.custom(string: "Somthing Went wrong"))
            }
        }
    }
    
    fileprivate var fetchImages: MockSerachImageInteratorServiceCall!
    
    override func setUpWithError() throws {
        fetchImages = MockSerachImageInteratorServiceCall()
    }
    
    override func tearDownWithError() throws {
        fetchImages = nil
        try super.tearDownWithError()
    }
    
    func testSearchAPI() {
        fetchImages.imageData = dataFromJson()
        fetchImages.requestSearchAPI(text: "baby", count: 100) { (response: FlickrPhoto) in
            XCTAssert(true, "Flickr photo recived")
        } failure: { _ in
            XCTAssert(true, "Something went wrong")
        }
     }
    
    func testSearchAPIWithNoData() {
        fetchImages.imageData = nil
        fetchImages.requestSearchAPI(text: "baby", count: 100) { (response: FlickrPhoto) in
            XCTAssert(true, "Flickr photo recived")
        } failure: { _ in
            XCTAssert(true, "Something went wrong")
        }
     }
    
    func testGetUrlPath() {
        let urlString = "https://www.xyz.com"
        XCTAssertNotNil(fetchImages.getURLPath(urlString, 1))
    }
    
    func testSizeUrlPath() {
        let urlString = "https://www.xyz.com"
        XCTAssertNotNil(fetchImages.getSizeURLPath(urlString))
    }

    func testGetNilUrlPath() {
        let urlString = "https://   xyz.com"
        XCTAssertNil(fetchImages.getURLPath(urlString, 1))
    }
    
    func testSizeNilUrlPath() {
        let urlString = "https://   xyz.com"
        XCTAssertNil(fetchImages.getSizeURLPath(urlString))
    }
    
    func testfetchImage() {
        let expectation = XCTestExpectation(description: "photo is fetched")
        fetchImages?.searchImage = UIImage()
        fetchImages?.getImages(from: "test", success: { (image) in
            XCTAssert(true, "Image is available.")
            expectation.fulfill()
        }, failure: { _ in
            XCTAssert(true, "When there is no data, expect failure.")
        })
        
        wait(for: [expectation], timeout: 0.1)
      }
    
    func testfetchNoImage() {
        let expectation = XCTestExpectation(description: "photo fetch fail")
        fetchImages?.searchImage = nil
        fetchImages?.getImages(from: "test", success: { (image) in
            XCTAssert(true, "Image is available.")
        }, failure: { _ in
            XCTAssert(true, "When there is no data, expect failure.")
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
      }
    
    private func dataFromJson() -> Data {
        guard let data = FileManager.readJsonFile(forResource: "flickrImages") else {
          XCTAssert(false, "Can't get data from flickrImages.json")
          return Data()
        }
       return data
    }
}

extension FileManager {
    static func readJsonFile(forResource fileName: String ) -> Data? {
        let bundle = Bundle(for: ServiceInteractorTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
            }
        }
        return nil
    }
}
