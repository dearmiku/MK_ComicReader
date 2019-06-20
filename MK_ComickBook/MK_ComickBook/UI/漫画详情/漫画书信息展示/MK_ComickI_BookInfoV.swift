//
//  MK_ComickI_BookInfoV.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift
import RxCocoa
import Kingfisher


/// 漫画<书>信息 展示
class MK_ComickI_BookInfoV : UIView {
    
    var bag = DisposeBag()
    
    ///数据模型
    lazy var model = Variable<MK_DataSource_ComickBookInfo_Protocol?>.init(nil)
    
    
    ///漫画封面图
    lazy var comicBookImageV = { () -> UIImageView in
        let res = UIImageView()
        addSubview(res)
        return res
    }()
    
    ///漫画名称
    lazy var comicTitleLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 20)
        addSubview(res)
        return res
    }()
    
    
    ///漫画作者
    lazy var comicAuthorLa = { () -> UILabel in
        let res = UILabel()
        addSubview(res)
        return res
    }()
    
    
    ///漫画描述
    lazy var comicDesLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 16)
        res.textColor = UIColor(red:0.43, green:0.42, blue:0.43, alpha:1.00)
        res.numberOfLines = 0
        addSubview(res)
        return res
    }()
    
    init(){
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        comicBookImageV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(36)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(200)
        }
        comicTitleLa.snp.makeConstraints { (make) in
            make.left.equalTo(comicBookImageV.snp.right).offset(36)
            make.top.equalTo(comicBookImageV)
        }
        comicAuthorLa.snp.makeConstraints { (make) in
            make.left.equalTo(comicTitleLa)
            make.top.equalTo(comicTitleLa.snp.bottom).offset(36)
        }
        comicDesLa.snp.makeConstraints { (make) in
            make.left.equalTo(comicAuthorLa)
            make.right.equalToSuperview().offset(-36)
            make.top.equalTo(comicAuthorLa.snp.bottom).offset(36)
        }
        
        
        ///模型订阅
        model.asObservable().subscribe(onNext: {[weak self] (res) in
            guard let sf = self,let model = res else {return}
            
            MK_DataSource.share().comicImageAction
                .execute((model.sourceType,model.bookCoverImageURLStr))
                .subscribe(onNext: { (res) in
                    guard let im = res else {return}
                    sf.comicBookImageV.image = im
                    sf.comicBookImageV.snp.updateConstraints({ (make) in
                        make.height.equalTo(200)
                        make.width.equalTo(200 * im.size.width / im.size.height)
                    })
                }).disposed(by: sf.bag)
            
            
            sf.comicTitleLa.text = model.bookName
            sf.comicAuthorLa.text = "作者:\(model.bookAuthor)"
            sf.comicDesLa.text = model.bookDes
            
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
