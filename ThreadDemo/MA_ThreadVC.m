//
//  MA_ThreadVC.m
//  ThreadDemo
//
//  Created by moliangyu on 2020/5/25.
//  Copyright © 2020 LTWM. All rights reserved.
//

#import "MA_ThreadVC.h"
#import "MA_ThreadDemoVC.h"
#import "MA_Model.h"

#import "MA_Thread.h"

@interface MA_ThreadVC ()

@property (nonatomic, strong) MA_Thread *thread;//现场

@end

@implementation MA_ThreadVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ThreadDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *tempArray = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
     dispatch_queue_t queue = dispatch_queue_create("upImageQueue", DISPATCH_QUEUE_CONCURRENT);
    //加锁，是为了防止资源竞争
    NSConditionLock *imageLock = [[NSConditionLock alloc] initWithCondition:0];
    NSLock *lock = [[NSLock alloc] init];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    for (int i = 0; i < 9; i++) {
         dispatch_group_enter(group);
         dispatch_group_async(group, queue, ^{
             [NSThread sleepForTimeInterval:(10 - i)];
             [lock lock];
//             [imageLock lockWhenCondition:i];
             NSLog(@"执行了====== %d",i+1);
             MA_Model *model = [[MA_Model alloc] init];
             model.name = [NSString stringWithFormat:@"meili %d",(i+1)];
             model.indx = [NSNumber numberWithInt:(i+1)];
             [tempArray addObject:model];
//             [imageLock unlockWithCondition:i+1];
             [lock unlock];
             dispatch_group_leave(group);
         });
        
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
     
        NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:0];
        NSLog(@"startTime == %@ endTime ==%@",startTime,endTime);
        NSLog(@"%@",tempArray);
        NSArray *resultArray =  [tempArray sortedArrayUsingComparator:^NSComparisonResult(MA_Model *obj1, MA_Model  *obj2) {
//            NSLog(@"obj1 == %@ obj2 ==%@",obj1,obj2);
            
            return [obj1.indx compare:obj2.indx];
        }];
        
//         NSLog(@"%@",resultArray);
        
    });
    

   
    
//    [self loadMaUI];
}


- (void)loadMaUI
{
    
    NSLog(@"打印autoreleasepool的值===%@",[self getNewName:@"快乐"]); 
    
    NSLog(@"开起一个线程=== %@",[NSThread currentThread]);
    
//    self.thread = [[MA_Thread alloc] initWithTarget:self selector:@selector(runTask) object:nil];
//    self.thread.name = @"MA_Thread";
//    [self.thread start];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 60, 30);
    [btn addTarget:self action:@selector(reRunTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *pushBtn = [[UIButton alloc] init];
    pushBtn.backgroundColor = [UIColor redColor];
    pushBtn.frame = CGRectMake(100, 200, 60, 30);
    [pushBtn setTitle:@"调转" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushThreadDemo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    //注册observe
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        kCFRunLoopEntry = (1UL << 0),
//        kCFRunLoopBeforeTimers = (1UL << 1),
//        kCFRunLoopBeforeSources = (1UL << 2),
//        kCFRunLoopBeforeWaiting = (1UL << 5),
//        kCFRunLoopAfterWaiting = (1UL << 6),
//        kCFRunLoopExit = (1UL << 7),
//        kCFRunLoopAllActivities = 0x0FFFFFFFU
        if (activity == kCFRunLoopEntry) {
             NSLog(@"进入runloop");
        }else if (activity == kCFRunLoopBeforeTimers) {
             NSLog(@"timers之前");
        }else if (activity == kCFRunLoopBeforeSources) {
             NSLog(@"Sources之前");
        }else if (activity == kCFRunLoopBeforeWaiting) {
             NSLog(@"等待前");
        }else if (activity == kCFRunLoopAfterWaiting) {
             NSLog(@"等待之后");
        }else if (activity == kCFRunLoopExit) {
             NSLog(@"退出");
        }
//       NSLog(@"activity== %lu",activity);
        
    });
    
    //runloop中添加observe
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    //timer的创建和加入runloop
    //NSTimer定时器的触发正是基于RunLoop运行的，所以使用NSTimer之前必须注册到RunLoop
//Timer并不是严格的按照设定的时间点来触发的，RunLoop为了节省资源并不会在非常准确的时间点调用定时器，如果一个任务执行时间较长，那么当错过一个时间点后只能等到下一个时间点执行，并不会延后执行
    //NSTimer提供了一个tolerance属性用于设置宽容度，如果确实想要使用NSTimer并且希望尽可能的准确，则可以设置此属性
    // GCD的timer与NStimer不是一个东西，他们俩只要NStimer与runloop相关
    //在声明一次，不添加到RunLoop中的NSTimer是无法正常工作的
    //滚动scrollview NSTimer失效，加载runloop的model
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
//    timer.tolerance = 3;
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];//滚动的时候重新设置这mode
    
     //共同之处在于，通过合理利用RunLoop机制，将很多不是必须在主线程中执行的操作放在子线程中实现，然后在合适的时机同步到主线程中，这样可以节省在主线程执行操作的时间，避免卡顿。
    
    //在主线程中
    // 1. 当runloop开启时，会自动创建一个自动释放池
    // 2. 当runloop在休息之前会释放掉自动释放池的内存
    // 3. 然后重新创建一个新的空自动释放池
    // 4. 当runloop重新被唤醒开始跑圈时，source、timer等新的事件加入自动释放池中
    // 5. 重复2 - 4的步骤
    
    // 在子线程中
    // 一旦线程开始执行，你必须自己创建自动释放池，否则，应用将泄露对象
    // NSThread 和NSOperationQueue 开辟子线程需要手动创建自动释放池，GCD开辟的子线程不需要，因为它每个队列都会自动创建自动释放池。
    //
}

#pragma  mark --- Private Function

- (NSString *)getNewName:(NSString *)name
{
    NSString *getName = @"kuaile";
    @autoreleasepool {
        for (int i = 0; i < 10; i++) {
            NSString *tempName = [[NSString alloc] init];
            tempName = @"美丽";
            if (i == 6) {
                getName = tempName;
            }
        }
    }

    return getName;
}

- (void)timerAction:(id)sender
{
    NSLog(@"timer执行了这个方法");
}

- (void)runTask
{
//    do {
//        NSLog(@"%@:执行了任务",[NSThread currentThread]);
//    } while (1);
    
    @autoreleasepool {
            NSLog(@"%@:执行了任务",[NSThread currentThread]);
            
            NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];

            [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

        //    [runLoop addPort:[NSMachPort port] forMode:UITrackingRunLoopMode];//作用于ScrollView的滑动
            
        //    [runLoop run];
            
            [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:20]];
            
        //    CFRunLoopStop(runLoop.getCFRunLoop);

            NSLog(@"任务结束");
    }

}

- (void)runTask2
{
    NSLog(@"当前线程:%@",[NSThread currentThread]);
    NSLog(@"%s 完成",__PRETTY_FUNCTION__);
}


- (void)reRunTask
{
    [self performSelectorOnMainThread:@selector(runTask) withObject:@"text" waitUntilDone:YES];
//    [self.thread start];
}


- (void)pushThreadDemo
{
    MA_ThreadDemoVC *vc = [MA_ThreadDemoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self performSelector:@selector(runTask2) onThread:self.thread withObject:nil waitUntilDone:NO];
}



@end
