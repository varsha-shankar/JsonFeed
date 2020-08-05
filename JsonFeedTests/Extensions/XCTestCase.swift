//
//  XCTestCase.swift
//  JsonFeedTests
//
//  Created by Shankar, Varsha on 8/5/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import XCTest

extension XCTestCase {

    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: `extension`)
        return try! Data(contentsOf: url!)
    }
}
