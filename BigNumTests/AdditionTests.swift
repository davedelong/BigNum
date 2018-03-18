//
//  AdditionTests.swift
//  BigNumTests
//
//  Created by Dave DeLong on 3/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import XCTest
@testable import BigNum

class AdditionTests: XCTestCase {
    
    func testAddingSmallPositiveAndSmallPositive() {
        let a = BigInt(  10,000,000,000)
        let b = BigInt(  10,000,000,000)
        let s = BigInt(  20,000,000,000)
        XCTAssertEqual(a + b, s)
    }
    
    func testAddingSmallPositiveAndBigPositive() {
        let a = BigInt(   10,000,000,000)
        let b = BigInt(  990,000,000,000)
        let s = BigInt(1,000,000,000,000)
        XCTAssertEqual(a + b, s)
    }
    
    func testAddingBigPositiveAndSmallPositive() {
        let a = BigInt(  990,000,000,000)
        let b = BigInt(   10,000,000,000)
        let s = BigInt(1,000,000,000,000)
        XCTAssertEqual(a + b, s)
    }
    
    func testAddingBigPositiveAndBigPositive() {
        let a = BigInt(  990,000,000,000)
        let b = BigInt(  990,000,000,000)
        let s = BigInt(1,980,000,000,000)
        XCTAssertEqual(a + b, s)
    }
    
    func testAddingSmallPositiveAndSmallNegative() {
        let a = BigInt(  10,000,000,000)
        let b = BigInt( -10,000,000,000)
        XCTAssertEqual(a + b, 0)
        
        let c = BigInt(  10,000,000,000)
        let d = BigInt( -10,000,000,001)
        XCTAssertEqual(c + d, -1)
    }
    
    func testAddingSmallPositiveAndBigNegative() {
        let a = BigInt(   10,000,000,000)
        let b = BigInt( -990,000,000,000)
        let r = BigInt( -980,000,000,000)
        XCTAssertEqual(a + b, r)
    }
    
    func testAddingBigPositiveAndSmallNegative() {
        let a = BigInt(  990,000,000,000)
        let b = BigInt(  -10,000,000,000)
        let r = BigInt(  980,000,000,000)
        XCTAssertEqual(a + b, r)
    }
    
    func testAddingBigPositiveAndBigNegative() {
        let a = BigInt(  990,000,000,001)
        let b = BigInt( -990,000,000,000)
        XCTAssertEqual(a + b, 1)
        
        let c = BigInt(  990,000,000,000)
        let d = BigInt( -990,000,000,001)
        XCTAssertEqual(c + d, -1)
    }
    
    func testAddingHugePositives() {
        let a = BigInt(123,456,789,012,345,678,901,234,567,890)
        let b = BigInt( 98,765,432,109,876,543,210,987,654,321)
        let s = BigInt(222,222,221,122,222,222,112,222,222,211)
        XCTAssertEqual(a + b, s)
    }
    
}
