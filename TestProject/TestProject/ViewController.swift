//
//  ViewController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/16.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(test(_:)), for: .touchUpInside)
    }
    
    @objc func test(_ sender: UIButton)  {
        
    }
    
    func testError() throws -> String {
        let random = 123
        throw NSError(domain: "test", code: 1000, userInfo: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

