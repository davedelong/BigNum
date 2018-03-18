//
//  BigInt+Initializers.swift
//  BigNum
//
//  Created by Dave DeLong on 3/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension BigInt {
    
    public init<I: BinaryInteger>(exactly value: I) {
        let absoluteValue = value.magnitude
        let isNegative = (absoluteValue != value)
        self.init(Digit.from(absoluteValue), isNegative: isNegative)
    }
    
    public init(_ base: Int16, _ others: UInt16...) {
        let isNegative = (base < 0)
        let passedInDigits = [base.magnitude] + others
        self.init(Digit.from(commaDelimitedNumbers: passedInDigits), isNegative: isNegative)
    }
    
    public init(powerOf10: Int, isNegative: Bool = false) {
        let digits = Digits(repeating: .zero, count: powerOf10) + [.one]
        self.init(digits, isNegative: isNegative)
    }
    
}
