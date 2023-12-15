//
//  LikedProducts.swift
//  ijara
//
//  Created by Sarvar Qosimov on 07/12/23.
//

import Foundation
import UIKit

enum ServiceType {
    case house, taxi, party
}

class LikedProducts {
    static var likedProducts = LikedProducts()
    
    var likedHousesIDs        : [Int] = []
    var likedTaxiServicesIDs  : [Int] = []
    var likedPartiesIDs       : [Int] = []
    
    let userDef = UserDefaults.standard
    
    init() {
        print("init ga kirdi")
        getLikedProducts()
    }
    
    private func getLikedProducts() {
        likedHousesIDs = userDef.array(forKey: Keys.likedHouses) as? [Int] ?? []
 
        likedTaxiServicesIDs = userDef.array(forKey: Keys.likedTaxis) as? [Int] ?? []
 
        likedPartiesIDs = userDef.array(forKey: Keys.likedParties) as? [Int] ?? []
     }
    
    func isLikedPerform(sevriceType: ServiceType, id: Int) -> Bool {
        switch sevriceType {
        case .house:
            let newIds = removeOrAdd(IDs: &likedHousesIDs, id: id)
            likedHousesIDs = newIds.0
            userDef.set(likedHousesIDs, forKey: Keys.likedHouses)

            return newIds.1
        case .taxi:
            let newIds = removeOrAdd(IDs: &likedTaxiServicesIDs, id: id)
            likedTaxiServicesIDs = newIds.0
            userDef.set(likedTaxiServicesIDs, forKey: Keys.likedTaxis)

            return newIds.1
        case .party:
            let newIds = removeOrAdd(IDs: &likedPartiesIDs, id: id)
            likedPartiesIDs = newIds.0
            
            userDef.set(likedPartiesIDs, forKey: Keys.likedParties)

            return newIds.1
        }
    }
    
    func isLiked(sevriceType: ServiceType, id: Int) -> Bool {
        getLikedProducts()
        switch sevriceType {
        case .house:
//            print("h,t,p 2: ", likedHousesIDs, likedTaxiServicesIDs, likedPartiesIDs)

            return likedHousesIDs.contains(id) ? true : false
        case .taxi:
//            print("h,t,p 2: ", likedHousesIDs, likedTaxiServicesIDs, likedPartiesIDs)

            return likedTaxiServicesIDs.contains(id) ? true : false
        case .party:
//            print("h,t,p 2: ", likedHousesIDs, likedTaxiServicesIDs, likedPartiesIDs)

            return likedPartiesIDs.contains(id) ? true : false
        }
    }
    
    private func removeOrAdd(IDs: inout [Int], id: Int) -> ([Int], Bool) {
        if IDs.contains(id) {
            let index = IDs.firstIndex(of: id) ?? 0
            IDs.remove(at: index)
            return (IDs, false)
        } else {
            IDs.append(id)
            return (IDs, true)
        }
    }
    
    private func getCurrentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let currentDate = Date()
        
        return dateFormatter.string(from: currentDate)
    }
}
