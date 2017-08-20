//
//  PopCityPicker.swift
//  SharedChat--v1.0
//
//  Created by Kleinsche on 2017/8/12.
//  Copyright © 2017年 Kleinsche. All rights reserved.
//

import UIKit

protocol PopCityPickerDelegate: NSObjectProtocol {
    func didSelect(provience: String, city: String, area: String)
}

class PopCityPicker: UIView, UIGestureRecognizerDelegate {

    weak var delegate: PopCityPickerDelegate?
    
    fileprivate var dataArr: [ProvinceModel] = []
    fileprivate var currentProvience: ProvinceModel?
    fileprivate var currentCity: CityModel?
    fileprivate var currentArea: AreaModel?
    
    
    fileprivate var containerView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var backgroundView: UIView!
    fileprivate var cityPickerView: UIPickerView!
    
    
    open var showBlur = true //Default Yes
    open var tapToDismiss = true //Default Yes
    open var btnFontColour = UIColor.blue //Default Blue
    open var btnColour = UIColor.clear //Default Clear
    open var showShadow = true //Optional
    open var showCornerRadius = true // Optional
    open var pickerBackground = UIColor.clear
    
    
    
    public init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func show(attachToView view: UIView) {
        self.show(self, inView: view)
    }
    
}

extension PopCityPicker {
    
    
    fileprivate func show(_ contentView: UIView, inView: UIView) {
        
        self.contentView = inView
        
        self.containerView = UIView()
        self.containerView.frame = CGRect(x: 0, y: 0, width: inView.bounds.width, height: inView.bounds.height)
        self.containerView.backgroundColor = UIColor.clear
        self.containerView.alpha = 0
        
        self.contentView.addSubview(self.containerView)
        
        
        if showBlur {
            _showBlur()
        }
        
        self.backgroundView = createBackgroundView()
        self.containerView.addSubview(self.backgroundView)
        
        self.cityPickerView = createCityPicker()
        self.backgroundView.addSubview(self.cityPickerView)
        
        
        if showCornerRadius {
            let path = UIBezierPath(roundedRect:self.cityPickerView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            self.cityPickerView.layer.mask = maskLayer
        }
        
        self.backgroundView.addSubview(self.addSelectButton())
        
        
        
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 1
        }, completion: { (success:Bool) in
            UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
                self.backgroundView.frame.origin.y = self.containerView.bounds.height / 2 - 125
            }, completion: { (success:Bool) in
                
            })
        })
        
        if tapToDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
            tap.delegate = self
            self.containerView.addGestureRecognizer(tap)
        }
        
        self.layoutSubviews()
    }
    
}

extension PopCityPicker {
    
    
    func dismiss(_ sender: UITapGestureRecognizer? = nil) {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundView.frame.origin.y += self.containerView.bounds.maxY
        }, completion: { (success:Bool) in
            
            UIView.animate(withDuration: 0.05, delay: 0, options: .transitionCrossDissolve, animations: {
                self.containerView.alpha = 0
            }, completion: { (success:Bool) in
                self.containerView.removeGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.dismiss(_:))))
                self.containerView.removeFromSuperview()
                self.removeFromSuperview()
            })
            
        })
        
        
    }
    
    
    fileprivate func _showBlur() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.containerView.addSubview(blurEffectView)
        
    }
    
    //创建城市选择器
    fileprivate func createCityPicker() -> UIPickerView {
        let cityPickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: -60, width: self.backgroundView.bounds.width, height: self.backgroundView.bounds.height))
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityPickerView.backgroundColor = pickerBackground
        cityPickerView.showsSelectionIndicator = true
//        cityPickerView.autoresizingMask = [.flexibleWidth]
//        cityPickerView.clipsToBounds = true
        return cityPickerView
    }
    
    
    fileprivate func createBackgroundView() -> UIView {
        let bgView = UIView(frame: CGRect(x: self.containerView.frame.width / 2 - 150, y: self.containerView.bounds.maxY + 100, width: 300, height: 160))
        bgView.autoresizingMask = [.flexibleWidth]
        bgView.backgroundColor = UIColor.clear
        
        if showShadow {
            bgView.layer.shadowOffset = CGSize(width: 3, height: 3)
            bgView.layer.shadowOpacity = 0.7
            bgView.layer.shadowRadius = 2
        }
        if showCornerRadius {
            bgView.layer.cornerRadius = 10.0
        }
        return bgView
    }
    
    fileprivate func addSelectButton() -> UIButton {
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: self.backgroundView.frame.width / 2 - 150, y: self.cityPickerView.frame.maxY, width: self.backgroundView.frame.size.width, height: 48)
        btn.setTitle("确定", for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.tintColor = self.btnFontColour
        btn.backgroundColor = self.btnColour
        btn.addTarget(self, action: #selector(didSelectDate(_:)), for: .touchUpInside)
        
        
        if showCornerRadius {
            let path = UIBezierPath(roundedRect: btn.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            btn.layer.mask = maskLayer
        }
        
        
        return btn
    }
    
}


extension PopCityPicker {
    func loadData() {
        let path = Bundle.main.path(forResource: "Address", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let provinces = dict?.allKeys
        for tmp in provinces! {
            let province = ProvinceModel()
            province.name = tmp as? String
            let arr = dict?.object(forKey: tmp) as? [Any]
            let cityDic = arr?.first
            province.configWithDic(dict: cityDic as! NSDictionary)
            self.dataArr.append(province)
        }
        
        let defPro = dataArr.first
        currentProvience = defPro
        
        let defCity = defPro?.citys.first
        currentCity = defCity
        
        currentArea = defCity?.areas.first
    }
    
}


extension PopCityPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dataArr.count
        }else if (component == 1) {
            return (currentProvience?.citys.count)!
        }else{
            return (currentCity?.areas.count)!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = UIColor.white
        if component == 0 {
            let pro = dataArr[row]
//            label.attributedText = NSMutableAttributedString(string: pro.name!, attributes: )
            label.text = pro.name
        }else if (component == 1) {
            
//            if (currentProvience?.citys.count)! > row {
                let city = currentProvience?.citys[row]
                label.text = city?.name
//            }
            
        }else{
//            if (currentCity?.areas.count)! > row {
                let area = currentCity?.areas[row]
                label.text = area?.name
//            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let province = dataArr[row]
            currentProvience = province
            
            let city = province.citys.first
            currentCity = city
            
            currentArea = city?.areas.first
            
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if (component == 1) {
            let city = currentProvience?.citys[row]
            currentCity = city
            
            currentArea = city?.areas.first
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else {
            currentArea = currentCity?.areas[row]
        }
    }
    
}

    //MARK:- 外部代理
extension PopCityPicker {
    @objc fileprivate func didSelectDate(_ sender: UIButton) {
        if delegate != nil {
            self.delegate?.didSelect(provience: (currentProvience?.name)!, city: (currentCity?.name)!, area: (currentArea?.name)!)
            self.dismiss()
        }
    }
}
