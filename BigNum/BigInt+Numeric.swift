//
//  BigInt+Numeric.swift
//  BigNum
//
//  Created by Dave DeLong on 3/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension BigInt: Numeric {
    
    public typealias Magnitude = BigInt
    public typealias IntegerLiteralType = Int64
    
    public var magnitude: BigInt {
        if self.isNegative == false { return self }
        return self.negated()
    }
    
    public init(integerLiteral value: Int64) {
        self.init(exactly: value)
    }
    
    public static func += (lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs + rhs
    }
    public static func -= (lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs - rhs
    }
    
    public static func *= (lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs * rhs
    }
    
    public static func /= (lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs / rhs
    }
    
    public static func + (lhs: BigInt, rhs: BigInt) -> BigInt {
        let leftMagnitude = lhs.magnitude
        let rightMagnitude = rhs.magnitude
        
        // (-a + a) == 0
        if lhs.isNegative != rhs.isNegative && leftMagnitude == rightMagnitude { return .zero }
        
        let resultIsNegative: Bool
        // find out if the result of the addition will be positive or negative
        // operations that would be negative will be flipped around and recursed
        let digits: Digits
        
        switch (lhs.isPositive, rhs.isPositive) {
            case (true, true):
                // add two positive numbers
                // A + B
                resultIsNegative = false
                digits = Digit.add(lhs: lhs.digits, rhs: rhs.digits)
            
            case (false, true):
                if leftMagnitude < rightMagnitude {
                    // add a small negative number to a big positive number
                    // -a + B => B - a
                    resultIsNegative = false
                    digits = Digit.subtract(lhs: rhs.digits, rhs: lhs.digits)
                    
                } else {
                    // add a big negative number to a small positive number
                    // a + -B => -(B - a)
                    resultIsNegative = true
                    digits = Digit.subtract(lhs: rhs.digits, rhs: lhs.digits)
                }
            
            case (true, false):
                if leftMagnitude > rightMagnitude {
                    // add a small negative number to a big positive number
                    // A - b => A - b
                    resultIsNegative = false
                    digits = Digit.subtract(lhs: lhs.digits, rhs: rhs.digits)
                    
                } else {
                    // add a big negative number to a small positive number
                    // a - B => -(B - a)
                    resultIsNegative = true
                    digits = Digit.subtract(lhs: rhs.digits, rhs: lhs.digits)
                }
            
            case (false, false):
                // add two negative numbers
                // -a + -b => -(a + b)
                resultIsNegative = true
                digits = Digit.add(lhs: lhs.digits, rhs: rhs.digits)
        }
        return BigInt(digits, isNegative: resultIsNegative)
    }
    
    public static func - (lhs: BigInt, rhs: BigInt) -> BigInt {
        // lhs - rhs => lhs + -rhs
        return lhs + rhs.negated()
    }
    
    public static func * (lhs: BigInt, rhs: BigInt) -> BigInt {
        if lhs == .zero || rhs == .zero { return .zero }
        if lhs == .one { return rhs }
        if rhs == .one { return lhs }
        
        let isNegative = (lhs.isNegative != rhs.isNegative)
        let digits = Digit.multiply(lhs: lhs.digits, rhs: rhs.digits)
        return BigInt(digits, isNegative: isNegative)
    }
    
    public static func / (lhs: BigInt, rhs: BigInt) -> BigInt {
        if rhs == .zero { fatalError("division by zero is invalid") }
        if lhs == .zero { return .zero }
        if lhs == rhs { return .one }
        if rhs == .one { return lhs }
        if rhs > lhs { return .zero }
        
        var quotient = Digits()
        var remainder = Digits()
        for leftDigit in lhs.digits.reversed() {
            remainder.insert(leftDigit, at: 0)
            
            let (digit, r) = Digit.divide(digits: remainder, by: rhs.digits)
            quotient.append(digit)
            
            remainder = r
        }
        
        let isNegative = lhs.isNegative != rhs.isNegative
        return BigInt(Array(quotient.reversed()), isNegative: isNegative)
    }
    
}
