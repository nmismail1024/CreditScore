//
//  CreditDataAPI.swift
//  CreditScore
//
//  Created by Nur Ismail on 2020/03/04.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation

public class CreditDataAPI {
    
    private let apiURLPrefix = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod"

    //API urls
    private let apiCreditDataURL = "mockcredit/values"
    
    
    //TODO In a real situation the api call would possibly return a list of credit data, or we would need to perhaps pass in the id of the client to the api call so that it returns the correct credit data for that client.
    public func getCreditData(completion: @escaping (CreditData?) -> Void = { creditData in }) {
        
        let apiURL = URL(string: apiURLPrefix)!.appendingPathComponent(apiCreditDataURL)
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //assume an error if data == nil
            guard data != nil else {
                completion(nil)
                return
            }
            
            //print(response!)  //debug info
            do {
                let creditData = try JSONDecoder().decode(CreditData.self, from: data!)
                //print("*** creditData = \(creditData)")
                //print("*** creditData: score = \(creditData.creditReportInfo.score) out of \(creditData.creditReportInfo.maxScoreValue)")
                
                completion(creditData)  //***
            } catch {
                print("error")
                completion(nil)  //***
            }
        })
        
        task.resume()
    }
}

public let creditDataAPI = CreditDataAPI()
