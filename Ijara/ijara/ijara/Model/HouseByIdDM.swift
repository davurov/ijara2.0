//
//  HouseById.swift
//  ijara
//
//  Created by Abduraxmon on 08/09/23.
//

import Foundation

// MARK: - Countryhousedata
struct CountryhouseData {
    let id: Int
    let name, owner: String
    let comment: String
    let referencepoint, image, firstcalendar, secondcalendar: String
    let images, videos: [String]
    let onlinebooking: Bool
    let heart: Bool
    let virtualtourpath: String
    let reyting: Int
    var company: [Company]
    var entertainmentdata: [Entertainmentdatum]
    let approved: Bool
    let location: String
    let address, province: String
    let provinceID: Int
    let firstphone, secondphone: String
    let holidays: [String]
    let weekendsAreGivenToPerson: Bool
    let seen: Int
    let alcohol: Bool
    var weekday: [Int]
    let sleeping, bedroomsrooms, numberOfCalls, numberofpeople: Int
    let startTime, finishTime: String
    let payment: [PaymentElement]
    //let tileDisabled, paydaylist: [Any?]
    var listlocation: [Double]
    let date, card, cardowner: String
    let status: Bool
}

// MARK: - Company
struct Company {
    let id: Int
    let name, image: String
}

// MARK: - Entertainmentdatum
struct Entertainmentdatum {
    let id: Int
    let tag: Bool?
    let type, name, image: String
    let label: String?
}

// MARK: - PaymentElement
struct PaymentElement {
    let id: Int
    let payment: PaymentPayment
}

// MARK: - PaymentPayment
struct PaymentPayment {
    let id, workingdays, weekends, foranextraperson: Int
}
