//
//  BigInt+Comparable.swift
//  BigNum
//
//  Created by Dave DeLong on 3/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension BigInt: Comparable {
    
    public static func ==(lhs: BigInt, rhs: BigInt) -> Bool {
        guard lhs.isNegative == rhs.isNegative else { return false }
        guard lhs.digits.count == rhs.digits.count else { return false }
        return lhs.digits == rhs.digits
    }
    
    public static func <(lhs: BigInt, rhs: BigInt) -> Bool {
        if lhs.isNegative == true && rhs.isNegative == false { return true }
        if lhs.isNegative == false && rhs.isNegative == true { return false }
        
        var leftDigits = lhs.digits
        var rightDigits = rhs.digits
        if lhs.isNegative == true && rhs.isNegative == true { swap(&leftDigits, &rightDigits) }
        
        return leftDigits < rightDigits
    }
    
}
