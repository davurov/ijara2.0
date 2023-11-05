//
//  Net.swift
//  ijara
//
//  Created by Abduraxmon on 20/08/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class Net {
    
    
    class func request(isQuery: Bool = false, url: String, method: HTTPMethod, params: [String:Any]?, headers: HTTPHeaders?, withLoader: Bool, completion: @escaping (JSON?)->Void) {
        
        if ReachabilityDemo.isConnectedToNetwork() {
            if withLoader {
                Loader.start()
            }
            
            AF.request(url, method: method, parameters: params, encoding: isQuery ? URLEncoding.queryString : JSONEncoding.default, headers: headers).response { (response) in
//                Loader.stop()
                
                guard let data = response.data else {
                    print("nil from response")
                    completion(nil)
                    return
                }
                let json = JSON(data)
                completion(json)
            }
        } else {
            //Not connected to the internet
            print("Not connected to the internet")
            completion(nil)
            
        }
    }
    
    class func isSuccess(json: JSON)-> Bool {
        if json["code"].int == 0 {
            return true
        }else {
            return false
        }
    }
    
}
