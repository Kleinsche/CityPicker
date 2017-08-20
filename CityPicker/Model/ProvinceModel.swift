//
//  PickerModel.swift
//  SharedChat--v1.0
//
//  Created by Kleinsche on 2017/8/12.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

import UIKit

class ProvinceModel: NSObject {

    var name: String?
    var citys: [CityModel] = []
    
    
    func configWithDic(dict: NSDictionary) {
        let citys = dict.allKeys
        var tmpCitys: [CityModel] = []
        for tmp in citys {
            let city = CityModel()
            city.name = tmp as? String
            city.province = self.name
            
            let area: [String] = dict.object(forKey: tmp) as! [String]
            city.configWithArr(arr: area)
            tmpCitys.append(city)
        }
        self.citys = tmpCitys
    }
    
}
