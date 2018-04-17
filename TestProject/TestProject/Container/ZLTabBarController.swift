//
//  ZLTabBarController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/16.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ZLTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor.lightGray
        self.delegate = self as? UITabBarControllerDelegate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tool
    func setupAllTabBarItems() -> Void {
        var controller1 = UIViewController()
        
    }
    
    func addChildViewController(_ viewcontroller: UIViewController, title: String, imageName: String, selectedImage: String) -> Void {
        viewcontroller.tabBarItem.title = title;
        viewcontroller.tabBarItem.image = UIImage.init(named: imageName)
        viewcontroller.tabBarItem.selectedImage = UIImage.init(named: selectedImage)
        
        //正常的字体颜色
//        NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
//        normalAttr[NSFontAttributeName] = [UIFont SCWithType:PingFangType_Regular size:9];
//        normalAttr[NSForegroundColorAttributeName] = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
//        [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
        var normalAttr: [String: Any] = Dictionary()
        normalAtt[]
        
        
        //选中字体颜色
//        NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
//        selectedAttr[NSFontAttributeName] = [UIFont SCWithType:PingFangType_Regular size:9];
//        selectedAttr[NSForegroundColorAttributeName] = [UIColor getCommonColorWithColorType:ColorMainType];
//        [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

        
        var nav: ZLMainNavigationController = ZLMainNavigationController(rootViewController: viewcontroller)
        addChildViewController(nav)
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
