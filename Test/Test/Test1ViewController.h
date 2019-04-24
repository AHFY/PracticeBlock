//
//  Test1ViewController.h
//  Test
//
//  Created by Jessie on 2018/12/3.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef简化block1
typedef void(^Block8)(void);

//block做为参数
typedef void(^handleBlock)(void);


@interface Test1ViewController : UIViewController


//typedef简化block2
@property (nonatomic ,copy) Block8 block8;
@property (nonatomic ,strong) UILabel *label;

-(void)callBlock8;

//typedef简化的block作为参数
-(void)blockWithNum:(NSInteger)num handleBlock:(handleBlock)handle;

//隐匿block直接作为参数
-(void)blockWithNoParamer:(NSInteger)num block:(void (^) (NSInteger num))block;

//block作为返回值
-(void (^)(NSInteger))blockWithNums:(NSInteger)nums;



@end
