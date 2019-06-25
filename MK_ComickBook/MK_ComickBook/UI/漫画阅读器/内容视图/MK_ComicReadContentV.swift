//
//  MK_ComicReadContentV.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/21.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift
import Kingfisher

///漫画内容视图协议
protocol MK_ComicReadContentV_Protocol : class {
    
    ///获取指定Index下的漫画<话>
    func getIndexComicPart(index:Int)->MK_DataSource_ComickPartInfo_Protocol?
}


///漫画阅读内容视图
class MK_ComicReadContentV : UICollectionView {
    
    let cellID = "cellID"
    
    var bag = DisposeBag()
    
    ///当前阅读器状态
    var state:Variable<State>
    
    ///展示图片数组
    var currentImageArrV = Variable<[[String]]>.init([])
    
    ///当前阅读下标
    var currentReadIndex = Variable<Int>.init(0)
    
    
    ///当前展示(当前页数,总页数)
    lazy var currentShowIndex = Variable<(Int,Int)>.init((0,0))
    ///collectionView即将展示index
    fileprivate lazy var willShowIndex = Variable<IndexPath?>.init(nil)
    ///collectionView结束展示index
    fileprivate lazy var endShowIndex = Variable<IndexPath?>.init(nil)
    
    
    ///0 section 的<话>下标
    fileprivate var zeroSectionIndex:Int = 0
    
    
    ///代理
    weak var dataDelegate:MK_ComicReadContentV_Protocol?
    
    
    init(delegate:MK_ComicReadContentV_Protocol,index:Int){
        
        dataDelegate = delegate
        state = Variable<State>.init(MK_ComicReadContentV.State.setUp(index))
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = KeyWindow.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        backgroundColor = UIColor.black
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.register(Item.self, forCellWithReuseIdentifier: cellID)
        self.delegate = self
        self.dataSource = self
        
        ///对阅读器状态进行订阅
        state.asObservable().subscribe(onNext: {[weak self] (res) in
            guard let sf = self else {return}
            
            switch res {
            ///错误
            case .error:
                MKLogInfo("漫画阅读器 发生错误")
                
            ///启动阅读
            case let .setUp(startIndex):
                MKLogInfo("漫画阅读器 启动阅读\(startIndex)")
                
                if let model = sf.dataDelegate?.getIndexComicPart(index: startIndex) {
                    ///加载数据
                    model.getPartImageUrlStrArr(block: { (arr) in
                        guard let imArr = arr else {
                            MKLogInfo("漫画请求错误")
                            return
                        }
                        
                        sf.currentImageArrV.value = [imArr]
                        sf.zeroSectionIndex = startIndex
                        sf.currentShowIndex.value = (1,imArr.count)
                        sf.currentReadIndex.value = startIndex
                        sf.reloadData()
                        
                        sf.state.value = .reading
                        
                        ///如果当前<话>只有一页 直接加载下一话
                        if imArr.count == 1 {
                            sf.state.value = .loadNextDate(startIndex - 1)
                        }
                        
                        ///加载前一<话>数据
                        sf.state.value = .loadPreviousDate(startIndex + 1)
                    })
                }
                
                
            ///加载下一页数据
            case let .loadNextDate(nextIndex):
                MKLogInfo("加载下一页数据")
                if let model = sf.dataDelegate?.getIndexComicPart(index: nextIndex) {
                    ///加载数据
                    model.getPartImageUrlStrArr(block: { (arr) in
                        guard let imArr = arr else {
                            MKLogInfo("漫画请求错误")
                            sf.state.value = .error
                            return
                        }
                        
                        sf.currentImageArrV.value.append(imArr)
                        sf.reloadData()
                        
                        sf.state.value = .reading
                    })
                }
                
                break
                
            ///加载前一页数据
            case let .loadPreviousDate(preIndex):
                
                MKLogInfo("加载上一页数据")
                if let model = sf.dataDelegate?.getIndexComicPart(index: preIndex) {
                    ///加载数据
                    model.getPartImageUrlStrArr(block: { (arr) in
                        guard let imArr = arr else {
                            MKLogInfo("漫画请求错误")
                            sf.state.value = .error
                            return
                        }
                        
                        sf.currentImageArrV.value.insert(imArr, at: 0)
                        sf.reloadData()
                        sf.zeroSectionIndex += 1
                        sf.state.value = .reading
                    })
                }
                break
                
                
            case .reading:
                break
            }
            
        }).disposed(by: bag)
        
        
        ///对endIndex进行订阅
        endShowIndex.asObservable().subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let willShowIndex = sf.willShowIndex.value,
                let endIndex = res,
                endIndex != willShowIndex else {return}
            
            ///漫画阅读情况
            let currentShowArr = sf.currentImageArrV.value[willShowIndex.section]
            let totalNum = currentShowArr.count
            sf.currentShowIndex.value = (willShowIndex.row + 1, totalNum)
            
            ///漫画当前阅读下表
            let currentShowIndex = sf.zeroSectionIndex - willShowIndex.section
            if currentShowIndex != sf.currentReadIndex.value {
                sf.currentReadIndex.value = currentShowIndex
            }
            
            ///加载下一个
            if willShowIndex.section == sf.currentImageArrV.value.count - 1,
                willShowIndex.row == sf.currentImageArrV.value[willShowIndex.section].count - 1 {
                
                switch sf.state.value {
                case .loadNextDate(_):
                    break
                default:
                    sf.state.value = .loadNextDate(sf.zeroSectionIndex - sf.currentImageArrV.value.count)
                    break
                }
            }
            
            ///加载上一个
            if willShowIndex.section == 0,willShowIndex.row == 0 {
                
                switch sf.state.value {
                case .loadPreviousDate(_):
                    break
                default:
                    sf.state.value = .loadPreviousDate(sf.zeroSectionIndex - sf.currentImageArrV.value.count)
                    break
                }
            }
            
        }).disposed(by: bag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MK_ComicReadContentV : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentImageArrV.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentImageArrV.value[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Item
        
        if let url = URL.init(string: currentImageArrV.value[indexPath.section][indexPath.row]){
            cell.showImageV.kf.setImage(with: ImageResource.init(downloadURL: url))
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willShowIndex.value = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        endShowIndex.value = indexPath
    }
    
}


extension MK_ComicReadContentV {
    
    class Item : UICollectionViewCell {
        
        ///漫画展示
        lazy var showImageV = { () -> UIImageView in
            let res = UIImageView()
            res.contentMode = .scaleAspectFit
            addSubview(res)
            return res
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            showImageV.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}



extension MK_ComicReadContentV {
    
    enum State {
        
        ///失败
        case error
        
        ///阅读中
        case reading
        
        ///初始化(初始化下标)
        case setUp(Int)
        
        ///加载下一页数据
        case loadNextDate(Int)
        
        ///加载上一页数据
        case loadPreviousDate(Int)
    }
    
}
