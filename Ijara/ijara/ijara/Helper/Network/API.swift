//
//  API.swift
//  ijara
//
//  Created by Abduraxmon on 23/08/23.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class API {
    
    class func getAllHouses(completion: @escaping ([CountryhouseData]?) -> Void){
        
        // 1. get all ids of villas
        
        var allVillasID: [Int] = []
        
        API.getProductsID { IDsOfHouses in
            
            guard let IDsOfHouses = IDsOfHouses else { completion(nil); return }

            for id in IDsOfHouses {
                allVillasID.append(id)
            }
            receivedAllIds()
        }
        
        func receivedAllIds(){
            // 2. get all houses by id of each house
            
            var allHouses: [CountryhouseData] = []
            
            var counter = 0
            allVillasID = [538, 409, 576, 22, 582, 16, 367, 411, 510, 440, 278, 534, 368, 125, 495, 198, 568, 81, 119, 501, 286, 271, 1, 281, 284, 293, 488]

            for villaID in allVillasID {
                API.getDetailDataByID(id: villaID) { villa in
                    counter += 1
                    
                    guard let house = villa else { completion(nil);  return }
                    allHouses.append(house)

                    if counter == allVillasID.count {
                        completion(allHouses)
                    }
                }
            }
        }
    }
    
    class func getProductsID(completion: @escaping ([Int]?) -> Void){
        
        Net.request(url: Endpoints.products, method: .get, params: nil, headers: nil) { data in
            
            guard let data = data else { completion(nil) ; return }
            
            var housesIDs: [Int] = []
            
            for ID in data.arrayValue {
                housesIDs.append(ID["id"].intValue)
            }
            
            completion(housesIDs)
        }
    }
    
    /// `getDetailDataByID` function return house type of `CountryhouseData` by id
    class func getDetailDataByID(id: Int, completion: @escaping (CountryhouseData?) -> Void) {
        let currentLang = UserDefaults.standard.string(forKey: Keys.LANG) ?? "uz"
        
        Net.request(url: "\(Endpoints.products)\(id)/?lang=\(currentLang)", method: .get, params: nil, headers: nil) { data in
            guard let data = data else {
                print("can not get detail data")
                completion(nil)
                return
            }
            
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: Date())
            let i = data

            var workPrice = 0
            var weekendPrice = 0
            
            for element in i["payment"].arrayValue {
                if element["id"].intValue == currentMonth {
                    workPrice = element["payment"]["workingdays"].intValue
                    weekendPrice = element["payment"]["weekends"].intValue
                }
            }
            
            let house = CountryhouseData(
                id: i["id"].intValue,
                name: i["name"].stringValue,
                owner: i["owner"].stringValue,
                comment: i["comment"].stringValue,
                referencepoint: i["referencepoint"].stringValue,
                image: i["image"].stringValue,
                firstcalendar: i["firstcalendar"].stringValue,
                secondcalendar: i["secondcalendar"].stringValue,
                images: i["images"].arrayValue.map {$0.stringValue},
                videos: i["videos"].arrayValue.map {$0.stringValue},
                onlinebooking: i["onlinebooking"].boolValue,
                heart: i["heart"].boolValue,
                virtualtourpath: i["virtualtourpath"].stringValue,
                reyting: i["reyting"].doubleValue,
                entertainmentdata: i["entertainmentdata"].arrayValue.map {Entertainmentdatum(
                    id: $0["id"].intValue,
                    tag: $0["tag"].boolValue,
                    type: $0["type"].stringValue,
                    name: $0["name"].stringValue,
                    image: $0["image"].stringValue,
                    label: $0["label"].stringValue)},
                approved: i["approved"].boolValue,
                location: i["location"].stringValue,
                address: i["address"].stringValue,
                province: i["province"].stringValue,
                provinceID: i["provinceID"].intValue,
                firstphone: i["firstphone"].stringValue,
                secondphone: i["secondphone"].stringValue,
                holidays: i["holidays"].arrayValue.map {$0.stringValue},
                weekendsAreGivenToPerson: i["weekendsAreGivenToPerson"].boolValue,
                company: i["company"].arrayValue.map {Company(
                    id: $0["id"].intValue,
                    name: $0["name"].stringValue,
                    image: $0["image"].stringValue)},
                seen: i["seen"].intValue,
                alcohol: i["alcohol"].boolValue,
                weekday: i["weekday"].arrayValue.map {$0.intValue},
                sleeping: i["sleeping"].intValue,
                bedroomsrooms: i["bedroomsrooms"].intValue,
                numberOfCalls: i["numberOfCalls"].intValue,
                numberofpeople: i["numberofpeople"].intValue,
                startTime: i["start_time"].stringValue,
                finishTime: i["finish_time"].stringValue,
                tileDisabled: i["tileDisabled"].arrayValue.map {$0.stringValue},
                listlocation: i["listlocation"].arrayValue.map {$0.doubleValue},
                date: i["date"].stringValue,
                card: i["card"].stringValue,
                cardowner: i["cardowner"].stringValue,
                status: i["status"].boolValue,
                priceForWorkingDays: workPrice,
                priceForWeekends: weekendPrice,
                imagesAsData: []
            )
            
            completion(house)
            
            }
        }
    
    //MARK: - GET ENTETAINMENT DATA
    class func getEntertainmentData(completion: @escaping ([Entertainmentdatum]?) -> Void) {
        var currentLang = UserDefaults.standard.string(forKey: Keys.LANG) ?? "uz"
        
        if currentLang == "en" {
            currentLang = "uz"
        }
        
        Net.request(url: Endpoints.getEntData + "/?lang=\(currentLang)", method: .get, params: nil, headers: nil) { data in
            if let data = data {
                var enterData = [Entertainmentdatum]()
                for i in data.arrayValue {
                    let datum = Entertainmentdatum(
                        id: i["value"].intValue,
                        tag: false,
                        type: "",
                        name: i["label"].stringValue,
                        image: "",
                        label: "")
                    enterData.append(datum)
                }
                completion(enterData)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - getTaxiServices
    class func getTaxiServices(completion: @escaping ([TaxiDM]?) -> Void) {
        let currentLang = UserDefaults.standard.string(forKey: Keys.LANG) ?? "uz"

        Net.request(url: Endpoints.getTaxi + "?lang=\(currentLang)", method: .get, params: nil, headers: nil) { json in
            guard let data = json else { completion(nil); return }
            
            var taxi: TaxiDM!
            var taxiServices: [TaxiDM] = []
            
            for i in data.arrayValue {
                taxi = TaxiDM(
                    id: i["id"].intValue,
                    title: i["title"].stringValue,
                    taxiType: i["taxitype"].stringValue,
                    taxiDirection: i["taxidirection"].stringValue,
                    passengers: i["passenger"].stringValue,
                    startingPrice: i["startingprice"].stringValue,
                    carImages:  [],
                    driverName: i["owner"].stringValue,
                    coments: i["comment"].stringValue,
                    telNumber1: i["firstphone"].stringValue,
                    telNumber2: i["secondphone"].stringValue,
                    minimumConditions: i["minconditions"].stringValue
                )
                for img in i["images"].arrayValue {
                    taxi.carImages.append(img.stringValue)
                }
                taxiServices.append(taxi)
            }
            completion(taxiServices)
            
        }
        
    }
    
    //MARK: - GET ENTETAINMENT DATA
    class func getChildrensParty(completion: @escaping ([ChildrensParty]?) -> Void){
        Net.request(url: Endpoints.getChildrensParty, method: .get, params: nil, headers: nil) { json in
            guard let events = json else { completion(nil); return }
            var eventsForChildrens: [ChildrensParty] = []
            
            for event in events.arrayValue {
                var children = ChildrensParty(
                    id: event["id"].intValue,
                    title: event["title"].stringValue,
                    owner: event["owner"].stringValue,
                    images: [],
                    forchildrenzone: event["forchildrenzone"].stringValue,
                    forchildrenstatus: event["forchildrenstatus"].stringValue,
                    startingprice: event["startingprice"].stringValue,
                    minconditions: event["minconditions"].stringValue,
                    comment: event["comment"].stringValue,
                    firstphone: event["firstphone"].stringValue,
                    secondphone: event["secondphone"].stringValue,
                    currency: event["currency"].stringValue
                )
                
                for image in event["images"].arrayValue {
                    children.images.append(image.stringValue)
                }
                
                eventsForChildrens.append(children)
            }
            
            completion(eventsForChildrens)
        }
    }
    
}

extension API {
        
   class func getAllTaxiServices(completion: @escaping ([TaxiDM]?) -> Void){
       var timer: Timer?
       var allTaxiServices: [TaxiDM] = []
       var existIDs: [Int] = []
       var counter: Int?

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [self] _ in
            
            API.getTaxiServices { taxiServices in
                guard let taxiServices = taxiServices else { completion (nil); return }
                
                counter = taxiServices.count
                
                for taxiService in taxiServices {
                    if taxiService.title != "" && !existIDs.contains(taxiService.id) {
                        existIDs.append(taxiService.id)
                        allTaxiServices.append(taxiService)
                    }
                }
            }
            
            // if allTaxiServices is full, stop timer and return
            
            if let counter = counter, allTaxiServices.count == counter {
                timer?.invalidate()
                timer = nil
                completion (allTaxiServices)
            }
        })
    }
    
   class func getAllChildrenParties(completion: @escaping ([ChildrensParty]?) -> Void){
       var timer: Timer?
       var allChildrenParties: [ChildrensParty] = []
       var existIDs: [Int] = []
       var counter: Int?
       
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [self] _ in
            
            API.getChildrensParty { childrenParties in
                guard let childrenParties = childrenParties else { completion (nil); return }
                
                counter = childrenParties.count
                
                for party in childrenParties {
                    if party.title != "" && !existIDs.contains(party.id) {
                        existIDs.append(party.id)
                        allChildrenParties.append(party)
                    }
                }
            }
            
            // if allTaxiServices is full, stop timer and return
            
            if let counter = counter, allChildrenParties.count == counter {
                timer?.invalidate()
                timer = nil
                print("mana all childreds ga bervordi")
                completion (allChildrenParties)
            }
        })
    }

}
