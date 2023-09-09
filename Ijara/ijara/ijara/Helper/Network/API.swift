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
    //MARK: - GET DATA
    class func getProducts(completion: @escaping ([HouseDM]?) -> Void){
        
        Net.request(url: Endpoints.products, method: .get, params: nil, headers: nil, withLoader: true) { data in
            var houses = [HouseDM]()
            
            if let data = data {
                for i in data.arrayValue {
                    var house = HouseDM(
                        id: i["id"].intValue,
                        name: i["name"].stringValue,
                        numberOfPeople: i["numberofpeople"].intValue,
                        swimmingpool: [],
                        province: i["province"].stringValue,
                        provincename: i["provincename"].stringValue,
                        workingdays: i["workingdays"].stringValue,
                        weekends: i["weekends"].stringValue,
                        images: [],
                        approved: i["approved"].boolValue,
                        alcohol: i["alcohol"].boolValue,
                        reyting: i["reyting"].intValue,
                        companylist: [],
                        heart: i["heart"].boolValue,
                        checkperday: i["checkperday"].intValue,
                        listlocation: [])
                    
                    for j in  i["swimmingpool"].arrayValue {
                        house.swimmingpool.append(Swimmingpool(
                            id: j["id"].intValue,
                            nsme: j["name"].stringValue,
                            size: j["size"].stringValue,
                            image: j["image"].stringValue))
                    }
                    
                    for j in i["images"].arrayValue {
                        house.images.append(j.stringValue)
                    }
                    
                    for j in i["listlocation"].arrayValue {
                        house.listlocation.append(j.doubleValue)
                    }
                    
                    for j in i["companylist"].arrayValue {
                        house.companylist.append(Companylist(
                            id: j["id"].intValue,
                            name: j["name"].stringValue,
                            image: j["image"].stringValue))
                    }
                    
                    houses.append(house)
                }
                
                completion(houses)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: GET PRODUCTS BY ID
    class func getProducts(id: String,completion: @escaping (CountryhouseData?) -> Void) {
        let homeId = "\(id).json?id=\(id)"
        Net.request(url: Endpoints.getById + homeId, method: .get, params: nil, headers: nil, withLoader: false) { data in
            
            if let data = data {
                var dict = data["pageProps"]["countryhousedata"].dictionaryValue
                
                var houseData = CountryhouseData(
                                    id: dict["id"]!.intValue,
                                    name: dict["name"]!.stringValue,
                                    owner: dict["owner"]!.stringValue,
                                    comment: dict["comment"]!.stringValue,
                                    referencepoint: dict["referencepoint"]!.stringValue,
                                    image: dict["image"]!.stringValue,
                                    firstcalendar: dict["firstcalendar"]!.stringValue,
                                    secondcalendar: dict["secondcalendar"]!.stringValue,
                                    images: dict["images"]!.arrayValue.map(String.init),
                                    videos: dict["videos"]!.arrayValue.map(String.init),
                                    onlinebooking: dict["onlinebooking"]!.boolValue,
                                    heart: dict["heart"]!.boolValue,
                                    virtualtourpath: dict["virtualtourpath"]!.stringValue,
                                    reyting: dict["reyting"]!.intValue,
                                    company: [],
                                    entertainmentdata: [],
                                    approved: dict["approved"]!.boolValue,
                                    location: dict["location"]!.stringValue,
                                    address: dict["address"]!.stringValue,
                                    province: dict["province"]!.stringValue,
                                    provinceID: dict["provinceId"]!.intValue,
                                    firstphone: dict["firstphone"]!.stringValue,
                                    secondphone: dict["secondphone"]!.stringValue,
                                    holidays: dict["holidays"]!.arrayValue.map(String.init),
                                    weekendsAreGivenToPerson: dict["weekendsAreGivenToPerson"]!.boolValue,
                                    seen: dict["seen"]!.intValue,
                                    alcohol: dict["alcohol"]!.boolValue,
                                    weekday: [],
                                    sleeping: dict["sleeping"]!.intValue,
                                    bedroomsrooms: dict["bedroomsrooms"]!.intValue,
                                    numberOfCalls: dict["number_of_calls"]!.intValue,
                                    numberofpeople: dict["numberofpeople"]!.intValue,
                                    startTime: dict["start_time"]!.stringValue,
                                    finishTime: dict["finish_time"]!.stringValue,
                                    payment: [],
//                                    tileDisabled: dict["tileDisabled"]!.stringValue,
//                                    paydaylist: dict["paydaylist"]!.boolValue,
                                    listlocation: [],
                                    date: dict["date"]!.stringValue,
                                    card: dict["card"]!.stringValue,
                                    cardowner: dict["cardowner"]!.stringValue,
                                    status: dict["status"]!.boolValue)
                
                for i in dict["listlocation"]!.arrayValue {
                    houseData.listlocation.append(i.doubleValue)
                }
                
                for i in dict["weekday"]!.arrayValue {
                    houseData.weekday.append(i.intValue)
                }
                
                for i in dict["company"]!.arrayValue {
                    houseData.company.append(Company(id: i["id"].intValue, name: i["name"].stringValue, image: i["image"].stringValue))
                }
                
                for i in dict["entertainmentdata"]!.arrayValue {
                    houseData.entertainmentdata.append(Entertainmentdatum(id: i["id"].intValue, tag: false, type: i["type"].stringValue, name: i["name"].stringValue, image: i["image"].stringValue, label: i["label"].stringValue ))
                }
                
                completion(houseData)
            } else {
                completion(nil)
            }
        }
    }
    
    
}
