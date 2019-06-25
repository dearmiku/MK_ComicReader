//
//  MK_ComicPartToolV.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/20.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


/// 漫画<话>工具
class MK_ComicPartToolV : UIView {
    
    var bag = DisposeBag()
    
    ///排序方式(默认倒序)
    lazy var orderType = Variable<OrderType>.init(MK_ComicPartToolV.OrderType.inverted)
    
    /// 正序-倒序 按钮
    lazy var orderBu = { () -> UIButton in 
        let res = UIButton()
        res.setTitleColor(MK_MainTopicColor, for: UIControl.State.normal)
        addSubview(res)
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        orderBu.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-36)
            make.centerY.equalToSuperview()
        }
        
        
        ///对序列进行订阅
        orderType.asObservable().subscribe(onNext: {[weak self] (res) in
            guard let sf = self else {return}
            switch res {
            ///正序
            case .positive:
                sf.orderBu.setTitle("正序", for: UIControl.State.normal)
            ///倒序
            case .inverted:
                sf.orderBu.setTitle("倒序", for: UIControl.State.normal)
            }
        }).disposed(by: bag)
        
        ///订阅排序按钮点击
        orderBu.rx.tap.map {[weak self] (_) -> OrderType in
            guard let sf = self else {
                return OrderType.inverted
            }
            switch sf.orderType.value {
            case .positive:
                return .inverted
            case .inverted:
                return .positive
            }
        }.bind(to: orderType).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MK_ComicPartToolV {
    
    ///排序方式
    enum OrderType {
        
        ///正序
        case positive
        
        ///倒序
        case inverted
    }
    
}
