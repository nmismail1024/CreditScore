//
//  CreditDataViewModel.swift
//  CreditScore
//
//  Created by Nur Ismail on 2020/03/04.
//  Copyright © 2020 NMI. All rights reserved.
//

public class CreditDataViewModel {
    
    private var creditData: CreditData?

    public init() {
        self.creditData = nil
    }

    public init(creditData: CreditData?) {
        self.creditData = creditData
    }

    //Call the api to get the credit data!
    public func getCreditData(completion: @escaping (_ success: Bool) -> Void = { success in }) {
        creditDataAPI.getCreditData() { creditData in
            
            self.creditData = creditData
//            print("creditData = \(creditData!)")
            
            let success = (creditData != nil)
            completion(success)    //***
        }
    }

    public func hasData() -> Bool {
        return creditData != nil
    }
    
    //Return a default value if creditData not set, alternatively we could use "creditData!." and rather cause a runtime error when called!
    public var score: Int {
        return creditData?.creditReportInfo.score ?? 0
    }
    
    public var maxScoreValue: Int {
        return creditData?.creditReportInfo.maxScoreValue ?? 0
    }
    
    public var creditScoreHeadingLabelText: String {
        return "Your credit score is"   //TODO Localize if needed!
    }
    
    public var creditScoreText: String {
        return "\(score)"
    }

    public var creditScoreOutOfLabelText: String {
        return "out of \(maxScoreValue)"    //TODO Localize if needed!
    }

    //TODO Add other methods that may be needed here...
}
