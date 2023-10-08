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
import Firebase
import FirebaseFirestore
import FirebaseAuth


class API {
    //MARK: - GET DATA
    static let db = Firestore.firestore()
    static var isMap = false
    
    class func getProducts(completion: @escaping ([HouseDM]?) -> Void){
        
        Net.request(url: Endpoints.products, method: .get, params: nil, headers: nil, withLoader: false) { data in
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
    //MARK: - GET ENTETAINMENT DATA
    class func getEntertainmentData(lang: String,completion: @escaping ([Entertainmentdatum]?) -> Void) {
        Net.request(url: Endpoints.getEntData, method: .get, params: nil, headers: nil, withLoader: false) { data in
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
    
    
    //MARK: GET PRODUCTS BY ID
    class func getProducts(id: String,token: String,completion: @escaping (CountryhouseData?) -> Void) {
        Net.request(url: Endpoints.getById + token + "/countryhouse/\(id).json?id=\(id)", method: .get, params: nil, headers: nil, withLoader: !API.isMap) { data in
            if let data = data {
                
                    let i = data["pageProps"]["countryhousedata"]
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
                        status: i["status"].boolValue)
                    completion(house)
            } else {
                Firebase.changeTokenStatus()
            }
        }
    }
        
        
    }
    
    class Firebase {
        class func getIdFromFirebase(completion: @escaping (String?) -> Void) {
            let docRef = API.db.collection(Keys.fStore).document("1")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let dataDescription = document.data() {
                        if dataDescription["is_valid"] as! Bool {
                            let data = dataDescription["token"] as? String
                            completion(data)
                        }
                    }
                } else {
                    print("error")
                    completion(nil)
                }
            }
        }
        
        class func changeTokenStatus() {
            
        }
    }
