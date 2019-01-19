//
//  CryptoRepository.swift
//  Crypto Ticker
//
//  Created by Przemek on 1/18/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum CryptoError: String, Error {
    case connectionError = "connection error has occured"
    case dataError = "wrong json data"
    
    func errorMessage() -> String {
        return self.rawValue
    }
}

protocol CryptoRepositoryDelegate {
    func currencyValue(currency value: Double?, error: CryptoError?)
}

struct CryptoRepository {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    var delegate: CryptoRepositoryDelegate?
    
    func downloadCurrencyData(currencies: String) {
        let url = baseURL + currencies
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let resultJson = JSON(response.result.value!)
                if resultJson["last"] != 0 {
                    self.currencyDataDowndloaded(jsonData: resultJson)
                } else {
                    self.delegate?.currencyValue(currency: nil, error: .dataError)
                }
                
            } else {
                self.delegate?.currencyValue(currency: nil, error: .connectionError)
            }
        }
    }
    
    func currencyDataDowndloaded(jsonData: JSON) {
        let currencyValue = jsonData["last"].doubleValue
        self.delegate?.currencyValue(currency: currencyValue, error: nil)
    }
    

}
