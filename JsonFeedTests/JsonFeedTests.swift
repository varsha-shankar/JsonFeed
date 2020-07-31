//
//  JsonFeedTests.swift
//  JsonFeedTests
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import XCTest
@testable import JsonFeed

class JsonFeedTests: XCTestCase {

    var viewModel: FactsViewModel!
    var apiService: NetworkWorker!
    var objFacts: Facts!
    var imageView: CustomImageView!

    override func setUp() {
        self.viewModel = FactsViewModel()
        self.apiService = NetworkWorker()
        self.imageView = CustomImageView()
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
         // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
        self.apiService = nil
        self.imageView = nil
        super.tearDown()

    }

    func testTitleWithoutAPICall() {
        XCTAssertTrue(viewModel.getTitle() == "")
    }

    func testFactsViwModel() {
        callAPI()
        XCTAssertTrue(self.objFacts.rows!.count > 0)

    }

    func testTitle() {
        callAPI()
        XCTAssertTrue(self.objFacts.title == "About Canada")
    }

    func callAPI() {
        self.viewModel.fetchFactsRows(completion: {
            self.apiService.getFactsJsonFeed { (result) in
                switch result {
                case .success(let items):
                    self.objFacts = items
                    break

                case .failure(_):
                    break
                }
            }
        })
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

}
