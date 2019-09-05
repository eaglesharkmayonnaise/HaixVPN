//
//  IndexViewController.swift
//  Potatso
//
//  Created by LEI on 5/27/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//   com.touchingapp.potatso.tunnel
import Foundation
import PotatsoLibrary
//import Eureka
import Cartography
//import Eureka
private let kFormName = "name"
private let kFormDNS = "dns"
private let kFormProxies = "proxies"
private let kFormDefaultToProxy = "defaultToProxy"


class HomeVC : NSObject {
    
    // MARK: 更新vpn状态
    @objc func handleRefreshUI() {
        Manager.sharedManager.UPdateVPNStatus()
    }
    
    //安装数据库
    @objc func Managersetup() {
        Manager.sharedManager.setup()
        Manager.sharedManager.postMessage()
        //        self.setupstreamProxy()
    }
    
    
    // MARK: - Private Actions
    @objc func handleConnectButtonPressed() {
        //开启关闭vpn
        Manager.sharedManager.switchVPN()
    }
    
    
}

