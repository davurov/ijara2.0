//
//  Net.swift
//  ijara
//
//  Created by Abduraxmon on 20/08/23.
//

import Foundation

//  Cache.swift
//  Taxi
//  Created by apple on 17/05/22.

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
                Loader.stop()
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                let json = JSON(data)
//                if json["code"].intValue == 401 {
//                    let vc = OnBroadingVC(nibName: "OnBroadingVC", bundle: nil)
//                    if let window = (UIApplication.shared.delegate as! AppDelegate).window {
//                        window.rootViewController = vc
//                    }
//                }
                completion(json)
            }
        } else {
            //Not connected to the internet
            completion(nil)
            //Alert.showAlert(forState: .error, message: SetLanguage.setLang(type: .checkInternet), duration: 10, userInteration: false)
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
