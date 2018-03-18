//
//  DivisionTests.swift
//  BigNumTests
//
//  Created by Dave DeLong on 3/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import XCTest
import BigNum

class DivisionTests: XCTestCase {
    
    func testBasicDivision() {
        let a = BigInt(1,000,000)
        let b = BigInt(3)
        XCTAssertEqual(a/b, 333_333)
    }
    
    func testHugeDivision() {
        let a = BigInt(123,456,789,012,345,678,901,234,567,890)
        let b = BigInt(  2,765,432,109,876,543,210,987,654,321)
        XCTAssertEqual(a / b, 44)
    }

}
