//
//  MA_ThreadDemoVC.m
//  ThreadDemo
//
//  Created by moliangyu on 2020/6/10.
//  Copyright © 2020 LTWM. All rights reserved.
//

#import "MA_ThreadDemoVC.h"
#import "MA_Thread.h"

@interface MA_ThreadDemoVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) MA_Thread *subThread;//
@property (nonatomic, weak) NSRunLoopMode runloopModel;//
@property (nonatomic, assign) BOOL isNeedRunloopStop;//
@property (nonatomic, strong) UIScrollView *scrollView;//

@property (nonatomic, weak) id tempStr;//
@end

@implementation MA_ThreadDemoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"演示Scrollview的滚动";
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor purpleColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2*self.view.frame.size.height);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.isNeedRunloopStop = NO;
    
//    [self loadThtreadAction];
    
    @autoreleasepool {
        _tempStr = [NSString stringWithFormat:@"xiaomage"];
//         reference = tempStr;
       
    }
     NSLog(@"tempStr  %@",_tempStr);
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear  %@",self.tempStr);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     NSLog(@"viewDidAppear  %@",self.tempStr);
}

- (void)loadThtreadAction
{
    NSLog(@"%@---开辟了子线程任务",[NSThread currentThread]);
    
    self.subThread = [[MA_Thread alloc] initWithTarget:self selector:@selector(subThreadTodo) object:nil];
    self.subThread.name = @"MA_Thread_Demo_VC";
    [self.subThread start];
}

#pragma  mark --- 子线程的任务
- (void)subThreadTodo
{
    @autoreleasepool {
        NSLog(@"开始子线程任务   %@",[NSThread currentThread]);
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerTodo) userInfo:nil repeats:YES];
        [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
        
        self.runloopModel = NSDefaultRunLoopMode;
        
        CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (CFStringRef)UITrackingRunLoopMode);
        
        while (!self.isNeedRunloopStop) {
            [runloop runMode:self.runloopModel beforeDate:[NSDate distantFuture]];
        }
    }
}

#pragma  mark --- 定时器任务
- (void)timerTodo
{
    NSLog(@"timer启动   当前的runloop %@",[NSRunLoop currentRunLoop].currentMode);
}

#pragma  mark --- 改变runloopMode
- (void)changeRunloopMode:(NSRunLoopMode)model
{
    NSLog(@"当前线程  %@   runloopModel即将改变成%@",[NSThread currentThread],[NSRunLoop currentRunLoop].currentMode);
}

#pragma  mark --- scrollview 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.runloopModel != UITrackingRunLoopMode) {
        [self performSelector:@selector(changeRunloopMode:) onThread:self.subThread withObject:UITrackingRunLoopMode waitUntilDone:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if (self.runloopModel != NSDefaultRunLoopMode) {
             [self performSelector:@selector(changeRunloopMode:) onThread:self.subThread withObject:NSDefaultRunLoopMode waitUntilDone:NO];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.runloopModel != NSDefaultRunLoopMode) {
         [self performSelector:@selector(changeRunloopMode:) onThread:self.subThread withObject:NSDefaultRunLoopMode waitUntilDone:NO];
    }
}

@end
