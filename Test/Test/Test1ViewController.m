//
//  Test1ViewController.m
//  Test
//
//  Created by Jessie on 2018/12/3.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.label.backgroundColor = [UIColor orangeColor];
    self.label.text = @"label";
    [self.view addSubview:self.label];
}

-(void)callBlock8{
    self.block8();
}

-(void)blockWithNum:(NSInteger)num handleBlock:(handleBlock)handle{
    NSLog(@"block作为参数");
    //此方法一定要写，否则调用时不会走代码块中的内容
    handle();
}

-(void)blockWithNoParamer:(NSInteger)num block:(void (^)(NSInteger nums))block{
    NSLog(@"隐匿block作为参数 - %ld",num);
    block(10);
}

-(void (^)(NSInteger))blockWithNums:(NSInteger)nums{
    return ^void (NSInteger num1){
        NSLog(@"block作为返回值 - %ld",nums);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
