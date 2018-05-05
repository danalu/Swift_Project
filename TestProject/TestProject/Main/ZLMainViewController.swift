//
//  ZLMainViewController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/17.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit
import SnapKit

struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

class ZLMainViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页";
        // Do any additional setup after loading the view.
        
        let button: UIButton = UIButton()
        self.view.addSubview(button)
        button.backgroundColor = UIColor.blue
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testError() throws -> String {
        let random = 123
        
        return "123434"
    }
    
    
    
    // MARK: event
    @objc func buttonClicked()  {
//        let domainChangeController = ZLDomainSwitchController()
//        self.navigationController?.pushViewController(domainChangeController, animated: true)
        
//        var a = 13
//        var b = 54
//        swapValue(&a, second: &b)
//        print(a,b)
        
        let a1: Vector2D = Vector2D(x: 10, y: 10)
        let a2: Vector2D = Vector2D(x: 15, y: 23)
        let a3 = a1 + a2
        print(a3)
    }
    
    func swapValue<T: Equatable>(_ first: inout T, second: inout T) {
        let temp = first
        first = second
        second = temp
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
