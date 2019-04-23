//
//  TestView.m
//  testAAAAAA
//
//  Created by Jessie on 2019/4/22.
//  Copyright © 2019年 Jessie. All rights reserved.
//

#import "TestView.h"

@implementation TestView{
    NSInteger _count;
}

- (instancetype)init{
    if (self = [super init]) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        views.backgroundColor = [UIColor cyanColor];
        [self addSubview:views];
        
        
        _count = 0;
        NSLog(@"%@", [NSString stringWithFormat:@"%@ ==> %ld",NSStringFromSelector(_cmd),_count]);
        }
    return self;
}
- (void)layoutSubviews{
        [super layoutSubviews];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
    
}
- (void)didAddSubview:(UIView *)subview{
        [super didAddSubview:subview];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)willRemoveSubview:(UIView *)subview{
        [super willRemoveSubview:subview]; _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
    
}
- (void)willMoveToSuperview:(nullable UIView *)newSuperview{
        [super willMoveToSuperview:newSuperview];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)drawRect:(CGRect)rect{
        [super drawRect:rect];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)willMoveToWindow:(nullable UIWindow *)newWindow{
        [super willMoveToWindow:newWindow];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)didMoveToWindow{
        [super didMoveToWindow];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)removeFromSuperview{
        [super removeFromSuperview];
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
}
- (void)dealloc{
        _count++;
        NSLog(@"%@ ==> %ld",NSStringFromSelector(_cmd),_count);
    
}
@end
