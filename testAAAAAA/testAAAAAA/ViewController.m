//
//  ViewController.m
//  testAAAAAA
//
//  Created by Jessie on 2019/3/1.
//  Copyright © 2019年 Jessie. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    /*
    //-----------------frame与bounds的区别-------------------------------
    
    UILabel *view1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 300, 200)];
    view1.backgroundColor = [UIColor orangeColor];
    view1.text = @"View1";
    view1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:view1];
    
    UILabel *view2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    view2.text = @"View2";
    view2.textAlignment = NSTextAlignmentCenter;
    view2.bounds = CGRectMake(0, 0, 100, 40);
    view2.backgroundColor = [UIColor cyanColor];
    [view1 addSubview:view2];
    
    UILabel *view3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 40)];
    view3.bounds = CGRectMake(0, 0, 150, 60);
    view3.text = @"View3";
    view3.textAlignment = NSTextAlignmentCenter;
    view3.backgroundColor = [UIColor cyanColor];
    [view1 addSubview:view3];
    
    UILabel *view4 = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
    view4.bounds = CGRectMake(0, 0, 100, 40);
    view4.text = @"View4";
    view4.textAlignment = NSTextAlignmentCenter;
    view4.backgroundColor = [UIColor cyanColor];
    [view1 addSubview:view4];
  
    //----------------------------------------------------------------
    */
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureView)];
    [self.view addGestureRecognizer:tapgest];
    
    
    
    
}

-(void)tapGestureView{
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:firstVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
