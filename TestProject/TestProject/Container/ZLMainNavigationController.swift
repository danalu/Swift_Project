//
//  ZLMainNavigationController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/16.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ZLMainNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var popGestureTarget: Any?   ////用于自定义手势pop所用
    weak var currentShowVC: UIViewController?
    
    public static func initOnce() {
        let navigationBar = UINavigationBar.appearance()
        let image = UIImage.init(named: "navigationBarBg")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0.5, 0.5, 3, 0.5))
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
        
        var attr: [NSAttributedStringKey : Any] = Dictionary()
        let shadow: NSShadow = NSShadow()
        shadow.shadowOffset = CGSize.init()
        attr[NSAttributedStringKey.shadow] = shadow
        attr[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 17)
        attr[NSAttributedStringKey.foregroundColor] = UIColor.darkGray
        navigationBar.titleTextAttributes = attr
        
        let barButtonItem = UIBarButtonItem.appearance()
        var normalTextAttr: [NSAttributedStringKey : Any] = Dictionary()
        normalTextAttr[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 15)
        normalTextAttr[NSAttributedStringKey.foregroundColor] = UIColor.darkText
        barButtonItem.setTitleTextAttributes(normalTextAttr, for: UIControlState.normal)

        var hightlightedTextAttr: [NSAttributedStringKey : Any] = Dictionary()
        hightlightedTextAttr[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 15)
        hightlightedTextAttr[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
        barButtonItem.setTitleTextAttributes(hightlightedTextAttr, for: UIControlState.highlighted)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.view.backgroundColor = UIColor.white
        
        if let popGestureRecognizer = self.interactivePopGestureRecognizer {
            self.popGestureTarget = popGestureRecognizer.delegate
            self.interactivePopGestureRecognizer?.delegate = self;
            self.delegate = self
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: navigation
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    // MARK: navigationDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let baseViewController: ZLBaseViewController = viewController as? ZLBaseViewController {
            let shouldHidden = baseViewController.shouldHiddenNavigationBar()
            if (navigationController.isNavigationBarHidden != shouldHidden) {
                //之前的显示状态与新页面显示状态不一致，按照新页面的显示逻辑
                navigationController.setNavigationBarHidden(shouldHidden, animated: animated)
            }
        } else if (navigationController.isNavigationBarHidden) {
            //默认显示，如果不需要显示需要继承自ZLBaseViewController并设置shouldHiddenNavigationBar为YES.
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count == 1) {
            self.currentShowVC = nil
        } else {
            self.currentShowVC = viewController
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let baseViewController = fromVC as? ZLBaseViewController {
            let animatedTransitionObj = baseViewController.animationController(operation)
            return animatedTransitionObj
        }
        
        return nil
    }
    
    // MARK: UIGestureRecognizer
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.interactivePopGestureRecognizer) {
            return self.currentShowVC == self.topViewController
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //此处是允许系统的左边侧滑和当前页面其他手势是否同时生效.
        return false
    }
}
