//
//  MCBlock.m
//  testAAAAAA
//
//  Created by Jessie on 2019/3/15.
//  Copyright © 2019年 Jessie. All rights reserved.
//

#import "MCBlock.h"

@implementation MCBlock

-(void)method{
    int multiplier = 6;
    int(^Block)(int) = ^int(int num){
        return num * multiplier;
    };
    
    Block(2);
    
}


@end
