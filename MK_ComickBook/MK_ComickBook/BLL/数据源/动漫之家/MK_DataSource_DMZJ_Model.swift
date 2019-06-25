//
//  MK_DataSource_DMZJ_Model.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import RxSwift
import HandyJSON


// MARK: - 数据模型的扩展



/// 漫画<书>模型
struct MK_DataSource_DMZJ_BookModel {
    
    ///漫画书id
    var id:String = ""
    
    ///漫画书标题
    var title:String = ""
    
    ///漫画描述
    var description:String = ""
    
    ///漫画封面
    var cover:String = ""
    
    ///作者信息数组
    var authors:[[String:Any]] = []
    
    ///<话>信息数组
    var chapters:[[String:Any]] = []
    
    
    ///缓存--<话>模型
    var cachPartModelArr:[MK_DataSource_ComickPartInfo_Protocol]?
    
    
}

extension MK_DataSource_DMZJ_BookModel : HandyJSON {
}


extension MK_DataSource_DMZJ_BookModel : MK_DataSource_ComickBookInfo_Protocol {
    
    var sourceType: MK_DataSource.DataSourceType {
        return .DMZJ
    }
    
    var bookAuthor: String {
        guard let dic = authors.first,
            let name = dic["tag_name"] as? String else {
                return ""
        }
        return name
    }
    
    var bookName: String {
        return title
    }
    
    var bookDes: String {
        return description
    }
    
    var bookCoverImageURLStr: String {
        return cover
    }
    
    /// 漫画<话>数组
    var bookPartArray: [MK_DataSource_ComickPartInfo_Protocol] {
        
        if let res = self.cachPartModelArr {
            return res
        }
        
        var res =  chapters.map { (dic) -> [MK_DataSource_DMZJ_PartModel] in
            guard let dicArr = dic["data"] as? [[String:Any]],
                let modelArr = [MK_DataSource_DMZJ_PartModel].deserialize(from: dicArr) as? [MK_DataSource_DMZJ_PartModel] else {
                    return []
            }
            return modelArr
            }.reduce([]) { (old, new) -> [MK_DataSource_DMZJ_PartModel] in
                var res = old
                res.append(contentsOf: new)
                return res
        }
        
        for index in 0..<res.count {
            res[index].bookId = self.id
        }
        
        return res
    }
    
    
}






/// 漫画<话>模型
struct MK_DataSource_DMZJ_PartModel : HandyJSON {
    
    var bag = DisposeBag()
    
    ///漫画<话>id
    var chapter_id:String = ""
    
    ///漫画话标题
    var chapter_title:String = ""
    
    ///更新时间(时间下标)
    var updatetime:Int = 0
    
    
    ///漫画<书>id
    var bookId:String = ""
    
    
    ///缓存--漫画<话>图片数组
    var cachImageArr:[String]?
    
}


extension MK_DataSource_DMZJ_PartModel : MK_DataSource_ComickPartInfo_Protocol {
    
    
    ///获取该<话>漫画Image URL 数组
    func getPartImageUrlStrArr(block: @escaping (([String]?) -> ())) {
        
        DMZJ_provider.rx
            .request(MK_DataSource_DMZJ_Target.getComicPartInfo(bookId, chapter_id))
            .mapJSON().subscribe(onSuccess: { (res) in
                
                guard let dic = res as? [String:Any],
                    let imageURLArr = dic["page_url"] as? [String] else{
                        block(nil)
                        return
                }
                block(imageURLArr)
        }) { (err) in
            block(nil)
        }.disposed(by: DMZJ_Bag)
        
    }
    
    ///<话>标题
    var partTitle: String {
        return chapter_title
    }
    
    
    
}


