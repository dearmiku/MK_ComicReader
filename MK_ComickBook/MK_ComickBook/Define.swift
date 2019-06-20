//
//  Define.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import UIKit




///自定义输出Log
func MKLogInfo(_ ob:Any){
    #if DEBUG
    print("<========\n\(ob)\n========>")
    #else
    #endif
}

/* 常规颜色 */
///常规背景色
let MK_Normal_BackgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.00)

///主题蓝色
let MK_MainTopicColor = UIColor(red:0.33, green:0.65, blue:0.97, alpha:1.00)
