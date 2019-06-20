//
//  MK_BaseVC.swift
//  MK_VideoGather
//
//  Created by MBP on 2018/4/13.
//  Copyright © 2018年 MBP. All rights reserved.
//

import UIKit
import RxSwift

///基础控件
class MK_BaseVC:UIViewController {
    
    public var bag = DisposeBag.init()
    
    ///是否显示NavigationBar
    var isShowNavigationBar = true
    
    ///状态栏样式
    var stateBarStyle:UIStatusBarStyle {
        get{
            return UIStatusBarStyle.lightContent
        }
    }
    
    ///navigationBar图像
    var navigationBarBackGroundIm:UIImage? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "normal_back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigationBack))
        }
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(navigationBarBackGroundIm, for: UIBarMetrics.default)
        self.navigationController?.setNavigationBarHidden(!isShowNavigationBar, animated: true)
    }
    
    public override var prefersStatusBarHidden: Bool{
        return false
    }
    
    @objc private func navigationBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    ///状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return stateBarStyle
    }
    
    deinit {
        MKLogInfo("控制器完成回收~")
    }
}
