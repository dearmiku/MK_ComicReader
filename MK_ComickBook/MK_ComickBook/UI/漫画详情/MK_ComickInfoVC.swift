//
//  MK_ComickInfoVC.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit


/// 漫画详情界面
class MK_ComickInfoVC : MK_BaseVC {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MK_DataSource.share().comicBookInfoAction.execute((MK_DataSource.DataSourceType.DMZJ, "39033")).subscribe(onNext: { (res) in
            MKLogInfo(res)
        }).disposed(by: bag)
        
    }
    
}
