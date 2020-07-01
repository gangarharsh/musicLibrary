//
//  MusicLibraryTests.swift
//  MusicLibraryTests
//
//  Created by Harsh Gangar on 29/06/20.
//

import XCTest
@testable import MusicLibrary

class MusicLibraryTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testFetchMusic(){
        let expectation = XCTestExpectation(description: "Download failed")
        APIHelper.shared.fetchMusic(from: "Adele") { (result: Result<MusicLibraryObject, APIHelper.APIServiceError>) in
            switch result{
            case .success(let data):
                if data.results.count > 1{
                    expectation.fulfill()
                }else{
                    XCTFail()
                }
                                
            case .failure(let error):
                print(error.description)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
        
    }
}
