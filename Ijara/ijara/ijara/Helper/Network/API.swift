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
        
        API.getProducts { IDsOfHouses in
            
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
    
    class func getProducts(completion: @escaping ([Int]?) -> Void){
        
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
    class func getDetailDataByID(id: Int,completion: @escaping (CountryhouseData?) -> Void) {
        
        Net.request(url: "\(Endpoints.products)\(id)/", method: .get, params: nil, headers: nil) { data in
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
                priceForWeekends: weekendPrice
            )
            
            completion(house)
            
            }
        }
    
    //MARK: - GET ENTETAINMENT DATA
    class func getEntertainmentData(completion: @escaping ([Entertainmentdatum]?) -> Void) {
        Net.request(url: Endpoints.getEntData, method: .get, params: nil, headers: nil) { data in
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
    
    class func getNews(){
        Net.request(url: "https://bronla.uz/blog", method: .get, params: nil, headers: nil) { json in
            guard let data = json else { return }
            
            let blogData = data["pageProps"]["blogdata"]
            
            print("news datas: \n title: \(blogData["title"].stringValue), \n description: \(blogData["description"].stringValue), \n image: \(blogData["image"].stringValue) ")
        }
    }
    
}


