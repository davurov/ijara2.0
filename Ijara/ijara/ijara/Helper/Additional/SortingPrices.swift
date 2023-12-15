//
//  SortingPrices.swift
//  ijara
//
//  Created by Sarvar Qosimov on 04/12/23.
//

import Foundation

class SortingPrices {
    ///collection: [(value: Int, id: Int)]
    class func sortByExpensive(_ collection: [(Int, Int)]) -> [Int] {
        var sortedCollection: [Int] = []
        var collectionCopy = collection
        
        for _ in 1...collection.count {
            let maxInCollection = findMaxVlue(collectionCopy)
        
            sortedCollection.append(maxInCollection.maxValue.1)
            collectionCopy.remove(at: maxInCollection.indexOfMaxValue)
        }
        
        return sortedCollection
    }

    private class func findMaxVlue(_ input: [(Int, Int)]) -> (maxValue: (Int, Int), indexOfMaxValue: Int) {
        var maxValue = input.first ?? (0, 0)
        var indexOfMaxValue = 0
        
        for i in input.enumerated() {
            if i.element.0 > maxValue.0 {
                maxValue = i.element
                indexOfMaxValue = i.offset
            }
        }
        
        return (maxValue, indexOfMaxValue)
    }

}
