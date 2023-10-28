//
//  HouseDM.swift
//  ijara
//
//  Created by Abduraxmon on 21/08/23.
//

import Foundation

struct HouseDM : Codable {
    var id: Int
    var name: String
    var numberOfPeople: Int
    var swimmingpool: [Swimmingpool]
    var province: String
    var provincename: String
    var workingdays: String
    var weekends: String
    var images: [String]
    var approved: Bool
    var alcohol: Bool
    var reyting: Int
    var companylist: [Companylist]
    var heart: Bool
    var checkperday: Int
    var listlocation: [Double]
}

struct Swimmingpool : Codable {
    var id: Int
    var nsme: String
    var size: String
    var image: String
}

struct Companylist : Codable {
    var id: Int
    var name: String
    var image: String
}
