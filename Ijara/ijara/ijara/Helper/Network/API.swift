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
                            id: j["swimmingpool"]["id"].intValue,
                            nsme: j["swimmingpool"]["name"].stringValue,
                            size: j["swimmingpool"]["size"].stringValue,
                            image: j["swimmingpool"]["image"].stringValue))
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
    
}
