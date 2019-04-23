//
//  FirstViewController.m
//  testAAAAAA
//
//  Created by Jessie on 2019/4/22.
//  Copyright © 2019年 Jessie. All rights reserved.
//

#import "FirstViewController.h"
#import "TestView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"init");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
//    TestView *views = [[TestView alloc] init];
//    views.frame = CGRectMake(100, 100, 100, 100);
//    views.backgroundColor = [UIColor orangeColor];
//    views.userInteractionEnabled = YES;
//    [self.view addSubview:views];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWiilAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

-(void)viewDidLayoutSubviews{
    NSLog(@"viewDidLayoutSubviews");
}
-(void)viewWillLayoutSubviews{
    NSLog(@"viewWillLayoutSubviews");
}
-(void)dealloc{
    NSLog(@"dealloc");
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
