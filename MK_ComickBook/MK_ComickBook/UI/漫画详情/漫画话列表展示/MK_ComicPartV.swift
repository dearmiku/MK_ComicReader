//
//  MK_ComicPartV.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/20.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


/// 漫画<话>展示控件
class MK_ComicPartV : UIView {
    
    var bag = DisposeBag()
    
    ///模型数组
    lazy var modelV = Variable<MK_DataSource_ComickBookInfo_Protocol?>.init(nil)
    
    
    ///工具栏
    lazy var toolBar = { () -> MK_ComicPartToolV in
        let res = MK_ComicPartToolV()
        addSubview(res)
        return res
    }()
    
    ///内容视图
    lazy var contenV = { () -> MK_ComicPartContentV in
        let res = MK_ComicPartContentV()
        addSubview(res)
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        toolBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        contenV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(toolBar.snp.bottom)
        }
        
        ///监听数据
        modelV.asObservable().subscribe(onNext: {[weak self] (res) in
            guard let sf = self,let model = res else {return}
            sf.contenV.modelArrV.value = model.bookPartArray
        }).disposed(by: bag)
        
        ///对排序方式订阅
        toolBar.orderType.asObservable().skip(1).subscribe(onNext: {[weak self] (res) in
            guard let sf = self,let model = sf.modelV.value else {return}
            switch res {
            ///正序
            case .positive:
                sf.contenV.modelArrV.value = model.bookPartArray.reversed()
            ///倒序
            case .inverted:
                sf.contenV.modelArrV.value = model.bookPartArray
            }
        }).disposed(by: bag)
        
        
        ///监听选中下标
        contenV.currentSelectIndex.asObservable().subscribe(onNext: {[weak self] (res) in
            guard let sf = self,
                let model = sf.modelV.value,
                let index = res else {return}
            
            let vc = MK_ComicReadVC.init(startIndex: index, bookModel: model)
            MK_MainNavigationV.currentShowNavigationVC?.pushViewController(vc, animated: true)
            
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
