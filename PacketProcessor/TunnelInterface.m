//
//  TunnelInterface.m
//  Potatso
//
//  Created by LEI on 12/23/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

#import "TunnelInterface.h"
#import <netinet/ip.h>
#import "ipv4/lwip/ip4.h"
#import "lwip/udp.h"
#import "lwip/ip.h"
#import <arpa/inet.h>
#import "inet_chksum.h"
#import "tun2socks/tun2socks.h"
#import "NSTimer+Pluto.h"
@import CocoaAsyncSocket;

#define kTunnelInterfaceErrorDomain [NSString stringWithFormat:@"%@.TunnelInterface", [[NSBundle mainBundle] bundleIdentifier]]

@interface TunnelInterface () <GCDAsyncUdpSocketDelegate>
@property (nonatomic) NEPacketTunnelFlow *tunnelPacketFlow;
@property (nonatomic) NSMutableDictionary *udpSession;
@property (nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) int readFd;
@property (nonatomic) int writeFd;

@end

@implementation TunnelInterface

+ (TunnelInterface *)sharedInterface {
    static dispatch_once_t onceToken;
    static TunnelInterface *interface;
    dispatch_once(&onceToken, ^{
        interface = [TunnelInterface new];
    });
    return interface;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _udpSession = [NSMutableDictionary dictionaryWithCapacity:5];
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}

+ (NSError *)setupWithPacketTunnelFlow:(NEPacketTunnelFlow *)packetFlow {
    if (packetFlow == nil) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"PacketTunnelFlow can't be nil."}];
    }
    [TunnelInterface sharedInterface].tunnelPacketFlow = packetFlow;
    
    NSError *error;
    GCDAsyncUdpSocket *udpSocket = [TunnelInterface sharedInterface].udpSocket;
    [udpSocket bindToPort:0 error:&error];
    
    //启用广播
    [udpSocket enableBroadcast:YES error:&error];
    
    if (error) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"UDP bind fail(%@).", [error localizedDescription]]}];
    }
    [udpSocket beginReceiving:&error];
    if (error) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"UDP bind fail(%@).", [error localizedDescription]]}];
    }
    
    
    int fds[2];
    // 因为之前vpn连接已经完成，而且之后又绑定了一个本地的socket端口
    // 这里试图创建一个pipe，创建的时候传了一个int *进去，如果创建完成fds[0] refers to the read end of the pipe. fds[1] refers to the write end of the pipe.
    // 创建一条pipe的目的是负责进程间通信，两个进程之间实现数据流通
    if (pipe(fds) < 0) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Unable to pipe."}];
    }
    [TunnelInterface sharedInterface].readFd = fds[0];
    [TunnelInterface sharedInterface].writeFd = fds[1];
    return nil;
}

// 之前已经在socksServerPort上建立了服务器，该服务器确实可以接受socks流量了，但是流量并不会直接走到socksServerPort端口上去，需要在httpProxyPort端口上接受数据，写给服务器。同样当服务器上接受数据也是需要些出去。
// 这样就需要一个通道，这个通道由pipe函数生成每当这个pipe接收到
+ (void)startTun2Socks: (int)socksServerPort {
    [NSThread detachNewThreadSelector:@selector(_startTun2Socks:) toTarget:[TunnelInterface sharedInterface] withObject:@(socksServerPort)];
}

+ (void)stop {
    stop_tun2socks();
}

+ (void)writePacket:(NSData *)packet {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TunnelInterface sharedInterface].tunnelPacketFlow writePackets:@[packet] withProtocols:@[@(AF_INET)]];
    });
}

