//
//  ViewController.swift
//  ByteCoin
//
//  Created by Лариса Терегулова on 02.05.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }


}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: -UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    } //Количество столбцов
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    } //Количество строк
    
    //MARK: -UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    } //Что будем выводить на строках
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectCurrency)
    } //Вызывается каждый раз, когда пользователь прокручивает сборщик.
}

//MARK: -CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = price
            self.bitcoinLabel.text = currency
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
