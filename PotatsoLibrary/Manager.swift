//
//  Manager.swift
//  Potatso
//
//  Created by LEI on 4/7/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//


import PotatsoBase

import KissXML
import NetworkExtension
import ICSMainFramework
import MMWormhole

public enum ManagerError: Error {
    case invalidProvider
    case vpnStartFail
}

public enum VPNStatus {
    case off
    case connecting
    case on
    case disconnecting
}


public let kDefaultGroupIdentifier = "defaultGroup"
public let kDefaultGroupName = "defaultGroupName"
private let statusIdentifier = "status"
public let kProxyServiceVPNStatusNotification = "kProxyServiceVPNStatusNotification"


open class Manager {
    
    open static let sharedManager = Manager()
    
    open fileprivate(set) var vpnStatus = VPNStatus.off {
        didSet {
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        }
    }
    
    open let wormhole = MMWormhole(applicationGroupIdentifier: Potatso.sharedGroupIdentifier(), optionalDirectory: "wormhole")
    
    var observerAdded: Bool = false
    
    //    open var defaultConfigGroup: ConfigurationGroup {
    //        return getDefaultConfigGroup()
    //    }
    
    fileprivate init() {
        loadProviderManager { (manager) -> Void in
            if let manager = manager {
                self.updateVPNStatus(manager)
            }
        }
        addVPNStatusObserver()
    }
    
