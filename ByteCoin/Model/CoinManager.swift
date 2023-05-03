//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

// Создаем свой собственный делегат
protocol CoinManagerDelegate {
    func didUpdateCoin (price: String, currency: String)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AD0B5DCD-39F7-40F0-89F7-20097101E540"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        //Разворачиваем url адрес из urlString
        if let url = URL(string: urlString) {
            // Создаем urlSession
            let session = URLSession(configuration: .default)
            //Создаем новую задачу для urlSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                //Форматируем данные, которые получили, в виде строки, чтобы иметь возможность их распечатать.
//                let dataString = String(data: data!, encoding: .utf8)
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoin(price: priceString, currency: currency)
                    }
                }
            }
            //Запускаем задачу для получения данных с сервера.
            task.resume()
        }
    }
    
    //Получение данных из JSON в SWIFT файл
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decoderData.rate
            return lastPrice
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
