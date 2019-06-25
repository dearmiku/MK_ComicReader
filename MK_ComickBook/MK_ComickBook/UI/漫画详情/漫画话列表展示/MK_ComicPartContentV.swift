//
//  MK_ComicPartContentV.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/20.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


/// 漫画<话>内容视图
class MK_ComicPartContentV : UICollectionView {
    
    var bag = DisposeBag()
    
    let cellID = "cellID"
    
    
    ///模型数组
    lazy var modelArrV = Variable<[MK_DataSource_ComickPartInfo_Protocol]>.init([])
    
    
    ///当前选中下标
    lazy var currentSelectIndex = Variable<Int?>.init(nil)
    
    
    init(){
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: KeyWindow.width, height: 50)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.backgroundColor = MK_Normal_BackgroundColor
        
        self.register(Item.self, forCellWithReuseIdentifier: cellID)
        self.delegate = self
        self.dataSource = self
        
        modelArrV.asObservable().subscribe(onNext: {[weak self] (_) in
            guard let sf = self else {return}
            sf.reloadData()
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension MK_ComicPartContentV : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArrV.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Item
        cell.model = modelArrV.value[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectIndex.value = indexPath.row
    }
    
}



extension MK_ComicPartContentV {
    
    ///<话>单元格
    class Item : UICollectionViewCell {
        
        ///话标题
        lazy var titleLa = { () -> UILabel in
            let res = UILabel()
            addSubview(res)
            return res
        }()
        
        
        ///模型
        var model:MK_DataSource_ComickPartInfo_Protocol? {
            didSet{
                guard let res = model else {return}
                
                titleLa.text = res.partTitle
            }
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            titleLa.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(36)
                make.centerY.equalToSuperview()
            }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

