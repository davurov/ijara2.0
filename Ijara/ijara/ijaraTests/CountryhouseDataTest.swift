//
//  CountryhouseDataTest.swift
//  ijaraTests
//
//  Created by Sarvar Qosimov on 30/11/23.
//

import XCTest
@testable import ijara

final class CountryhouseDataTest: XCTestCase {
    
//    var mockView: CountryhouseData!
    var homeDetailVC: HomeDetailVC!
    
    override func setUp() {
        homeDetailVC = HomeDetailVC()
        print("setUp")
//        mockView = CountryhouseData(id: 0, name: "name", owner: "", comment: "", referencepoint: "", image: "", firstcalendar: "", secondcalendar: "", images: [], videos: [], onlinebooking: false, heart: false, virtualtourpath: "", reyting: 0.0, entertainmentdata: [], approved: false, location: "", address: "", province: "", provinceID: 0, firstphone: "", secondphone: "", holidays: [], weekendsAreGivenToPerson: false, company: [], seen: 0, alcohol: false, weekday: [], sleeping: 0, bedroomsrooms: 0, numberOfCalls: 0, numberofpeople: 0, startTime: "", finishTime: "", tileDisabled: [], listlocation: [], date: "", card: "", cardowner: "", status: false, priceForWorkingDays: 0, priceForWeekends: 0)
    }
    
    override func tearDownWithError() throws {
//        mockView = nil
    }
    
    func testProportiesIsNotNil(){
        print("testProportiesIsNotNil")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/1"
        
        let currentDate = Date()
        
    }

}
