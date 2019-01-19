//
//  ViewController.swift
//  Crypto Ticker
//
//  Created by Przemek on 1/18/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CryptoRepositoryDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyMarks = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    let cryptos = ["BTC", "ETH", "LTC", "XRP"]
    
    var currentCurrency = "AUD"
    var currentMark = "$"
    var currentCrypto = "BTC"
    
    var cryptoRepository: CryptoRepository = CryptoRepository()
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cryptoImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoRepository.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        cryptoRepository.downloadCurrencyData(currencies: self.currentCrypto + self.currentCurrency)
    }
    
    func currencyValue(currency value: Double?, error: CryptoError?) {
        if let currencyValue = value {
            priceLabel.text = "\(currencyValue) \(currentMark) "
        } else if error != nil {
            print(error!.errorMessage())
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        cryptoRepository.downloadCurrencyData(currencies: self.currentCrypto + self.currentCurrency)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return cryptos.count
        case 1:
            return currencyArray.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return cryptos[row]
        case 1:
            return currencyArray[row]
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.currentCrypto = cryptos[row]
            animateCryptoNewImage(crypto: self.currentCrypto)
        case 1:
            self.currentCurrency = currencyArray[row]
            self.currentMark = currencyMarks[row]
        default: break
        }
        
        cryptoRepository.downloadCurrencyData(currencies: self.currentCrypto + self.currentCurrency)
    }
    
    func animateCryptoNewImage(crypto: String) {
        let transitionTimeInterval = 0.1
        
        UIView.animate(withDuration: transitionTimeInterval, animations: {
            self.cryptoImage.alpha = 0.0
        }) { bool in
            self.cryptoImage.image = UIImage(named: crypto)
            UIView.animate(withDuration: transitionTimeInterval, animations: {
                self.cryptoImage.alpha = 1.0
            })
        }
    }
    
    
    


}

