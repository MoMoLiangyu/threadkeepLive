//
//  MA_Thread.m
//  ThreadDemo
//
//  Created by moliangyu on 2020/6/9.
//  Copyright © 2020 LTWM. All rights reserved.
//

#import "MA_Thread.h"

@implementation MA_Thread

- (void)dealloc
{
    NSLog(@"%@ 很快乐的被释放了",self.name);
}

@end
