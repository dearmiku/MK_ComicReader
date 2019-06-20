//
//  MK_DataSource_DMZJ.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import Moya
import Action
import RxSwift


/// 数据源--动漫之家
class MK_DataSource_DMZJ {
    
    var bag = DisposeBag()
    
    lazy var provider = MoyaProvider<MK_DataSource_DMZJ_Target>()
    
    
    ///漫画书Action
    lazy var bookAction = { () -> Action<String, MK_DataSource_DMZJ_BookModel?> in
        
        let res = Action<String,MK_DataSource_DMZJ_BookModel?>.init(workFactory: {[weak self] (bookID) -> Observable<MK_DataSource_DMZJ_BookModel?> in
            
            guard let sf = self else {
                return Observable<MK_DataSource_DMZJ_BookModel?>.just(nil)
            }
            
            return sf.provider.rx.request(MK_DataSource_DMZJ_Target.getComickInfo(bookID)).filter(statusCode: 200).mapJSON().map { (json) -> MK_DataSource_DMZJ_BookModel? in
                guard let dic = json as? [String:Any],
                    let model = MK_DataSource_DMZJ_BookModel.deserialize(from: dic) else {
                        return nil
                }
                return model
                }.asObservable()
        })
        return res
    }()
    
    
    
    init(){
     
        
        
    }
    
}
