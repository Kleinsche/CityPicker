//
//  CityModel.swift
//  SharedChat--v1.0
//
//  Created by Kleinsche on 2017/8/12.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

import UIKit

class CityModel: NSObject {

    var name: String?
    var province: String?
    var areas: [AreaModel] = []
    
    func configWithArr(arr: [String]) {
        var areaArr: [AreaModel] = []
        for tmp in arr {
            let area = AreaModel()
            area.name = tmp
            area.province = self.province
            area.city = self.name
            areaArr.append(area)
        }
        self.areas = areaArr
    }
    
}
