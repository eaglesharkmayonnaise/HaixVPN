////
////  SocketManager.m
////  TestProtobufSocket
////
////  Created by pzk on 17/5/17.
////  Copyright © 2017年 Aone. All rights reserved.
////
//
//#import "SocketManager.h"
//#import "GCDAsyncSocket.h" // for TCP
//#import "FMDBHelper.h"
////#import "Node.pbobjc.h"
//#import "Common.pbobjc.h"
//#import "GetMiYao.h"
//static NSString *kHost = @"47.74.23.169";
//static const uint16_t kPort = 5775;
//
//@interface SocketManager () <GCDAsyncSocketDelegate> {
//    GCDAsyncSocket *gcdSocket;
//}
//
//@property (nonatomic, strong) NSTimer *timer;
//
//@end
//
//@implementation SocketManager
//
//+ (instancetype)sharedInstance {
//    static dispatch_once_t onceToken;
//    static SocketManager *instance = nil;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc]init];
//        [instance initSocket];
//    });
//    return instance;
//}
//
//- (void)initSocket {
//    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//}
//
//#pragma mark - 对外的一些接口
////建立连接
//- (BOOL)connect {
//    return [gcdSocket connectToHost:kHost onPort:kPort error:nil];
//    
//}
//
////断开连接
//- (void)disConnect {
//    [self systemLogout];
//    [gcdSocket disconnect];
//    [_timer invalidate];
//}
//
////系统退出
//- (void)systemLogout {
//}
//
////发送消息(字符串形式) 暂未调用
//- (void)sendMsg:(NSString *)msg {
//    NSData *data  = [msg dataUsingEncoding:NSUTF8StringEncoding];
//    //第二个参数，请求超时时间
//    [gcdSocket writeData:data withTimeout:-1 tag:110];
//}
//
////继续监听最新的消息
//- (void)pullTheMsg {
//    //监听读数据的代理  -1永远监听，不超时，但是只收一次消息，
//    //所以每次接受到消息还得调用一次
//    [gcdSocket readDataWithTimeout:-1 tag:110];
//}
//
//
////枚举请求类型
//typedef NS_ENUM(int32_t, URLCode){
//    CMD_DEVICE_REGISTER = 0x0100,//用户注册
//    CMD_MESSAGE_SEND = 0x0201,//向某一个客户端发送信息
//    CMD_MESSAGE_NOTIFY = 0x0202, //接收服务器信息
//    CMD_INIT = 0x0203,//初始化
//    CMD_NEED_REGISTER = 0x0204,//需要注册
//    CMD_DEVICE_UPDATE = 0x0205,//设备信息更新
//    CMD_DEVICE_DELETE = 0x0206//设备信息删除
//};
//
//- (void)SendUserprotobuf {
//    // 创建库
//    [[FMDBHelper sharedFMDBHelper] createDataBaseWithName:@"AryaLinesMask_db"];
//    // 创建表
//    BOOL isCreateTable = [[FMDBHelper sharedFMDBHelper] noResultSetWithSql:@"create table if not exists persons (number text,object text)"];
//    if (isCreateTable) {
//        NSLog(@"创建表成功！");
//    } else {
//        NSLog(@"创建表失败！");
//    }
//    
//    PacketHeader *PacketH = [PacketHeader new];
//    PacketH.headerId = [NSString stringWithFormat:@"%@",[GetMiYao getDeviceId]];
//    PacketH.version = 1;
//    PacketH.command = CMD_INIT;
//    PacketH.result = 0;
//    NSDate *datenow     = [NSDate date];
//    NSString *timeSp    = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    UInt32 timeStamp1    = [timeSp intValue];
//    PacketH.timestamp = timeStamp1;
//    NSData *personData = [PacketH data];
//    NSString *encodedBase64FromStr = [personData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    // 插入表
//    BOOL isInsert = [[FMDBHelper sharedFMDBHelper] noResultSetWithSql:[NSString stringWithFormat:@"insert into persons values('%@','%@')",PacketH.headerId,encodedBase64FromStr]];
//    if (isInsert) {
//        NSLog(@"插入成功！");
//    } else {
//        NSLog(@"插入失败！");
//    }
//    
//    // 查询表
//    NSMutableArray *selectItems = [[FMDBHelper sharedFMDBHelper] qureyWithSql:@"select * from persons"];
//    for (NSDictionary *item in selectItems) {
//        NSString *objectStr = item[@"object"];
//        NSData *decodeBase64StrToData = [[NSData alloc] initWithBase64EncodedString:objectStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        PacketHeader *decodedPerson = [PacketHeader parseFromData:decodeBase64StrToData error:nil];
//        ;
//       NSLog(@"------------%@",decodedPerson.headerId);
//    }
//    
//    //系列化data字节及其长度 发送到服务器
//    NSData *persondata = [PacketH data];
//    NSMutableData *protobufData = [[NSMutableData alloc] init];
//    // size
//    u_int16_t size = persondata.length;//2 byte
//    u_int32_t allsize = size + 2 + 0;//包长 byte
//    NSLog(@"-------------%hu", size);
//    size = htons(size);//网络序->本地序 (小 uint16)
//    allsize = htonl(allsize);//网络序->本地序 (uint32)
//    NSLog(@"--------------%hu", size);
//    
//    [protobufData appendBytes:&allsize length:4];
//    //
//    [protobufData appendBytes:&size length:2];
//    // data
//    [protobufData appendData:persondata];
//    //body
//    
//    Byte *byte = (Byte *)[protobufData bytes];
//    NSString *byteString = @"";
//    for (int i=0 ; i<[protobufData length]; i++) {
//        byteString = [byteString stringByAppendingString:[NSString stringWithFormat:@"%d ",byte[i]]];
//    }
//    NSLog(@"byteString: %@",byteString);
//    
//    // 写入数据
//    [gcdSocket writeData:protobufData withTimeout:-1 tag:0];
//    
////    [gcdSocket readDataToLength:4 withTimeout:10 tag:3];//分段读取数据
//}
//
//
//#pragma mark - GCDAsyncSocketDelegate
////连接成功调用
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
//    NSLog(@"连接成功,host:%@,port:%d",host,port);
//    
//    [self pullTheMsg];
//    
//    [self SendUserprotobuf];
//    
////    //心跳写在这...
////    if (!_timer) {
////
////        _timer = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(SendUserprotobuf) userInfo:nil repeats:YES];
////    }
//}
//
////断开连接的时候调用
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
//    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
//    
//    //断线重连写在这...
//    //再次可以重连
//    if (err) {
//        [self connect];
//    }else{
//        //正常断开
//    }
//}
//
////写成功的回调
//- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
//    NSLog(@"写的回调,tag:%ld",tag);
//}
//
////收到消息的回调
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSLog(@"收到消息：%@",data);
//    if (data.length >4) {
//        NSData *allsize = [data subdataWithRange:NSMakeRange(0, 4)];
//        uint32_t j;//
//        [allsize getBytes: &j length: sizeof(j)]; //取出data中指定长度的字节存入buffer这个提前声明的数组中
//        j = ntohl(j);//整个body长度
//        NSLog(@"------%d-",j);
//       
//        //head长度
//        NSData *headsize = [data subdataWithRange:NSMakeRange(4, 2)];
//        uint16_t headj;//
//        [headsize getBytes: &headj length: sizeof(headj)]; //取出data中指定长度的字节存入buffer这个提前声明的数组中
//        headj = ntohs(headj);//整个body长度
//        NSLog(@"------%d-",headj);
//        
//        //head
//        NSData *headdata = [data subdataWithRange:NSMakeRange(6, headj)];
//        PacketHeader *Logininfo = [PacketHeader parseFromData:headdata error:NULL];//data转protobuf
//        NSLog(@"%@",Logininfo);
//        
//        //返回收到数据包回调
//        if ([self.delegate respondsToSelector:@selector(receiveProtobufData:)]) {
//            [self.delegate receiveProtobufData:data];
//        }
//
//    }
////    if (data.length > 12) {
////        NSData *cmdIdData = [data subdataWithRange:NSMakeRange(8, 4)];//数据长度
////        int j;//
////        [cmdIdData getBytes: &j length: sizeof(j)];
////        j = htonl(j);
////        
////        NSData *sizeData = [data subdataWithRange:NSMakeRange(4, 4)];
////        int i;
////        [sizeData getBytes: &i length: sizeof(i)];
////        i = htonl(i);
////        if (j == CommandEnum_CmdHeartBeat) {
////            // 心跳包不做处理
////            NSLog(@"收到了心跳包!");
////        } else {
////            if ([self.delegate respondsToSelector:@selector(receiveProtobufData:)]) {
////                [self.delegate receiveProtobufData:data];
////            }
////        }
////    }
//    
//    //继续监听数据
//    [self pullTheMsg];
//}
//
//////分段去获取消息的回调
////- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
////    NSLog(@"读的回调,length:%ld,tag:%ld",partialLength,tag);
////    
////
////}
////
//////为上一次设置的读取数据代理续时 (如果设置超时为-1，则永远不会调用到)
////-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
////    NSLog(@"来延时，tag:%ld,elapsed:%f,length:%ld",tag,elapsed,length);
////    return 10;
////}
//
//@end
