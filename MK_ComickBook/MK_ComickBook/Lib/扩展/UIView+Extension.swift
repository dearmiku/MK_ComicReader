//
//  UIView+Extension.swift
//  MikuRecord
//
//  Created by 杨尚达 on 2017/6/4.
//  Copyright © 2017年 杨尚达. All rights reserved.
//

import UIKit


extension UIView {
    
    // x坐标
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    
    // y坐标
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {

            frame.origin.y = newValue
        }
    }

    
    // width
    var width: CGFloat {
        get {
            return frame.size.width
        } set {
  
            frame.size.width = newValue
        }
    }
    
    // height
    var height: CGFloat {
        get {
            return frame.size.height
        } set {
   
            frame.size.height = newValue
        }
    }
    
    //  size 
    var size: CGSize {
        get {
            return frame.size
        } set {
    
            frame.size = newValue
        }
    }
    
    //  centerX
    var centerX: CGFloat {
        get {
            return center.x
        } set {
            center.x = newValue
        }
    }

    //  centerY
    var centerY: CGFloat {
        get {
            return center.y
        } set {
            center.y = newValue
        }
    }
    
    ///宽高比
    var ratio_width_height:CGFloat{
        get{
            return self.size.width/self.size.height
        }
    }
    
    ///高宽比
    var ratio_height_width:CGFloat{
        get{
            return self.size.width/self.size.height
        }
    }
}
