//
//  MA_ThreadVC.m
//  ThreadDemo
//
//  Created by moliangyu on 2020/5/25.
//  Copyright © 2020 LTWM. All rights reserved.
//

#import "MA_ThreadVC.h"

@interface MA_ThreadVC ()

@property (nonatomic, strong) NSThread *thread;//现场

@end

@implementation MA_ThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ThreadDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMaUI];
}

- (void)loadMaUI
{
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(runTask) object:nil];
    self.thread.name = @"Thread";
    [self.thread start];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 60, 30);
    [btn addTarget:self action:@selector(reRunTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)runTask
{
    NSLog(@"%@:执行了任务",[NSThread currentThread]);
    
    NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];

    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

    [runLoop run];

    NSLog(@"任务结束");
}

- (void)runTask2
{
    NSLog(@"当前现场:%@",[NSThread currentThread]);
    NSLog(@"%s 完成",__PRETTY_FUNCTION__);
}

- (void)reRunTask
{
    [self performSelectorOnMainThread:@selector(runTask) withObject:@"text" waitUntilDone:YES];
//    [self.thread start];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(runTask2) onThread:self.thread withObject:nil waitUntilDone:NO];
}



@end
