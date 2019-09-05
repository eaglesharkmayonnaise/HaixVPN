source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

def fabric
    pod 'Fabric'
    pod 'Crashlytics'
end

def library
    pod 'KissXML', '~> 5.2.2'
    pod 'ICSMainFramework', :path => "./Library/ICSMainFramework/"
    pod 'MMWormhole', '~> 2.0.0'
    pod 'KeychainAccess'
end

def tunnel
    pod 'MMWormhole', '~> 2.0.0'
end

def socket
    pod 'CocoaAsyncSocket', '~> 7.4.3'
end

def model
   pod 'RealmSwift', '~> 2.10.2'
end

target "Potatso" do
#    pod 'VTMagic'#自定义线路那里的来回滑动框架
    pod 'Aspects', :path => "./Library/Aspects/"
    pod 'Cartography'
    pod 'AsyncSwift'
   pod 'SwiftColor'
   pod 'Appirater'
   pod 'Eureka'
    pod 'SDWebImage'
    pod 'MBProgressHUD'
    pod 'MGSwipeTableCell'
    pod 'MMDrawerController', '~> 0.5.7'
    #    pod 'Protobuf', '~> 3.1.0' #数据库
    #    pod 'FMDB';#数据库
#    pod 'MJRefresh'#'刷新
    pod 'YBAttributeTextTapAction'#富文本点击事件
#     pod "QNNetDiag"
   pod 'CallbackURLKit'
   pod 'ICDMaterialActivityIndicatorView', '~> 0.1.0'
#    pod 'Reveal-iOS-SDK', '~> 1.6.2', :configurations => ['Debug']
   pod 'ICSPullToRefresh'
   pod 'ISO8601DateFormatter', '~> 0.8'
   pod 'Alamofire'
   pod 'AlamofireObjectMapper', '~> 5.0'

    pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '2.x'
#     pod 'ObjectMapper'
    pod 'VAProgressCircle'
   pod 'CocoaLumberjack/Swift'
#    pod 'Helpshift', '5.6.1'
   pod 'PSOperations'
#    pod 'LogglyLogger-CocoaLumberjack', '~> 3.0'

#支付
    pod 'CardIO'
    pod 'PWCoreSDK', :path => '.'
    pod 'PWAlipayPlugin', :path => '.'
    pod 'PWWechatpayPlugin', :path => '.'
    pod 'PWCardScannerPlugin', :path => '.'
    pod 'PWMyCardPlugin', :path => '.'
    pod 'PWGameUIPlugin', :path => '.'
#
    tunnel
    library
    fabric
    socket
    model
end

target "PacketTunnel" do
    tunnel
    socket
end

target "PacketProcessor" do
    socket
end

#target "TodayWidget" do
#    pod 'Cartography'
#    pod 'SwiftColor'
#    library
#    socket
#    model
#end

target "PotatsoLibrary" do
    library
    model
    pod 'YAML-Framework', :path => "./Library/YAML-Framework"
end

target "PotatsoModel" do
    model
end

#target "PotatsoLibraryTests" do
#    library
#end

#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['ENABLE_BITCODE'] = 'NO'
#            if target.name == "HelpShift"
#                config.build_settings["OTHER_LDFLAGS"] = '$(inherited) "-ObjC"'
#            end
#        end
#    end
#end

