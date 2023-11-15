//
//  Ex+Array.swift
//  ijara
//
//  Created by Sarvar Qosimov on 14/11/23.
//

import Foundation

extension Array {
    func isContainsSelectedParamentr(_ arr: [Int]) -> Bool {
        for i in self as! [Int] {
            if !arr.contains(i) {
                return false
            }
        }
        return true
    }
}
