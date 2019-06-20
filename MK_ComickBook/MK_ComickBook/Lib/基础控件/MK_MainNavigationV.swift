//
//  MK_MainNavigationV.swift
//  idPhotoAbroad
//
//  Created by MBP on 2018/2/7.
//  Copyright © 2018年 leqi. All rights reserved.
//

import UIKit
import RxSwift


class MK_MainNavigationV: UINavigationController {
    
    ///当前展示的NavigationVC
    static var currentShowNavigationVC:MK_MainNavigationV?
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///去除x导航栏下方黑线
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = MK_MainTopicColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MK_MainNavigationV.currentShowNavigationVC = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MK_MainNavigationV.currentShowNavigationVC = nil
    }
    
    
    
    ///获取处理好的NavigationController
    class func getSteFinishedNavigationContioner(rootViewController: UIViewController,title:String,imageName:String,textColor:UIColor)->MK_MainNavigationV {
        
        let resultVC = MK_MainNavigationV(rootViewController: rootViewController)
        
        rootViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:textColor], for: UIControl.State.selected)
        
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image=UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        rootViewController.tabBarItem.selectedImage=UIImage(named: imageName+"_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        
        return resultVC
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    ///状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if let vc = self.children.last as? MK_BaseVC{
            return vc.stateBarStyle
        }
        return UIStatusBarStyle.lightContent
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let res = super.popViewController(animated: animated)
        if let vc = viewControllers.last as? MK_BaseVC {
            navigationBar.setBackgroundImage(vc.navigationBarBackGroundIm, for: UIBarMetrics.default)
        }
        return res
    }
    
    
}

