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
    
    ///漫画<书>详情
    lazy var bookInfoV = { () -> MK_ComickI_BookInfoV in
        let res = MK_ComickI_BookInfoV()
        view.addSubview(res)
        return res
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bookInfoV.snp.makeConstraints { (make) in
            if let topOff = self.navigationController?.navigationBar.height{
                make.top.equalToSuperview().offset(topOff)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        MK_DataSource.share().comicBookInfoAction
            .execute((MK_DataSource.DataSourceType.DMZJ, "39033"))
            .subscribe(onNext: {[weak self] (res) in
                guard let sf = self else {return}
                sf.bookInfoV.model.value = res
                
            }).disposed(by: bag)
        
    }
    
}
