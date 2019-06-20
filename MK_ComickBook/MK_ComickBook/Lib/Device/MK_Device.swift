//
//  MK_Device.swift
//  idPhotoAbroad
//
//  Created by MBP on 2018/2/7.
//  Copyright © 2018年 leqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AVFoundation


//屏幕宽高
var ScreenWidth:CGFloat{
    get{
        return UIScreen.main.bounds.size.width
    }
}
var ScreenHeight:CGFloat{
    get{
        return UIScreen.main.bounds.size.height
    }
}

///分辨率
var ScreenScale:CGFloat {
    get{
        return UIScreen.main.scale
    }
}

let KeyWindow = UIApplication.shared.keyWindow!

///主屏幕
var mainScreen:UIScreen {
    get{
        return UIScreen.main
    }
}



///设备相关信息
class MK_Device {
    
    static var bag = DisposeBag()
    
    
    // MARK: -- 尺寸
    ///导航栏高度 + 状态栏
    static var navigationBarHight:CGFloat{
        get{
            
            ///普通iPhone
            if safeArre.bottom == 0 {
                
                return 64.0
                
                ///全面屏系列
            }else{
                if isLandspace {
                    return 32.0
                }else{
                    return 88.0
                }
            }
        }
    }
    ///TabBar + 安全区的高度
    static var tabbarHight:CGFloat = MK_Device.safeArre.bottom + 49.0
    
    ///状态栏高度
    static var stateBarHight:CGFloat{
        get{
            if safeArre == UIEdgeInsets.zero {
                return 20
            }else{
                if isLandspace {
                    return 0
                }else{
                    return 44
                }
            }
        }
    }
    
    ///安全区
    static var safeArre:UIEdgeInsets {
        get{
            if #available(iOS 11.0, *) {
                return KeyWindow.safeAreaInsets
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    
    
    ///ppi
    static let ppi : CGFloat = {
        switch  deviceType {
            
        case .iPhone_1G ,.iPhone_3G ,.iPhone_3GS:
            return 163
            
        case .iPhone_4 ,.iPhone_4s ,.iPhone_5 ,.iPhone_5c ,.iPhone_5s ,.iPhone_6 ,.iPhone_6s ,.iPhone_SE ,.iPhone_7 ,.iPhone_8:
            return 326
            
        case .iPhone_6_Plus ,.iPhone_6s_Plus ,.iPhone_7_Plus ,.iPhone_8_Plus:
            return 401
            
        case .iPhone_X ,.iPhone_XS ,.iPhone_XS_Max:
            return 458
            
        case .iPhone_XR:
            return 326
            
        case .unKnown:
            return 458
        }
    }()
    
    // MARK: -- 屏幕
    ///屏幕渲染尺寸size(px)
    static var screenSize_px : CGSize {
        get{
            switch deviceType {
            case .iPhone_6_Plus ,.iPhone_6s_Plus ,.iPhone_7_Plus ,.iPhone_8_Plus:
                return CGSize.init(width: 1080, height: 1920)
            default:
                return CGSize.init(width: KeyWindow.width * UIScreen.main.scale, height: KeyWindow.height * UIScreen.main.scale)
            }
        }
    }
    
    
    ///屏幕 单位inch 的点数
    static let inch_point_rate:CGFloat = {
        
        ///获取长度(px)
        let windowHeight_px = MK_Device.screenSize_px.height
        ///获取长度(point)
        let windowHeight_point = KeyWindow.height
        ///获取长度(inch)
        let windowHeight_Inch = windowHeight_px / MK_Device.ppi
        
        return windowHeight_point / windowHeight_Inch
    }()
    
    ///屏幕 单位cm 的点数
    static let  cm_point_rate : CGFloat = inch_point_rate / 2.54
    
    
    
    ///是否横屏
    static var isLandspace:Bool {
        
        get{
            return ScreenWidth > ScreenHeight
        }
        
    }
    
    ///屏幕旋转信号(是否横屏)
    static var screenOrignSing = NotificationCenter.default.rx
        .notification(UIDevice.orientationDidChangeNotification).asObservable()
        .filter { (_) -> Bool in
            switch UIDevice.current.orientation {
                
            case .unknown,.faceUp,.faceDown:
                return false
            default:
                return true
            }
        }
        .map { (_) -> Bool in
            switch UIDevice.current.orientation {
                
            case .portrait,.portraitUpsideDown:
                return false
                
            case .landscapeLeft,.landscapeRight:
                return true
                
            default:
                return true
            }
    }
    
    // MARK: -- 设备
    ///获取设备信息
    static let deviceType:DeviceType = {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        switch platform {
            
        case "iPhone1,1":
            return DeviceType.iPhone_1G
            
        case "iPhone1,2":
            return DeviceType.iPhone_3G
            
        case "iPhone2,1":
            return DeviceType.iPhone_3GS
            
        case "iPhone3,1", "iPhone3,3":
            return DeviceType.iPhone_4
            
        case "iPhone4,1":
            return DeviceType.iPhone_4s
            
        case "iPhone5,1", "iPhone5,2":
            return DeviceType.iPhone_5
            
        case "iPhone5,3", "iPhone5,4":
            return DeviceType.iPhone_5c
            
        case "iPhone6,1", "iPhone6,2":
            return DeviceType.iPhone_5s
            
        case "iPhone7,2":
            return DeviceType.iPhone_6
            
        case "iPhone7,1":
            return DeviceType.iPhone_6_Plus
            
        case "iPhone8,1":
            return DeviceType.iPhone_6s
            
        case "iPhone8,2":
            return DeviceType.iPhone_6s_Plus
            
        case "iPhone8,4":
            return DeviceType.iPhone_SE
            
        case "iPhone9,1", "iPhone9,3":
            return DeviceType.iPhone_7
            
        case "iPhone9,2", "iPhone9,4":
            return DeviceType.iPhone_7_Plus
            
        case "iPhone10,1", "iPhone10,4":
            return DeviceType.iPhone_8
            
        case "iPhone10,2", "iPhone10,5":
            return DeviceType.iPhone_8_Plus
            
        case "iPhone10,3", "iPhone10,6":
            return DeviceType.iPhone_X
            
        case "iPhone11,2":
            return DeviceType.iPhone_XS
            
        case "iPhone11,4", "iPhone11,6":
            return DeviceType.iPhone_XS_Max
            
        case "iPhone11,8":
            return DeviceType.iPhone_XR
            
            
        default:
            return DeviceType.unKnown
        }
        
    }()
    
   
    // MARK: -- 杂
    ///软件版本号
    static let sysVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
    

}


extension MK_Device {
    
    
    ///设备型号
    enum DeviceType {
        
        case unKnown
        
        case iPhone_1G
        
        case iPhone_3G
        
        case iPhone_3GS
        
        case iPhone_4
        
        case iPhone_4s
        
        case iPhone_5
        
        case iPhone_5c
        
        case iPhone_5s
        
        case iPhone_6
        
        case iPhone_6_Plus
        
        case iPhone_6s
        
        case iPhone_6s_Plus
        
        case iPhone_SE
        
        case iPhone_7
        
        case iPhone_7_Plus
        
        case iPhone_8
        
        case iPhone_8_Plus
        
        case iPhone_X
        
        case iPhone_XS
        
        case iPhone_XS_Max
        
        case iPhone_XR
        
    }
    
    
    
}

