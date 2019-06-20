//
//  MK_DataSource.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import Action
import RxSwift


///数据源
class MK_DataSource {
    
    fileprivate static var ob:MK_DataSource?
    ///单例
    static func share()->MK_DataSource{
        guard let res = ob else {
            let res = MK_DataSource()
            ob = res
            return res
        }
        return res
    }
    
    // MARK: -- 数据源
    fileprivate lazy var dmzjSource = MK_DataSource_DMZJ()
    
    
    // MARK: -- 信号
    
    ///漫画书信息Action(数据源类型,id)
    lazy var comicBookInfoAction = {
        
       return Action<(DataSourceType,String),MK_DataSource_ComickBookInfo_Protocol?>.init(workFactory: {[weak self] (para) -> Observable<MK_DataSource_ComickBookInfo_Protocol?> in
            guard let sf = self else {
                return Observable<MK_DataSource_ComickBookInfo_Protocol?>.just(nil)
            }
            
            let (sourceType,id) = para
            switch sourceType {
                ///动漫之家
            case .DMZJ:
                return sf.dmzjSource.bookAction.execute(id).map { (res) -> MK_DataSource_ComickBookInfo_Protocol? in
                    return res
                }

            }
            
        })
        
    }()
    
    
    
    ///获取漫画的Image
    lazy var comicImageAction = {
        return Action<(DataSourceType,String),UIImage?>.init {[weak self] (para) -> Observable<UIImage?> in
            guard let sf = self else {
                return Observable<UIImage?>.just(nil)
            }
            let (sourceType,urlStr) = para
            switch sourceType {
            ///动漫之家
            case .DMZJ:
                return sf.dmzjSource.imageGetAction.execute(urlStr)
                
            }
        }
    }()
    
    
    init(){

 
        
    }
    
}


extension MK_DataSource {
    
    ///数据源类型
    enum DataSourceType {
        
        ///动漫之家
        case DMZJ
        
    }
    
}


