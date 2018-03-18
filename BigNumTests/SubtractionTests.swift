//
//  SubtractionTests.swift
//  BigNumTests
//
//  Created by Dave DeLong on 3/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import XCTest
import BigNum

class SubtractionTests: XCTestCase {
    
    func testSubtractingResultingInAPositiveNumber() {
        let a = BigInt( 9,876,543,210)
        let b = BigInt( 1,234,567,890)
        let d = BigInt( 8,641,975,320)
        XCTAssertEqual(a-b, d)
    }
    
    func testSubtractingResultingInANegativeNumber() {
        let a = BigInt( 1,234,567,890)
        let b = BigInt( 9,876,543,210)
        let d = BigInt(-8,641,975,320)
        XCTAssertEqual(a-b, d)
    }
    
}
