//
//  JsonFeedTests.swift
//  JsonFeedTests
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//
import UIKit
import XCTest
@testable import JsonFeed

class JsonFeedTests: XCTestCase {

    var viewControllerUnderTest: FactsViewController!
    var window: UIWindow!

    var viewModel: FactsViewModel!
    var apiService: NetworkWorker!
    var objFacts: Facts!
    var apiResponse: Facts!
    var imageView: CustomImageView!

    let cancelTimeOutInterval = 10.0

    override func setUpWithError() throws {
        self.viewModel = FactsViewModel()
        self.apiService = NetworkWorker()
        self.imageView = CustomImageView()
        self.window = UIWindow()
        self.viewControllerUnderTest = FactsViewController()
        self.viewControllerUnderTest.viewDidLoad()


        super.setUp()

        let data = loadStub(name: "facts", extension: "json")
        guard let dataInString = String(data:data,encoding: String.Encoding.isoLatin1) else { return }
        guard let properData = dataInString.data(using: .utf8, allowLossyConversion: true) else { return }
        let decoder = JSONDecoder()
        objFacts = try decoder.decode(Facts.self, from: properData)

    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.apiService = nil
        self.imageView = nil
        self.viewControllerUnderTest = nil
        self.window = nil
        super.tearDown()
    }


    func testTitleWithoutAPICall() {
        XCTAssertTrue(viewModel.getTitle() == "")
    }

    func testFactsViwModel() {
        if let data = objFacts.rows {
            XCTAssertTrue(data.count > 0)
        }
    }

    func testTitle() {
        let data = objFacts.title
        if !data.isEmpty {
            XCTAssertEqual(data, "About Canada")
        }
    }

    func testServiceAPI() {
        let expectation = XCTestExpectation(description: "Test Json Feed Service API")
        DispatchQueue.global(qos: .background).async {
            self.viewModel.fetchFactsRows(completion: { _ in 
                self.apiService.getFactsJsonFeed(urlString: url) { (result) in
                    switch result {
                    case .success(let items):
                        self.apiResponse = items
                        expectation.fulfill()
                        break

                    case .failure(_):
                        self.apiResponse = nil
                        expectation.fulfill()
                        break
                    }
                }
            })
        }
        self.wait(for: [expectation], timeout: cancelTimeOutInterval)
        XCTAssertNotNil(self.apiResponse)
    }

    func testImageDownloadAWithoutURL() {
         let expectation = XCTestExpectation(description: "Load Image API")
        if let imageUrl = (self.objFacts.rows?[4].imageHref) {
            DispatchQueue.global(qos: .background).async {
                self.imageView.loadImageFrom(urlString: imageUrl, completionHandler: { image in
                    self.imageView.image = image
                    XCTAssertNil(self.imageView.image)
                    expectation.fulfill()
                })
            }
            self.wait(for: [expectation], timeout: cancelTimeOutInterval)
        }  else {
            XCTAssertEqual(self.imageView.image, nil)
        }
    }

    func testImageDownloadAWithURL() {
          let expectation = XCTestExpectation(description: "Load Image API")
         if let imageUrl = (self.objFacts.rows?[1].imageHref) {
             DispatchQueue.global(qos: .background).async {
                 self.imageView.loadImageFrom(urlString: imageUrl, completionHandler: { image in
                    self.imageView.image = image
                     XCTAssertNotNil(self.imageView.image)
                     expectation.fulfill()
                 })
             }
             self.wait(for: [expectation], timeout: cancelTimeOutInterval)
         }  else {
             XCTAssertEqual(self.imageView.image, nil)
         }
     }

    func testTableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }


    func testTableViewHasDeleegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)

    }

    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)

    }

    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
    }
    

    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }

    func testRefreshControl() {
         XCTAssertNotNil(viewControllerUnderTest.refreshControl)
    }

    func testActivityIndicator() {
         XCTAssertNotNil(viewControllerUnderTest.activityIndicator)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
