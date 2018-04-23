
//
//  AlamofireRequestFetch.swift
//  MenuBar
//
//  Created by Mac on 07/01/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Alamofire


class AlamofireRequestFetch {
    
    var baseUrl:String!
    
    var getRequest:Alamofire.Request!
    
    init(baseUrl:String) {
        
        self.baseUrl = baseUrl
        
    }
    
    func getDataFromServer(subUrl:String,completionHandler: @escaping (Any?) -> ()) {
        let url = (self.baseUrl+subUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print(url)
        getRequest = Alamofire.request(url!)
            .validate()
            .responseJSON { response in
                
                completionHandler(response.result.value)
        }
    }
    
    func UpdateRequestWithRequestStringToServer(subUrl:String, method: HTTPMethod, parameters: [String: Any], completionHandler: @escaping (DataResponse<String>) -> ()) {
        
        let url = (self.baseUrl+subUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(url)
        
        getRequest = Alamofire.request(url!, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (result:DataResponse<String>) in
                completionHandler(result)
            })
    }
    
    func UpdateRequestToServer(subUrl:String, method: HTTPMethod, parameters: [String: Any],completionHandler: @escaping (Any?) -> ()) {
        
        let url = (self.baseUrl+subUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(url)
        
        getRequest = Alamofire.request(url!, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response)
                
                completionHandler(response.result.value)
        }
    }
    
    
    deinit {
        
        if getRequest != nil {
            getRequest.cancel()
        }
        print("Alamofire Request Fetch deinit")
    }
    
}
