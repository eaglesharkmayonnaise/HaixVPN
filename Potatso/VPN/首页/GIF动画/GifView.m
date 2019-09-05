//
//  GifView.m
//  GIFViewer
//
//  Created by xToucher04 on 11-11-9.
//  Copyright 2011 Toucher. All rights reserved.
//

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>

@interface GifView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GifView



-(void)pateh:(NSString *)path
{
//    if (!timer) {
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
//        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [self.timer fire];
//    }
    
    
}

//懒加载
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(play) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                    forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    }
    return self;
}



//系统自带的
- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath{
    
    self = [super initWithFrame:frame];
    if (self) {
        
		gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
													 forKey:(NSString *)kCGImagePropertyGIFDictionary];
		gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
		count =CGImageSourceGetCount(gif);
		timer = [NSTimer scheduledTimerWithTimeInterval:0.2   target:self selector:@selector(play) userInfo:nil repeats:YES];
		[timer fire];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)_data{
    
    self = [super initWithFrame:frame];
    if (self) {
        
		gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
													 forKey:(NSString *)kCGImagePropertyGIFDictionary];
        //		gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
        gif = CGImageSourceCreateWithData((CFDataRef)_data, (CFDictionaryRef)gifProperties);
		count =CGImageSourceGetCount(gif);
		timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
		[timer fire];
    }
    return self;
}

-(void)play
{
	index ++;
	index = index%count;
	CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
	 self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
}
-(void)removeFromSuperview
{
	NSLog(@"removeFromSuperview");
	[timer invalidate];
	timer = nil;
	[super removeFromSuperview];
}
- (void)dealloc {
    NSLog(@"dealloc");
	CFRelease(gif);

}
@end