    func addVPNStatusObserver() {
        guard !observerAdded else{
            return
        }
        loadProviderManager { [unowned self] (manager) -> Void in
            if let manager = manager {
                self.observerAdded = true
                NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: manager.connection, queue: OperationQueue.main, using: { [unowned self] (notification) -> Void in
                    self.updateVPNStatus(manager)
                })
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func updateVPNStatus(_ manager: NEVPNManager) {
        switch manager.connection.status {
        case .connected:
            self.vpnStatus = .on
            self.lianjieshang()
            
        case .connecting, .reasserting:
            self.vpnStatus = .connecting
            
        case .disconnecting:
            self.vpnStatus = .disconnecting
            
        case .disconnected, .invalid:
            self.weilianjie()
            self.vpnStatus = .off
            
        }
    }
    
    //连接成功
    func lianjieshang() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "连接成功"),
                                        object: nil, userInfo: nil)
        let userdefaults = UserDefaults.standard
        userdefaults.set("1", forKey:"UB判断连接");
        userdefaults.synchronize()
    }
    
    //连接失败
    func weilianjie() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "连接失败"),
                                        object: nil, userInfo: nil)
        let userdefaults = UserDefaults.standard
        userdefaults.set("0", forKey:"UB判断连接");
        userdefaults.set("0" , forKey: "连接时间")
        userdefaults.set("0" , forKey: "上传流量")
        userdefaults.set("0" , forKey: "下载流量")
        userdefaults.synchronize()
    }
    
    
    //更新vpn状态
    open func UPdateVPNStatus(_ completion: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        loadProviderManager { [unowned self] (manager) in
            if let manager = manager {
                self.updateVPNStatus(manager)
            }
            let current = self.vpnStatus
            guard current != .connecting && current != .disconnecting else {
                return
            }
            
        }
    }
    
    
    
    open func switchVPN(_ completion: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        loadProviderManager { [unowned self] (manager) in
            if let manager = manager {
                self.updateVPNStatus(manager)
            }
            let current = self.vpnStatus
            guard current != .connecting && current != .disconnecting else {
                return
            }
            if current == .off {
                self.startVPN { (manager, error) -> Void in
                    completion?(manager, error)
                }
            }else {
                self.stopVPN()
                completion?(nil, nil)
            }
            
        }
    }
    
    open func switchVPNFromTodayWidget(_ context: NSExtensionContext) {
        if let url = URL(string: "yuanjin://switch") {
            context.open(url, completionHandler: nil)
        }
    }
    
    open func setup() {
        do {
            try copyGEOIPData()
        }catch{
            print("copyGEOIPData fail")
        }
        do {
            try copyTemplateData()
        }catch{
            print("copyTemplateData fail")
        }
    }
    
    func copyGEOIPData() throws {
        guard let fromURL = Bundle.main.url(forResource: "GeoLite2-Country", withExtension: "mmdb") else {
            return
        }
        let toURL = Potatso.sharedUrl().appendingPathComponent("GeoLite2-Country.mmdb")
        if FileManager.default.fileExists(atPath: fromURL.path) {
            if FileManager.default.fileExists(atPath: toURL.path) {
                try FileManager.default.removeItem(at: toURL)
            }
            try FileManager.default.copyItem(at: fromURL, to: toURL)
        }
    }
    
    func copyTemplateData() throws {
        guard let bundleURL = Bundle.main.url(forResource: "template", withExtension: "bundle") else {
            return
        }
        let fm = FileManager.default
        let toDirectoryURL = Potatso.sharedUrl().appendingPathComponent("httptemplate")
        if !fm.fileExists(atPath: toDirectoryURL.path) {
            try fm.createDirectory(at: toDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        for file in try fm.contentsOfDirectory(atPath: bundleURL.path) {
            let destURL = toDirectoryURL.appendingPathComponent(file)
            let dataURL = bundleURL.appendingPathComponent(file)
            if FileManager.default.fileExists(atPath: dataURL.path) {
                if FileManager.default.fileExists(atPath: destURL.path) {
                    try FileManager.default.removeItem(at: destURL)
                }
                try fm.copyItem(at: dataURL, to: destURL)
            }
        }
    }
    
    open func regenerateConfigFiles() throws {
        try generateGeneralConfig()
        try generateSocksConfig()
        try generateShadowsocksConfig()
        try generateHttpProxyConfig()
    }
    
}

extension Manager {
    
    
    func generateGeneralConfig() throws {
        let confURL = Potatso.sharedGeneralConfUrl()
        let json: NSDictionary = ["dns":  "" ]
        try json.jsonString()?.write(to: confURL, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func generateSocksConfig() throws {
        let root = XMLElement.element(withName: "antinatconfig") as! XMLElement
        let interface = XMLElement.element(withName: "interface", children: nil, attributes: [XMLElement.attribute(withName: "value", stringValue: "127.0.0.1") as! DDXMLNode]) as! XMLElement
        root.addChild(interface)
        
        let port = XMLElement.element(withName: "port", children: nil, attributes: [XMLElement.attribute(withName: "value", stringValue: "0") as! DDXMLNode])  as! XMLElement
        root.addChild(port)
        
        let maxbindwait = XMLElement.element(withName: "maxbindwait", children: nil, attributes: [XMLElement.attribute(withName: "value", stringValue: "10") as! DDXMLNode]) as! XMLElement
        root.addChild(maxbindwait)
        
        
        let authchoice = XMLElement.element(withName: "authchoice") as! XMLElement
        let select = XMLElement.element(withName: "select", children: nil, attributes: [XMLElement.attribute(withName: "mechanism", stringValue: "anonymous") as! DDXMLNode])  as! XMLElement
        
        authchoice.addChild(select)
        root.addChild(authchoice)
        
        let filter = XMLElement.element(withName: "filter") as! XMLElement
//        if let upstreamProxy = upstreamProxy {
            let chain = XMLElement.element(withName: "chain", children: nil, attributes: [XMLElement.attribute(withName: "name", stringValue: "upstreamProxy.name") as! DDXMLNode]) as! XMLElement
//            switch upstreamProxy.type {
//            case .Shadowsocks:
                let uriString = "socks5://127.0.0.1:${ssport}"
                let uri = XMLElement.element(withName: "uri", children: nil, attributes: [XMLElement.attribute(withName: "value", stringValue: uriString) as! DDXMLNode]) as! XMLElement
                chain.addChild(uri)
                let authscheme = XMLElement.element(withName: "authscheme", children: nil, attributes: [XMLElement.attribute(withName: "value", stringValue: "anonymous") as! DDXMLNode]) as! XMLElement
                chain.addChild(authscheme)
//            default:
//                break
//            }
            root.addChild(chain)
//        }
        
        let accept = XMLElement.element(withName: "accept") as! XMLElement
        filter.addChild(accept)
        root.addChild(filter)
        
        let socksConf = root.xmlString
        try socksConf.write(to: Potatso.sharedSocksConfUrl(), atomically: true, encoding: String.Encoding.utf8)
    }
    
    func generateShadowsocksConfig() throws {
        let confURL = Potatso.sharedProxyConfUrl()
        var content = ""
        let ssinfo = UserDefaults.standard
        let tResult = ssinfo.dictionary(forKey: "AryaLineConfiguration") as![String:Any]
        let arr = ["host": tResult["hostname"] ?? "" , "port": NSString(format: "%@" ,  tResult["port"] as! CVarArg), "password": tResult["passwd"] ?? "", "authscheme":  tResult["method"] ?? "", "ota": "", "protocol":  tResult["protocol"] ?? "", "obfs":  tResult["obfs"] ?? "", "obfs_param":   tResult["obfs_param"] ?? ""] as [String : Any]
        do {
            //let data = try JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted)
            //content = NSString(data: data, encoding: NSUTF8StringEncoding.rawValue) ?? ""
            let data = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
            content = String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        //        }
        try content.write(to: confURL, atomically: true, encoding: String.Encoding.utf8)
    }
    
    
    func generateHttpProxyConfig() throws {
        let rootUrl = Potatso.sharedUrl()
        let confDirUrl = rootUrl.appendingPathComponent("httpconf")
        let templateDirPath = rootUrl.appendingPathComponent("httptemplate").path
        let temporaryDirPath = rootUrl.appendingPathComponent("httptemporary").path
        let logDir = rootUrl.appendingPathComponent("log").path
        let maxminddbPath = Potatso.sharedUrl().appendingPathComponent("GeoLite2-Country.mmdb").path
        let userActionUrl = confDirUrl.appendingPathComponent("potatso.action")
        for p in [confDirUrl.path, templateDirPath, temporaryDirPath, logDir] {
            if !FileManager.default.fileExists(atPath: p) {
                _ = try? FileManager.default.createDirectory(atPath: p, withIntermediateDirectories: true, attributes: nil)
            }
        }
        var mainConf: [String: AnyObject] = [:]
        if let path = Bundle.main.path(forResource: "proxy", ofType: "plist"), let defaultConf = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            mainConf = defaultConf
        }
        mainConf["confdir"] = confDirUrl.path as AnyObject?
        mainConf["templdir"] = templateDirPath as AnyObject?
        mainConf["logdir"] = logDir as AnyObject?
        mainConf["mmdbpath"] = maxminddbPath as AnyObject?
        mainConf["global-mode"] = 1 as AnyObject?
        mainConf["debug"] = 1024+65536+1 as AnyObject?
        mainConf["actionsfile"] = userActionUrl.path as AnyObject?
        
        let mainContent = mainConf.map { "\($0) \($1)"}.joined(separator: "\n")
        try mainContent.write(to: Potatso.sharedHttpProxyConfUrl(), atomically: true, encoding: String.Encoding.utf8)
        
        //规则组添加
        var actionContent: [String] = ["{+forward-rule}",
                                       "IP-CIDR,192.168.0.0/16,DIRECT",
                                       "IP-CIDR,10.0.0.0/8,DIRECT",
                                       "IP-CIDR,127.0.0.0/8,DIRECT",
                                       "IP-CIDR,224.0.0.0/8,DIRECT",
                                       "IP-CIDR,169.254.0.0/16,DIRECT",
                                       "IP-CIDR,100.64.0.0/10,DIRECT",
                                       "DOMAIN,.*instagram*.,PROXY",
                                       "DOMAIN,.Slack*.,PROXY",
                                       //slack
                                        "DOMAIN-SUFFIX,slack-edge.com,PROXY",
                                        "DOMAIN-SUFFIX,slack.com,PROXY",
                                        "DOMAIN-SUFFIX,slack-msgs.com,PROXY",
                                        //proxy
                                        "DOMAIN,.*youtube*.,PROXY",
                                        "DOMAIN-SUFFIX,youtubei.googleapis.com,PROXY",
                                        "DOMAIN-SUFFIX,youtu.be,PROXY",
                                        "DOMAIN-SUFFIX,googlevideo.com,PROXY",
                                        "DOMAIN-SUFFIX,youtubei.googleapis.com,PROXY",
                                        "DOMAIN-SUFFIX,ggpht.com,PROXY",
                                        "DOMAIN-SUFFIX,googleapis.com,PROXY",
                                        "DOMAIN-SUFFIX,ytimg.com,PROXY",
                                        "DOMAIN-SUFFIX,youtube.com,PROXY",
                                        "DOMAIN-MATCH,google,PROXY",
                                        "DOMAIN-MATCH,dropbox,PROXY",
                                        "DOMAIN-MATCH,youtube,PROXY",
                                        "DOMAIN-MATCH,facebook,PROXY",
                                        "IP-CIDR,224.0.0.0/3,PROXY",
                                        "DOMAIN-MATCH,twitter,PROXY",
                                        "DOMAIN-MATCH,yahoo,PROXY",
                                        "DOMAIN-MATCH,instagram,PROXY",
                                        "DOMAIN-MATCH,wikipedia,PROXY",
                                        "DOMAIN-MATCH,telegram,PROXY",
                                        "DOMAIN-SUFFIX,twimg.com,PROXY",
                                        "DOMAIN-SUFFIX,tumblr.com,PROXY",
                                        "DOMAIN-SUFFIX,ggpht.com,PROXY",
                                        "DOMAIN,WhatsApp*,PROXY",
                                        "DOMAIN-SUFFIX,whatsapp.com,PROXY",
                                        "DOMAIN-SUFFIX,apple.com,DIRECT",
                                        "DOMAIN-MATCH,apple,DIRECT",
                                        //Telegram
                                        "IP-CIDR,149.154.164.0/22,PROXY",
                                        "IP-CIDR,149.154.168.0/21,PROXY",
                                        "IP-CIDR,67.198.55.0/24,PROXY",
                                        "IP-CIDR,91.108.4.0/22,PROXY",
                                        "IP-CIDR,91.108.56.0/22,PROXY",
                                        "IP-CIDR,109.239.140.0/24,PROXY",
                                        //#KEYWORD
                                        "DOMAIN-MATCH,google,PROXY",
                                        "DOMAIN-MATCH,dropbox,PROXY",
                                        "DOMAIN-MATCH,youtube,PROXY",
                                        "DOMAIN-MATCH,twitter,PROXY",
                                        "DOMAIN-MATCH,yahoo,PROXY",
                                        "DOMAIN-MATCH,instagram,PROXY",
                                        "DOMAIN-MATCH,wikipedia,PROXY",
                                        "DOMAIN-MATCH,telegram,PROXY",
                                        //facebook
                                        "DOMAIN-SUFFIX,mrface.com,PROXY",
                                        "DOMAIN-SUFFIX,facebook.br,PROXY",
                                        "DOMAIN-MATCH,facebook,PROXY",
                                        "DOMAIN-SUFFIX,facebook.com,PROXY",
                                        "DOMAIN-SUFFIX,facebook.design,PROXY",
                                        "DOMAIN-SUFFIX,facebook.net,PROXY",
                                        "DOMAIN-SUFFIX,facebook.hu,PROXY",
                                        "DOMAIN-SUFFIX,facebook.in,PROXY",
                                        "DOMAIN-SUFFIX,facebook.nl,PROXY",
                                        "DOMAIN-SUFFIX,facebook.se,PROXY",
                                        "DOMAIN-SUFFIX,fb.com,PROXY",
                                        "DOMAIN-SUFFIX,fb.me,PROXY",
                                        "DOMAIN-SUFFIX,m.me,PROXY",
                                        "DOMAIN-SUFFIX,messenger.com,PROXY",
                                        "DOMAIN-SUFFIX,v6.facebook.com,PROXY",
                                        "DOMAIN-SUFFIX,fb.com,PROXY,force-remote-dns",
                                        "DOMAIN-SUFFIX,fb.me,PROXY,force-remote-dns",
                                        "DOMAIN-SUFFIX,fbcdn.net,PROXY,force-remote-dns",
                                        //虾米
                                        "DOMAIN-SUFFIX,xiami.net,DIRECT",
                                        "DOMAIN-MATCH,xiami,DIRECT",
                                        "DOMAIN-MATCH,aryamask.com,DIRECT"
            
        ]
        
        //        // 国外
        //        let Outsideurl = UserDefaults(suiteName:"group.unblockmy.ios")
        //        let Outside = Outsideurl?.array(forKey: "国外网站url")
        //        if (Outside != nil) {
        //            do {
        //                for line in Outside! {
        //                    let  str4 = "DOMAIN-SUFFIX,"
        //                    let  str5 = ",PROXY"
        //                    let string = NSString(format: "%@" , line as! CVarArg)
        //                    let  str6 = str4 + (string as String) + str5 //字符串变量拼接
        //                    actionContent.append(str6)
        //                }
        //            } catch {}
        //        }
        
        
        let forwardURLRules: [String] = []
        let forwardIPRules: [String] = []
        var forwardGEOIPRules = [String]()
        
        forwardGEOIPRules = ["GEOIP,CN,DIRECT"]
        
        let usedata = UserDefaults.standard
        let strmodeproxy = usedata.string(forKey: "代理模式")
        if strmodeproxy == "全局模式" {
            forwardGEOIPRules = ["GEOIP,.cn,PROXY",
                                 "GEOIP,CN,PROXY"]
        }
        
        
        if forwardURLRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardURLRules)
        }
        
        if forwardIPRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardIPRules)
        }
        
        if forwardGEOIPRules.count > 0 {
            actionContent.append("{+forward-rule}")
            actionContent.append(contentsOf: forwardGEOIPRules)
        }
        // DNS pollution
        actionContent.append("{+forward-rule}")
        actionContent.append(contentsOf: Pollution.dnsList.map({ "DNS-IP-CIDR, \($0)/32, PROXY" }))
        
        let userActionString = actionContent.joined(separator: "\n")
        try userActionString.write(toFile: userActionUrl.path, atomically: true, encoding: String.Encoding.utf8)
    }
    
}

