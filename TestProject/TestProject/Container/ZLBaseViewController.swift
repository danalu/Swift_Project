//
//  ZLBaseViewController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/17.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ZLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldHiddenNavigationBar() -> Bool {
        return false
    }
    
    func animationController(_ operation: UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning? {
        return nil
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