//tunnelPacketFlow：IP数据包  https://blog.csdn.net/ce123_zhouwei/article/details/17453033
+ (void)processPackets {
    __weak typeof(self) weakSelf = self;
    [[TunnelInterface sharedInterface].tunnelPacketFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> * _Nonnull packets, NSArray<NSNumber *> * _Nonnull protocols) {
        for (NSData *packet in packets) {
            uint8_t *data = (uint8_t *)packet.bytes;
            struct ip_hdr *iphdr = (struct ip_hdr *)data;
            uint8_t proto = IPH_PROTO(iphdr);
            if (proto == IP_PROTO_UDP) {
                [[TunnelInterface sharedInterface] handleUDPPacket:packet];
            }else if (proto == IP_PROTO_TCP) {
                [[TunnelInterface sharedInterface] handleTCPPPacket:packet];
            }
        }
        [weakSelf processPackets];
    }];
    
}

// tun2socks是一个进程，这个进程可以做到左手连接一个tun设备，右手连接一个sock5代理，然后在两者之间做数据对拷
- (void)_startTun2Socks: (NSNumber *)socksServerPort {
    char socks_server[50];
    sprintf(socks_server, "127.0.0.1:%d", (int)([socksServerPort integerValue]));
#if TCP_DATA_LOG_ENABLE
    char *log_lvel = "debug";
#else
    char *log_lvel = "none";
#endif
    char *argv[] = {
        "tun2socks",
        "--netif-ipaddr",
        "192.0.2.4",
        "--netif-netmask",
        "255.255.255.0",
        "--loglevel",
        log_lvel,
        "--socks-server-addr",
        socks_server
    };
    tun2socks_main(sizeof(argv)/sizeof(argv[0]), argv, self.readFd, TunnelMTU);
    close(self.readFd);
    close(self.writeFd);
    [[NSNotificationCenter defaultCenter] postNotificationName:kTun2SocksStoppedNotification object:nil];
}

//处理数据写入的情况，当手机上各个app的请求数据过来了，将数据写到pipe的wirte端，写过去的是IP包，tun2socks会将写入的IP包转换为scoket流发到本地的socket服务器上去，再由本地的socket服务器发到本地的ssport去，
- (void)handleTCPPPacket: (NSData *)packet {
    uint8_t message[TunnelMTU+2];
    memcpy(message + 2, packet.bytes, packet.length);
    message[0] = packet.length / 256;
    message[1] = packet.length % 256;
    write(self.writeFd , message , packet.length + 2);
}

