//
//  CBWeakDelegate.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBWeakDelegate.h"

@interface CBWeakDelegateWrapper : NSObject

@property (nonatomic, weak)id delegate;

- (id)initWithDelegate:(id)delegate;

@end

@implementation CBWeakDelegateWrapper

- (instancetype)initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

@end

@interface CBWeakDelegate ()

@property (atomic, strong,readonly) NSMutableArray *delegates;

@end

@implementation CBWeakDelegate
@synthesize delegates = _delegates;

- (void)addDelegate:(id)delegate{
    if (delegate == nil) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *foundDelegates = [NSMutableArray array];
        for (CBWeakDelegateWrapper *delegateWrapper in self.delegates) {
            if (delegateWrapper.delegate == delegate) {
                [foundDelegates addObject:delegateWrapper];
                break;
            }
        }
        if ([foundDelegates count]<=0) {
            CBWeakDelegateWrapper *delegateWrapper = [[CBWeakDelegateWrapper alloc] initWithDelegate:delegate];
            //[self.delegates addObject:delegateWrapper];
            [self.delegates addObject:delegateWrapper];
        }else{
            //先移除
            [self.delegates removeObjectsInArray:foundDelegates];
            CBWeakDelegateWrapper *delegateWrapper = [[CBWeakDelegateWrapper alloc] initWithDelegate:delegate];
            [self.delegates addObject:delegateWrapper];
            
        }
    }
}

- (void)removeDelegate:(id)delegate{
    if (delegate == nil) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *removeArray = [NSMutableArray array];
        for (CBWeakDelegateWrapper *delegateWrapper in self.delegates) {
            if (delegateWrapper.delegate == delegate) {
                [removeArray addObject:delegateWrapper];
                break; //immediately break
            }
        }
        
        if ([removeArray count]>0) {
            [self.delegates removeObjectsInArray:removeArray];
        }
    }
}

- (void)removeDelegateClass:(Class)kls{
    @synchronized (self) {
        NSMutableArray *removeArray = [NSMutableArray array];
        for (CBWeakDelegateWrapper *delegateWrapper in self.delegates) {
            if ([delegateWrapper.delegate isKindOfClass:kls]) {
                [removeArray addObject:delegateWrapper];
            }
        }
        if ([removeArray count]>0) {
            [self.delegates removeObjectsInArray:removeArray];
        }
    }
}

- (BOOL)innerEnumerateUsingBlock:(BOOL (^)(id delegate))block respond:(SEL)sel{
    if (block == nil) {
        return NO;
    }
    BOOL handled = NO;
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    //firstly, got one copy of delegate array
    NSArray *tmpArray = nil;
    @synchronized (self) {
        tmpArray = [[NSArray alloc] initWithArray:self.delegates];
    }
    
    for (CBWeakDelegateWrapper *delegateWrapper in tmpArray) {
        if (!delegateWrapper.delegate) {
            [deleteArray addObject:delegateWrapper];
            continue;
        }
        if (sel) {
            if (![delegateWrapper.delegate respondsToSelector:sel]) {
                continue;
            }
        }
        
        handled = block(delegateWrapper.delegate);
        if (handled) {
            break;
        }
    }
    
    if (deleteArray.count > 0) {
        @synchronized (self) {
            [self.delegates removeObjectsInArray:deleteArray];
        }
    }
    
    return handled;
}

- (void)enumerateWithBlock:(void(^)(id delegate))block{
    [self enumerateUsingBlock:block respond:nil];
}

- (void)enumerateUsingBlock:(void(^)(id delegate))block respond:(nullable SEL)sel;{
    if (block == nil) {
        return;
    }
    
    [self innerEnumerateUsingBlock:^BOOL(id delegate) {
        block(delegate);
        return NO;
    } respond:sel];
}

- (BOOL)enumerateUsingBlock:(BOOL (^)(id delegate))block{
    return [self innerEnumerateUsingBlock:block respond:nil];
}

- (NSInteger)count{
    @synchronized (self) {
        NSInteger idx = 0;
        NSArray *delegateArray = [NSArray arrayWithArray:self.delegates];
        for (CBWeakDelegateWrapper *object in delegateArray) {
            if (object.delegate) {
                idx += 1;
            }
        }
        return idx;
    }
}

- (void)removeAllDelegates{
    @synchronized (self) {
        [self.delegates removeAllObjects];
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)delegates{
    if (_delegates == nil) {
        _delegates = [[NSMutableArray alloc] init];
    }
    return _delegates;
}

@end