extension Manager {
    
    public func isVPNStarted(_ complete: @escaping (Bool, NETunnelProviderManager?) -> Void) {
        loadProviderManager { (manager) -> Void in
            if let manager = manager {
                complete(manager.connection.status == .connected, manager)
            }else{
                complete(false, nil)
            }
        }
    }
    
    public func startVPN(_ complete: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        startVPNWithOptions(nil, complete: complete)
    }
    
    fileprivate func startVPNWithOptions(_ options: [String : NSObject]?, complete: ((NETunnelProviderManager?, Error?) -> Void)? = nil) {
        // regenerate config files
        do {
            try Manager.sharedManager.regenerateConfigFiles()
        }catch {
            complete?(nil, error)
            return
        }
        // Load provider
        loadAndCreateProviderManager { (manager, error) -> Void in
            if let error = error {
                complete?(nil, error)
            }else{
                guard let manager = manager else {
                    complete?(nil, ManagerError.invalidProvider)
                    return
                }
                if manager.connection.status == .disconnected || manager.connection.status == .invalid {
                    do {
                        try manager.connection.startVPNTunnel(options: options)
                        self.addVPNStatusObserver()
                        complete?(manager, nil)
                    }catch {
                        complete?(nil, error)
                    }
                }else{
                    self.addVPNStatusObserver()
                    complete?(manager, nil)
                }
            }
        }
    }
    
