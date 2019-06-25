//
//  MK_DataSource_DMZJ_Target.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import Moya
import RxSwift
import Alamofire


///动漫之家数据提供者
let DMZJ_provider = MoyaProvider<MK_DataSource_DMZJ_Target>()

let DMZJ_Bag = DisposeBag()

/// 动漫之家--漫画数据源
enum MK_DataSource_DMZJ_Target {
    
    ///获取漫画<书>详情
    case getComickInfo(String)
    
    ///获取漫画<话>图片数组 (书id,话id)
    case getComicPartInfo(String,String)
    
    ///获取图片(图片URL)
    case getImage(String)
    
}


extension MK_DataSource_DMZJ_Target : TargetType {
    
    var baseURL: URL {
        switch self {
            
        ///获取漫画详情
        case .getComickInfo(_):
            return URL.init(string: "http://v3api.dmzj.com/")!
            
        ///获取图片URL
        case let .getImage(urlStr):
            return URL.init(string: urlStr) ??  URL.init(string: "http://v3api.dmzj.com/")!
            
        ///获取漫画<话>图片数组 (书id,话id)
        case .getComicPartInfo(_):
            return URL.init(string: "http://v3api.dmzj.com/")!
        }
    }
    
    var path: String {
        switch self {
            
        ///获取漫画详情
        case let .getComickInfo(bookId):
            
            return "comic/\(bookId).json"
            
        case .getImage(_):
            return ""
            
        ///获取漫画<话>图片数组 (书id,话id)
        case let .getComicPartInfo(bookID, partId):
            return "chapter/\(bookID)/\(partId).json"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
            
        ///获取漫画详情
        case .getComickInfo(_):
            return .get
            
        case .getImage(_):
            return .get
            
        case .getComicPartInfo(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        ///获取漫画详情
        case .getComickInfo(_):
            return Task.requestParameters(parameters: [
                "channel":"ios",
                "version":"2.5.6"
                ], encoding: URLEncoding.default)
            
            
        case .getImage(_):
            return Task.requestParameters(parameters: [:], encoding: URLEncoding.default)
            
            
        case .getComicPartInfo(_, _):
            return Task.requestParameters(parameters: [
                "channel":"ios",
                "version":"2.5.6"
                ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getImage(_):
            return [
                "Referer":"http://imgsmall.dmzj.com/"
            ]
        default:
            return nil
        }
    }
    
}
