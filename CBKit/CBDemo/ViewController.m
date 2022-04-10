//
//  ViewController.m
//  CBDemo
//
//  Created by 李笑清 on 2020/7/8.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "ViewController.h"
#import <LXToolsKit/LXToolsKit.h>
#import <CBKit/CBKit.h>

struct ABCD {
    int i;
    int j;
    char h;
    double f;
};


@protocol ABCTestDelegate <NSObject>

- (void)test:(NSString *)test It:(int)it number:(NSNumber *)number;

@end

@interface TT : NSObject<ABCTestDelegate>

@end

@implementation TT


- (instancetype)init{
    if (self = [super init]) {
        [self msgbus_subscribeProtocol:@protocol(ABCTestDelegate)];
    }
    return self;
}

- (void)test:(NSString *)test It:(int)it number:(NSNumber *)number{
    NSLog(@"test2:%@",test);
}

@end

@interface ViewController ()<ABCTestDelegate>

@property (nonatomic,strong)TT *t;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self msgbus_subscribeProtocol:@protocol(ABCTestDelegate)];
    
    self.t = [[TT alloc] init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        struct ABCD test;
        test.i = 4;
        test.j = 5;
        CGPoint point = {100,200};
        [self  msgbus_dispatchProtocol:@protocol(ABCTestDelegate) selector:@selector(test:It:number:),@"TEST",2,@(2)];
    });
}

- (void)test:(NSString *)test It:(int)it number:(NSNumber *)number{
    NSLog(@"test1:%@",test);
}

@end
