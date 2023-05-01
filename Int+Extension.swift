//
//  Int+Extension.swift
//  Concentration
//
//  Created by adam west on 01.05.23.
//

import Foundation

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
           return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
