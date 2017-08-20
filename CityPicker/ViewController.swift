//
//  ViewController.swift
//  CityPicker
//
//  Created by Kleinsche on 2017/8/12.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    lazy var cityPicker: PopCityPicker = {
        let city = PopCityPicker()
        city.tapToDismiss = true
        city.showBlur = true
        city.btnFontColour = UIColor.white
        city.btnColour = UIColor.darkGray
        city.showCornerRadius = false
        city.pickerBackground = UIColor.white
        city.delegate = self
        return city
    }()
    
    
    @IBAction func click(_ sender: Any) {
        cityPicker.show(attachToView: self.view)
    }
    
    
    
}

extension ViewController: PopCityPickerDelegate {
    func didSelect(provience: String, city: String, area: String) {
        print("省:\(provience) 市:\(city) 区:\(area)")
    }
}

