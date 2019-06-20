//
//  MK_DataSource_DMZJ_Model.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

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
        
        return chapters.map { (dic) -> [MK_DataSource_DMZJ_PartModel] in
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
        
    }
    
    
}






/// 漫画<话>模型
struct MK_DataSource_DMZJ_PartModel : HandyJSON {
    
    ///漫画话id
    var chapter_id:String = ""
    
    ///漫画话标题
    var chapter_title:String = ""
    
    ///更新时间(时间下标)
    var updatetime:Int = 0
    
}


extension MK_DataSource_DMZJ_PartModel : MK_DataSource_ComickPartInfo_Protocol {
    
    var partTitle: String {
        return chapter_title
    }
    
    
    
}


