//
//  ZLTabBarController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/16.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ZLTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZLMainNavigationController.initOnce()

        // Do any additional setup after loading the view.
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        self.delegate = self
        
        setupAllTabBarItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tool
    func setupAllTabBarItems() -> Void {
        let controller1 = ZLMainViewController()
        addChildViewController(controller1, title: "首页", imageName: "tabbar_home_n", selectedImage: "tabbar_home_h")
        
        let controller2 = ZLBaseViewController()
        addChildViewController(controller2, title: "资讯", imageName: "tabbar_item_discover_normal", selectedImage: "tabbar_item_discover_highlight")
        
        let controller3 = ZLBaseViewController()
        addChildViewController(controller3, title: "球鞋", imageName: "tabbar_shoes_n", selectedImage: "tabbar_shoes_h")
        
        let controller4 = ZLBaseViewController()
        addChildViewController(controller4, title: "购物", imageName: "tabbar_item_shoppingbag_normal", selectedImage: "tabbar_item_shoppingbag_highlight")
        
        let controller5 = ZLBaseViewController()
        addChildViewController(controller5, title: "我的", imageName: "tabbar_item_personcenter_normal", selectedImage: "tabbar_item_personcenter_highlight")
    }
    
    func addChildViewController(_ viewcontroller: UIViewController, title: String, imageName: String, selectedImage: String) -> Void {
        viewcontroller.tabBarItem.title = title;
        viewcontroller.tabBarItem.image = UIImage.init(named: imageName)
        viewcontroller.tabBarItem.selectedImage = UIImage.init(named: selectedImage)
        
        //正常的字体颜色
        var normalAttr: [NSAttributedStringKey: Any] = Dictionary()
        normalAttr[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 10)
        normalAttr[NSAttributedStringKey.foregroundColor] = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        viewcontroller.tabBarItem.setTitleTextAttributes(normalAttr, for: UIControlState.normal)
        
        //选中字体颜色
        var selectedAttr: [NSAttributedStringKey: Any] = Dictionary()
        selectedAttr[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 10)
        selectedAttr[NSAttributedStringKey.foregroundColor] = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        viewcontroller.tabBarItem.setTitleTextAttributes(selectedAttr, for: UIControlState.selected)
        
        //使用原图.
        viewcontroller.tabBarItem.image = UIImage.init(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        viewcontroller.tabBarItem.selectedImage = UIImage.init(named: selectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let nav: ZLMainNavigationController = ZLMainNavigationController(rootViewController: viewcontroller)
        addChildViewController(nav)
    }
    
    // MARK: UITabBarDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //选中了当前的tab页面.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
