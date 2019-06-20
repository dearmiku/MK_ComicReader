//
//  UICOlorExtension.swift
//  MK_IdPhotoPro
//
//  Created by 杨尚达 on 2019/4/8.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import UIKit

///十六进制字符串==>十进制数
func hexStringToDouble(from:String) -> CGFloat {
    let str = from.uppercased()
    var sum = 0.0
    for i in str.utf8 {
        sum = sum * 16.0 + Double(i) - 48.0
        if i >= 65 {
            sum -= 7.0
        }
    }
    return CGFloat(sum)
}

fileprivate func hexStringToColorValue(hexString:String)->(CGFloat,CGFloat,CGFloat){
    var colorStr = (hexString as NSString).replacingOccurrences(of: " ", with: "") as NSString
    
    guard colorStr.length >= 6 else {
        return (0.0,0.0,0.0)
    }
    
    if colorStr.hasPrefix("0X") {
        colorStr = colorStr.substring(from: 2) as NSString
    }
    if colorStr.hasPrefix("#"){
        colorStr = colorStr.substring(from: 1) as NSString
    }
    
    if colorStr.length != 6{
        return (0.0,0.0,0.0)
    }
    var range = NSRange.init(location: 0, length: 2)
    let redStr = colorStr.substring(with: range)
    
    range.location = 2
    let greenStr = colorStr.substring(with: range)
    
    range.location = 4
    let blueStr = colorStr.substring(with: range)
    
    return (hexStringToDouble(from: redStr),hexStringToDouble(from: greenStr),hexStringToDouble(from: blueStr))
}



extension UIColor {
    
    ///十六进制字符串转颜色
    static func color(hexString:String)->UIColor{
        return self.color(hexString: hexString, alpha: 1.0)
    }
    
    ///十六进制字符串转颜色
    static func color(hexString:String,alpha:CGFloat)->UIColor{
        let (r,g,b) = hexStringToColorValue(hexString: hexString)
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    ///十进制数转颜色
    static func color(decNum:Int)->UIColor{
        return color(hexString: String(decNum,radix:16))
    }
}
