//
//  EndPoints.swift
//  ijara
//
//  Created by Abduraxmon on 20/08/23.
//

import Foundation

let base_URL : String = "https://bronla.uz"
//let lang = UserDefaults.standard.string(forKey: Keys.LANG) ?? "uz"

struct Endpoints {
    static let products = base_URL + "/bronla/uz/data/api/CountryHouse/"
    static let getEntData = base_URL + "/bronla/uz/data/api/Entertainment"
    static let getTaxi = base_URL + "/bronla/uz/data/api/taxi/"
    static let getChildrensParty = base_URL + "/bronla/uz/data/api/forchildren/"
}

// Ayiqlar Animatorlar multfilm qahramonlari Teddy shou -> id = 8
// Cobalt 01J811TA -> id=8
// oilaviy dacha -> id=8

