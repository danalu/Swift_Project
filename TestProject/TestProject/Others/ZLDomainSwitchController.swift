//
//  ZLDomainSwitchController.swift
//  TestProject
//
//  Created by DanaLu on 2018/4/18.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

class ZLDomainSwitchController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableViewDelegate & UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellIdenfifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell?.textLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
            cell?.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        let domainType = DomainType(rawValue: indexPath.row)
        let domainInfo = ZLDomainManager.getDomainModel(domainType: domainType!)
        if domainInfo != nil {
            cell?.detailTextLabel?.text = domainInfo?.domain
        }
        
        var title: String!
        switch domainType! {
        case .Product:
            title = "生产环境"
        case .PreProdduct:
            title = "预生产环境"
        case .Test:
            title = "测试环境"
        case .Custom:
            title = "自定义域名"
        }
        cell?.textLabel?.text = title
        
        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //test.
        if (DomainType(rawValue: indexPath.row) == DomainType.Product) {
            //发起网络请求.
            ZLTestService.requestTestInfo(.get, parameter: nil) { (response, error) in
                print(response, error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


