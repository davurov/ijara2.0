//
//  HouseById.swift
//  ijara
//
//  Created by Abduraxmon on 08/09/23.
//

import Foundation

// MARK: - Countryhousedata
struct CountryhouseData: Codable {
    let id: Int
    let name, owner: String
    let comment: String
    let referencepoint, image, firstcalendar, secondcalendar: String
    let images, videos: [String]
    let onlinebooking: Bool
    let heart: Bool
    let virtualtourpath: String
    let reyting: Double
    var entertainmentdata: [Entertainmentdatum]
    let approved: Bool
    let location: String
    let address, province: String
    let provinceID: Int
    let firstphone, secondphone: String
    let holidays: [String]
    let weekendsAreGivenToPerson: Bool
    let company: [Company]
    let seen: Int
    let alcohol: Bool
    var weekday: [Int]
    let sleeping, bedroomsrooms, numberOfCalls, numberofpeople: Int
    let startTime, finishTime: String
    let tileDisabled: [String]
    var listlocation: [Double]
    let date, card, cardowner: String
    let status: Bool
    var priceForWorkingDays: Int
    var priceForWeekends: Int
}

extension CountryhouseData {
    /// companiesId function return id of companies
    func companiesId() -> [Int]{
        var ids = [Int]()
        for i in company {
            ids.append(i.id)
        }
        return ids
    }
    
    /// additionFeaturesId function return id of entertainmentdata
    func additionFeaturesId () -> [Int]{
        var ids = [Int]()
        for i in entertainmentdata {
            ids.append(i.id)
        }
        return ids
    }
}



// MARK: - Company
struct Company: Codable {
    let id: Int
    let name, image: String
}

// MARK: - Entertainmentdatum
struct Entertainmentdatum: Codable {
    let id: Int
    let tag: Bool
    let type, name, image: String
    let label: String
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
