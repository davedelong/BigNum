//
//  BigInt.swift
//  BigNum
//
//  Created by Dave DeLong on 3/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct BigInt: CustomStringConvertible {
    
    public static let zero = BigInt([.zero], isNegative: false)
    public static let one = BigInt([.one], isNegative: false)
    
    internal let isNegative: Bool
    internal var isPositive: Bool { return !isNegative }
    internal let digits: Digits
    
    internal init(_ digits: Digits, isNegative: Bool) {
        var cleaned = digits
        while cleaned.last == .zero { _ = cleaned.popLast() }
        self.digits = cleaned
        self.isNegative = isNegative
    }
    
    public var description: String {
        let sign = isNegative ? "-" : ""
        
        let visibleDigitis = digits.isEmpty ? [.zero] : digits
        return sign + visibleDigitis.reversed().map { "\($0.rawValue)" }.joined()
    }
    
    public var isEven: Bool {
        return digits.isEmpty || Digit.evenDigits.contains(digits[0])
    }
    
    public var isOdd: Bool { return !isEven }
    
    public func negated() -> BigInt {
        return BigInt(digits, isNegative: !isNegative)
    }
}
