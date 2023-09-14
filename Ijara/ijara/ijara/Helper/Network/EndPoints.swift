//
//  EndPoints.swift
//  ijara
//
//  Created by Abduraxmon on 20/08/23.
//

import Foundation

let base_URL : String = "https://bronla.uz"
struct Endpoints {
    static let products = base_URL + "/bronla/uz/data/api/CountryHouse/"
    static let getById = base_URL + "/_next/data/3H_hWXqjtamuAwasIEWsw/countryhouse/"
    static let getNewsId = base_URL + "/bronla/uz/data/api/blogcategory/?lang=uz"
    static let getNews = base_URL + "https://bronla.uz/bronla/uz/data/api/blog/"
}