    public func stopVPN() {
        // Stop provider
        loadProviderManager { (manager) -> Void in
            guard let manager = manager else {
                return
            }
            manager.connection.stopVPNTunnel()
        }
    }
    
    public func postMessage() {
        loadProviderManager { (manager) -> Void in
            if let session = manager?.connection as? NETunnelProviderSession,
                let message = "Hello".data(using: String.Encoding.utf8), manager?.connection.status != .invalid
            {
                do {
                    try session.sendProviderMessage(message) { response in
                        
                    }
                } catch {
                    print("Failed to send a message to the provider")
                }
            }
        }
    }
    
    fileprivate func loadAndCreateProviderManager(_ complete: @escaping (NETunnelProviderManager?, Error?) -> Void ) {
        NETunnelProviderManager.loadAllFromPreferences { [unowned self] (managers, error) -> Void in
            if let managers = managers {
                let manager: NETunnelProviderManager
                if managers.count > 0 {
                    manager = managers[0]
                }else{
                    manager = self.createProviderManager()
                }
                manager.isEnabled = true
                manager.localizedDescription = AppEnv.appName
                manager.protocolConfiguration?.serverAddress = AppEnv.appName
                manager.isOnDemandEnabled = true
                let quickStartRule = NEOnDemandRuleEvaluateConnection()
                quickStartRule.connectionRules = [NEEvaluateConnectionRule(matchDomains: ["connect.aryamask.com"], andAction: NEEvaluateConnectionRuleAction.connectIfNeeded)]
                manager.onDemandRules = [quickStartRule]
                manager.saveToPreferences(completionHandler: { (error) -> Void in
                    if let error = error {
                        complete(nil, error)
                    }else{
                        manager.loadFromPreferences(completionHandler: { (error) -> Void in
                            if let error = error {
                                complete(nil, error)
                            }else{
                                complete(manager, nil)
                            }
                        })
                    }
                })
            }else{
                complete(nil, error)
            }
        }
    }
    
    public func loadProviderManager(_ complete: @escaping (NETunnelProviderManager?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
            if let managers = managers {
                if managers.count > 0 {
                    let manager = managers[0]
                    complete(manager)
                    return
                }
            }
            complete(nil)
        }
    }
    
    fileprivate func createProviderManager() -> NETunnelProviderManager {
        let manager = NETunnelProviderManager()
        manager.protocolConfiguration = NETunnelProviderProtocol()
        return manager
    }
}

