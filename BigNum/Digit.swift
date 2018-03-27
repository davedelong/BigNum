//
//  Digit.swift
//  BigNum
//
//  Created by Dave DeLong on 3/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation


internal func < (leftDigits: Digits, rightDigits: Digits) -> Bool {
    
    if leftDigits.count < rightDigits.count { return true }
    if leftDigits.count > rightDigits.count { return false }
    
    // we know the numbers have the same number of digits
    for (lDigit, rDigit) in (zip(leftDigits.reversed(), rightDigits.reversed())) {
        if lDigit < rDigit { return true }
        if lDigit > rDigit { return false }
    }
    
    // if we get to the end, we know they're entirely equal
    return false
}

internal typealias Digits = Array<Digit>

internal enum Digit: Int, Comparable {
    
    static let evenDigits: Array<Digit> = [.zero, .two, .four, .six, .eight]
    static let oddDigits: Array<Digit> = [.one, .three, .five, .seven, .nine]
    
    case zero = 0, one, two, three, four, five
    case six, seven, eight, nine, ten
    
    static func < (lhs: Digit, rhs: Digit) -> Bool { return lhs.rawValue < rhs.rawValue }
    
    static func from<B: BinaryInteger>(_ positiveInteger: B) -> Digits {
        var value = positiveInteger
        var digits = Digits()
        
        while value > 0 {
            let digit = Digit(rawValue: Int(value % 10)) ?? .zero
            value = value / 10
            digits.append(digit)
        }
        return digits
    }
    
    static func from(commaDelimitedNumbers: Array<UInt16>) -> Digits {
        
        let digits = commaDelimitedNumbers.flatMap { triple -> Digits in
            guard triple < 1000 else { fatalError("Comma-delimited numbers must have 3 or fewer digits") }
            // we can't check for the number of digits
            // because 1,000,012 will come in as [1,0,12]
            
            // some of this is redundant, but it's there for consistency and readability
            return [
                Digit(rawValue: Int(triple % 1000) / 100) ?? .zero,
                Digit(rawValue: Int(triple %  100) /  10) ?? .zero,
                Digit(rawValue: Int(triple %   10) /   1) ?? .zero
            ]
        }
        return Array(digits.reversed())
    }
    
    static func sum(_ terms: Array<Digits>) -> Digits {
        let maxTermLength = terms.map { $0.count }.max() ?? 0
        let paddedTerms = terms.map { $0 + Array(repeating: .zero, count: maxTermLength - $0.count) }
        
        var carry = 0
        var digits = Digits()
        
        for digitIndex in 0 ..< maxTermLength {
            let sum = paddedTerms.reduce(0) { $0 + $1[digitIndex].rawValue } + carry
            let digit = Digit(rawValue: sum % 10) ?? .zero
            carry = sum / 10
            digits.append(digit)
        }
        
        while carry > 0 {
            let digit = Digit(rawValue: carry % 10) ?? .zero
            digits.append(digit)
            carry /= 10
        }
        
        return digits
    }
    
    static func add(lhs: Digits, rhs: Digits) -> Digits {
        return sum([lhs, rhs])
    }
    
    // the contract for this is that LHS will always be numerically larger than RHS
    static func subtract(lhs: Digits, rhs: Digits) -> Digits {
        assert(lhs.count >= rhs.count)
        
        let paddedLeft = lhs
        let paddedRight = rhs + Array(repeating: .zero, count: lhs.count - rhs.count)
        
        var digits = Digits()
        var borrow = 0
        
        for (left, right) in zip(paddedLeft, paddedRight) {
            var diff = left.rawValue - right.rawValue - borrow
            borrow = 0
            while diff < 0 {
                diff += 10
                borrow += 1
            }
            
            let digit = Digit(rawValue: diff % 10) ?? .zero
            digits.append(digit)
        }
        
        assert(borrow == 0)
        
        while digits.last == .zero { _ = digits.popLast() }
        return digits
    }
    
    private static func intermediateMultiplicationSums(lhs: Digits, rhs: Digits) -> Array<Digits> {
        var terms = Array<Digits>()
        for (powerOf10, digit) in rhs.enumerated() {
            let multiplication = Array(repeating: .zero, count: powerOf10) + multiply(digits: lhs, by: digit)
            terms.append(multiplication)
        }
        return terms
    }
    
    static func multiply(lhs: Digits, rhs: Digits) -> Digits {
        let terms = intermediateMultiplicationSums(lhs: lhs, rhs: rhs)
        return sum(terms)
    }
    
    static func multiply(digits: Digits, by: Digit) -> Digits {
        var result = Digits()
        var carry = 0
        for digit in digits {
            let multiplication = (digit.rawValue * by.rawValue) + carry
            let nextDigit = Digit(rawValue: multiplication % 10) ?? .zero
            result.append(nextDigit)
            
            carry = multiplication / 10
        }
        
        while carry > 0 {
            let digit = Digit(rawValue: carry % 10) ?? .zero
            result.append(digit)
            carry /= 10
        }
        
        return result
    }
    
    static func divide(digits: Digits, by: Digits) -> (Digit, Digits) {
        guard by.count <= digits.count else { return (.zero, digits) }
        guard by < digits else { return (.zero, digits) }
        // naïve implementation
        var multiple = 0
        var remaining = digits
        while by < remaining {
            remaining = subtract(lhs: remaining, rhs: by)
            multiple += 1
        }
        return (Digit(rawValue: multiple) ?? .zero, remaining)
    }
    
    static func power(base: Digits, exponent: Digits) -> Digits {
        if exponent.isEmpty || exponent == [.zero] { return [.one] }
        if exponent == [.one] { return base; }
        
        var result = base
        var repetitions = Digit.subtract(lhs: exponent, rhs: [.one])
        while repetitions.isEmpty == false {
            result = Digit.multiply(lhs: result, rhs: base)
            repetitions = Digit.subtract(lhs: repetitions, rhs: [.one])
        }
        return result
    }
}