- (void)handleUDPPacket: (NSData *)packet {
    uint8_t *data = (uint8_t *)packet.bytes;
    int data_len = (int)packet.length;
    struct ip_hdr *iphdr = (struct ip_hdr *)data;
    uint8_t version = IPH_V(iphdr);
    
    switch (version) {
        case 4: {
            uint16_t iphdr_hlen = IPH_HL(iphdr) * 4;
            data = data + iphdr_hlen;
            data_len -= iphdr_hlen;
            struct udp_hdr *udphdr = (struct udp_hdr *)data;
            
            data = data + sizeof(struct udp_hdr *);
            data_len -= sizeof(struct udp_hdr *);
            
            NSData *outData = [[NSData alloc] initWithBytes:data length:data_len];
            struct in_addr dest = { iphdr->dest.addr };
            NSString *destHost = [NSString stringWithUTF8String:inet_ntoa(dest)];
            NSString *key = [self strForHost:iphdr->dest.addr port:udphdr->dest];
            NSString *value = [self strForHost:iphdr->src.addr port:udphdr->src];;
            self.udpSession[key] = value;
            
            [self.udpSocket bindToPort:0 error:nil];
            //启用广播
            [self.udpSocket enableBroadcast:YES error:nil];
            [self.udpSocket beginReceiving:nil];
            
            //UDP的最大数据报大小是65535（IPv4环境下，因为在UDP数据包的首部里，使用16bit的字节标示数据报的长度。所以最大长度就是2^16 - 1 = 65535,iPhone设置了收发缓冲区的大小9216,导致数据收发出现问题了。（发送数据包太大就是Message too large，接受数据包太大就会对数据截断）
            //            其实这也是我之前想说的。虽然我们修改了缓存区的大小，但是UDP本身作为一个不可靠的传输，分片后的数据很容易因为其中一片的遗失而全部丢弃。虽然从及时性的考虑上很多时候UDP确实是一个比TCP好的选择，但是过大的数据选择UDP还不是一个很好的选择。分包太多太容易丢失了。我想这大概是默认最大收发数据大小是9216而不是65535的原因。
            
            [self.udpSocket sendData:outData toHost:destHost port:ntohs(udphdr->dest) withTimeout:-1 tag:0];//443
            
        } break;
        case 6: {
            
        } break;
    }
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    const struct sockaddr_in *addr = (const struct sockaddr_in *)[address bytes];
    ip_addr_p_t dest ={ addr->sin_addr.s_addr };
    in_port_t dest_port = addr->sin_port;
    NSString *strHostPort = self.udpSession[[self strForHost:dest.addr port:dest_port]];
    NSArray *hostPortArray = [strHostPort componentsSeparatedByString:@":"];
    int src_ip = [hostPortArray[0] intValue];
    int src_port = [hostPortArray[1] intValue];
    uint8_t *bytes = (uint8_t *)[data bytes];
    int bytes_len = (int)data.length;
    int udp_length = sizeof(struct udp_hdr) + bytes_len;
    int total_len = IP_HLEN + udp_length;
    
    ip_addr_p_t src = {src_ip};
    struct ip_hdr *iphdr = generateNewIPHeader(IP_PROTO_UDP, dest, src, total_len);
    
    struct udp_hdr udphdr;
    udphdr.src = dest_port;
    udphdr.dest = src_port;
    udphdr.len = hton16(udp_length);
    udphdr.chksum = hton16(0);
    
    uint8_t *udpdata = malloc(sizeof(uint8_t) * udp_length);
    memcpy(udpdata, &udphdr, sizeof(struct udp_hdr));
    memcpy(udpdata + sizeof(struct udp_hdr), bytes, bytes_len);
    
    ip_addr_t odest = { dest.addr };
    ip_addr_t osrc = { src_ip };
    
    struct pbuf *p_udp = pbuf_alloc(PBUF_TRANSPORT, udp_length, PBUF_RAM);
    pbuf_take(p_udp, udpdata, udp_length);
    
    struct udp_hdr *new_udphdr = (struct udp_hdr *) p_udp->payload;
    new_udphdr->chksum = inet_chksum_pseudo(p_udp, IP_PROTO_UDP, p_udp->len, &odest, &osrc);
    
    uint8_t *ipdata = malloc(sizeof(uint8_t) * total_len);
    memcpy(ipdata, iphdr, IP_HLEN);
    memcpy(ipdata + sizeof(struct ip_hdr), p_udp->payload, udp_length);
    
    NSData *outData = [[NSData alloc] initWithBytes:ipdata length:total_len];
    free(ipdata);
    free(iphdr);
    free(udpdata);
    pbuf_free(p_udp);
    [TunnelInterface writePacket:outData];
}

struct ip_hdr *generateNewIPHeader(u8_t proto, ip_addr_p_t src, ip_addr_p_t dest, uint16_t total_len) {
    struct ip_hdr *iphdr = malloc(sizeof(struct ip_hdr));
    IPH_VHL_SET(iphdr, 4, IP_HLEN / 4);
    IPH_TOS_SET(iphdr, 0);
    IPH_LEN_SET(iphdr, htons(total_len));
    IPH_ID_SET(iphdr, 0);
    IPH_OFFSET_SET(iphdr, 0);
    IPH_TTL_SET(iphdr, 64);
    IPH_PROTO_SET(iphdr, IP_PROTO_UDP);
    iphdr->src = src;
    iphdr->dest = dest;
    IPH_CHKSUM_SET(iphdr, 0);
    IPH_CHKSUM_SET(iphdr, inet_chksum(iphdr, IP_HLEN));
    return iphdr;
}

- (NSString *)strForHost: (int)host port: (int)port {
    return [NSString stringWithFormat:@"%d:%d",host, port];
}



@end




