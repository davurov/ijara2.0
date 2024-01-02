//
//  FiltrHousesModel.swift
//  ijara
//
//  Created by Sarvar Qosimov on 02/01/24.
//

import Foundation

/// `FiltrHousesModel` includs proporties to filtr houses
struct FiltrHousesModel {
    var selectedMinimumPrice = 500000
    var selectedMaximumPrice = 15000000
    var selectedGuestType = [Int]()
    var selectedAdditionalFeatures = [Int]()
    var isUserSelectedAlcohol = false
    var isVerified = false
    var selectedNumberOfPeople: Int?
}
