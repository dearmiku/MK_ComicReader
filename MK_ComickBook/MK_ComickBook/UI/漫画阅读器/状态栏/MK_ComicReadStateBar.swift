//
//  MK_ComicReadStateBar.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/24.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


/// 漫画书--状态栏
class MK_ComicReadStateBar : UIView {
    
    var bag = DisposeBag()
    
    ///时间格式
    lazy var formate = { () -> DateFormatter in
        let res = DateFormatter()
        res.dateFormat = "HH:mm"
        return res
    }()
    
    
    /// 时间La
    lazy var timeLa = { () -> UILabel in
        let res = UILabel()
        res.textColor = UIColor.white
        addSubview(res)
        return res
    }()
    
    ///阅读状态La
    lazy var readStateLa = { () -> UILabel in
        let res = UILabel()
        res.textColor = UIColor.white
        addSubview(res)
        return res
    }()
    
    ///漫画<话>名称La
    lazy var partTitleLa = { () -> UILabel in
        let res = UILabel()
        res.textColor = UIColor.white
        addSubview(res)
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
        
        timeLa.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-6)
            make.width.equalTo(66)
        }
        partTitleLa.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        readStateLa.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(timeLa.snp.left).offset(-10)
        }
        
        ///订阅时间
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (_) in
            
                guard let sf = self else {return}
                let newStr = sf.formate.string(from: Date())
                sf.timeLa.text = newStr
                
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
