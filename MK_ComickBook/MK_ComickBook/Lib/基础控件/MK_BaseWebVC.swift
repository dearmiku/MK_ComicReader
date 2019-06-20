//
//  MK_BaseWebVC.swift
//  MK_IdPhotoPro
//
//  Created by 杨尚达 on 2019/5/6.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import SnapKit
import WebKit

///基础网页控件
class MK_BaseWebVC : MK_BaseVC {
    
    ///网页控件
    fileprivate lazy var webV = { () -> WKWebView in
        let res = WKWebView()
        view.addSubview(res)
        return res
    }()
    
    ///顶部导航栏
    lazy var topNavigationBar = { () -> UIView in
        let res = UIView()
        res.backgroundColor = MK_MainTopicColor
        view.addSubview(res)
        return res
    }()
    
    ///标题
    lazy var topTitleLa = { () -> UILabel in
        let res = UILabel()
        res.textColor = UIColor.white
        res.textAlignment = .center
        self.topNavigationBar.addSubview(res)
        return res
    }()
    
    ///返回按钮
    lazy var backBu = { () -> UIButton in
        let res = UIButton()
        res.tintColor = UIColor.white
        res.setImage(UIImage.init(named: "normal_back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        self.topNavigationBar.addSubview(res)
        return res
    }()
    
    
    var urlStr:String? {
        didSet{
            guard let res = urlStr,
                let fixStr = res.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed),
                let url = URL.init(string: fixStr) else {return}
            loadURL = url
            webV.load(URLRequest.init(url: url))
        }
    }
    
    fileprivate var loadURL:URL?
    
    ///消失回调Block
    var dismissBlock:(()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(MK_Device.navigationBarHight)
        }
        webV.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topNavigationBar.snp.bottom)
        }
        
        topTitleLa.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(KeyWindow.width * 0.7)
        }
        backBu.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(16)
        }
        
        ///标题订阅
        webV.rx.observe(String.self, #keyPath(WKWebView.title)).subscribe(onNext: {[weak self] (res) in
            guard let sf = self else {return}
            sf.topTitleLa.text = res
        }).disposed(by: bag)
        
        ///返回按钮订阅
        backBu.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let sf = self else {return}
            sf.dismiss(animated: true, completion: sf.dismissBlock)
        }).disposed(by: bag)
        
        
        if let url = loadURL {
            webV.load(URLRequest.init(url: url))
        }
        
    }
    
}
