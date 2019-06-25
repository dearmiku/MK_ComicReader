//
//  MK_ComicReadVC.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/21.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


/// 漫画阅读器
class MK_ComicReadVC : MK_BaseVC {
    
    ///当前下标
    lazy var currentIndex = Variable<Int>.init(0)
    
    ///漫画<书>模型
    var bookModel:MK_DataSource_ComickBookInfo_Protocol
    
    
    ///内容视图
    lazy var contentV = { () -> MK_ComicReadContentV in
        let res = MK_ComicReadContentV.init(delegate: self, index: self.currentIndex.value)
        view.addSubview(res)
        return res
    }()
    
    ///状态栏
    lazy var stateBar = { () -> MK_ComicReadStateBar in
        let res = MK_ComicReadStateBar()
        view.addSubview(res)
        return res
    }()
    
    init(startIndex:Int,bookModel:MK_DataSource_ComickBookInfo_Protocol){
        
        self.bookModel = bookModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.currentIndex.value = startIndex
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isShowNavigationBar = false
        
        contentV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stateBar.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-MK_Device.safeArre.bottom)
            make.width.equalTo(200)
            make.height.equalTo(36)
        }
        
        
        ///对阅读情况进行监听
        contentV.currentShowIndex.asObservable().subscribe(onNext: {[weak self] (para) in
            guard let sf = self else {return}
            let (current,total) = para
            sf.stateBar.readStateLa.text = "\(current)/\(total)"
        }).disposed(by: bag)
        
        
        ///订阅当前阅读Index
        contentV.currentReadIndex
            .asObservable()
            .subscribe(onNext: {[weak self] (res) in
                
                guard let sf = self else {return}
                let currentPart = sf.bookModel.bookPartArray[res]
                sf.stateBar.partTitleLa.text = currentPart.partTitle
            }).disposed(by: bag)
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MK_ComicReadVC : MK_ComicReadContentV_Protocol {
    
    func getIndexComicPart(index: Int) -> MK_DataSource_ComickPartInfo_Protocol? {
        guard index >= 0, index < bookModel.bookPartArray.count else {
            return nil
        }
        return bookModel.bookPartArray[index]
    }
    
    
    
    
}
