//
//  ViewController.m
//  Test
//
//  Created by Jessie on 2018/11/28.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"
#import "MyClass.h"

static int allSVal = 56;
@interface ViewController (){
    NSInteger testVal;
    NSObject *allObject;
   
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** 需要具体验证 __block __strong __weak
     *
    
     **/
    
    
    //block声明
//     [self declarationBlock];
    
    //block截获变量
    [self testBlock];
    
    //__weak和__strong的用法
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesureStrong)];
//    [self.view addGestureRecognizer:tal];
    
    //block的类型
    [self checkBlockType];
    
    
    //网上的代码
//    [self blockMemoryManagementWithMRC];
//    [self blockMemoryManagementWithARC];
//    [self blockManagerWithWeak];
    /**
     * 综上三个方法中的内容 总结如下
     关于下划线下划线block关键字在MRC和ARC下的不同
     __block在MRC下有两个作用
     
     1. 允许在Block中访问和修改局部变量
     
     2. 禁止Block对所引用的对象进行隐式retain操作
     
     __block在ARC下只有一个作用
     
     1. 允许在Block中访问和修改局部变量
     
     //---------------------------------
     MRC情况下，用__block可以消除循环引用。
     ARC情况下，必须用弱引用才可以解决循环引用问题，iOS 5之后可以直接使用__weak，之前则只能使用__unsafe_unretained了，__unsafe_unretained缺点是指针释放后自己不会置
     不知道 self 什么时候会被释放，为了保证在block内不会被释放，我们添加__strong。更多的时候需要配合strongSelf使用
     并不是所有的Block里面的self必须要weak一下，有些情况下是可以直接使用self的，比如调用系统的方法：动画代码块
     
    方法里的注释很重要
     **/
    
}
#pragma mark --- __block修改变量
-(void)testBlock{
    /**
     *  block所在函数中，捕获自动变量，但是不能修改他，不然就是编译错误，但是可以改变全局变量，静态变量，全局静态变量，理解如下：
     *  不能修改自动变量的值是因为block捕获的是自动变量的const值，名字一样，不能修改
     *  可以修改静态变量的值是因为静态变量是属于类的，不是某一个变量，由于block内部不用调用self指针，所以block可以调用
     **/
    __block int val = 10;
    static int sVal = 6;
   testVal = 10;
    void (^block)(void) = ^{
        //如果没有添加__block,在这个里面是不可以对val进行修改的 会报编译错误
        val = 5;
        sVal = 89; //静态变量
        testVal = 45; //全局变量
        allSVal = 90; //全局静态变量
        NSLog(@"val = %d,staticVal = %d,testVal = %ld,allSval = %d",val,sVal,testVal,allSVal);
        
    };
    val = 3;
    //不加__block之前 打印的结果是10，加了__block之后结果就变成了3 前提是block中没有val = 5这句话 否则就是5
    block();
    
    //----------------------------------------------
    /**
     *  block捕获OC对象时，不同于基本类型，Block会引起对象的引用计数变化
     **/
    
    static NSObject *staticObject = nil;
    staticObject = [[NSObject alloc] init];
    allObject = [[NSObject alloc] init];
    NSObject *object1 = [[NSObject alloc] init];
    __block NSObject *blockObject1 = [[NSObject alloc] init];
    NSObject *object2 = [[NSObject alloc] init];

    
    void (^testBlocks)(void) = ^{

        NSLog(@"staticObject1 - %ld",CFGetRetainCount((__bridge CFTypeRef)staticObject));
        NSLog(@"allObject1 - %ld",CFGetRetainCount((__bridge CFTypeRef)allObject));
        NSLog(@"bockeObject1 - %ld",CFGetRetainCount((__bridge CFTypeRef)blockObject1));
        NSLog(@"Object1 - %ld",CFGetRetainCount((__bridge CFTypeRef)object1));
        NSLog(@"object2 - %ld",CFGetRetainCount((__bridge CFTypeRef)object2));

    };

    testBlocks();
    /**
     *  最终结果：除了block1和block2的retainCount是3以外，其他的都是1
     *  对象的引用计数并不是简单的+1,而是加2,这是由于block在创建的时候在栈上,而在赋值给全局变量的时候,被拷贝到了堆上
     *  全局对象和静态对象因为在内存中的位置是确定的，所以即便在block中调用了 对其retainCount也不会有影响
     *  对于使用了__block的本地变量，也不会对其retainCount产生影响
     **/
    
}
#pragma mark - __weak 和 __strong
-(void)tapGesureStrong{
    
    //------------------------------------------
    //使用__weak
    Test1ViewController *test1VC = [[Test1ViewController alloc] init];
    //这样在代码块中就不会被强引用了
    __weak Test1ViewController *weals = test1VC;
    //typedef简化block4
    test1VC.block8 = ^{
        //此处用self就会造成循环引用 同时xcode也会提示警告
        weals.label.text = @"22222";
    };
    test1VC.block8();
    
    //-------------------------------------------------
    /*
     //不使用__strong 最后的结果为空
     MyClass *obj = [[MyClass alloc] init];
     __weak MyClass *weakObj = obj;
     NSLog(@"before block retainCount - %ld",CFGetRetainCount((__bridge CFTypeRef)obj));
     
     void (^block)(void) = ^(){
     NSLog(@"TestObj对象地址:%@",weakObj);
     dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
     
     for (int i = 0; i < 1000000; i++) {
     // 模拟一个耗时的任务
     }
     
     NSLog(@"耗时的任务 结束 TestObj对象地址:%@",weakObj);
     });
     
     };
     NSLog(@"after block retainCount - %ld",CFGetRetainCount((__bridge CFTypeRef)obj));
     
     block();
     */
    
    //使用__stong修饰
    MyClass *obj = [[MyClass alloc] init];
    __weak MyClass *weakObj = obj;
    NSLog(@"before block retainCount - %ld",CFGetRetainCount((__bridge CFTypeRef)obj));
    
    void (^block)(void) = ^(){
        __strong  MyClass *strongObj = weakObj;
        if(! strongObj) return;
        NSLog(@"TestObj对象地址:%@",strongObj);
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
            
            for (int i = 0; i < 1000000; i++) {
                // 模拟一个耗时的任务
            }
            
            NSLog(@"耗时的任务 结束 TestObj对象地址:%@",strongObj);
        });

        
    };
    NSLog(@"after block retainCount - %ld",CFGetRetainCount((__bridge CFTypeRef)obj));

    block();
    
    
}
#pragma mark -- block在MRC下的内存管理
-(void)blockMemoryManagementWithMRC{
    
    /**
     *  block在MRC中的内存管理
        因为环境是ARC的环境 所以对于copy以及release操作都注释掉了，在MRC中是需要自己手动去处理这些内容的 写这些只是为了弄明白 __block  __weak  __strong是怎么来的
     **/
    
    
    /**
     *  默认情况下，block的内存存储在栈中，不需要开发人员对其进行内存管理
     *  当Block变量出了作用域,Block的内存会被自动释放
         void(^myBlock)(void) = ^{
         NSLog(@"------");
         };
         myBlock();
     **/
   
    //--------------------------------------------------
    
    /**
     *  在block的内存存储在栈中时，如果在block中引用了外面的对象，不会对所引用的对象进行任何操作
         Test1ViewController *test1 = [[Test1ViewController alloc] init];
         void(^testBlock1)(void) = ^{
         NSLog(@"------%@", test1);
         };
         testBlock1();
     
         // test1对象在这里可以正常被释放
         [test1 release];
     **/
    
    //----------------------------------------------------
    
    /**
     *  如果对Block进行一次copy操作,那么Block的内存会被移动到堆中,这时需要开发人员对其进行release操作来管理内存
         void(^testBlock2)(void) = ^{
         NSLog(@"------");
         };
         testBlock2();
     
         testBlock2 = [testBlock2 copy];
     
         // do something ...
     
         [testBlock2 release];
     **/
    
    //-----------------------------------------------------
    
    /**
     *  如果对Block进行一次copy操作,那么Block的内存会被移动到堆中,在Block的内存存储在堆中时,如果在Block中引用了外面的对象,会对所引用的对象进行一次retain操作,即使在Block自身调用了release操作之后,Block也不会对所引用的对象进行一次release操作,这时会造成内存泄漏
     
             Test1ViewController *test2 = [[Test1ViewController alloc] init];
     
             void(^testBlock3)(void) = ^{
             NSLog(@"------%@", test2);
             };
             testBlock3();
     
             testBlock3 = [testBlock3 copy];
     
             // do something ...
     
             [testBlock3 release];
             // test2对象在这里无法正常被释放,因为其在Block中被进行了一次retain操作
             [test2 release];
     **/
    
    //---------------------------------------------------
    
    /**
     *  如果对Block进行一次copy操作,那么Block的内存会被移动到堆中,在Block的内存存储在堆中时,如果在Block中引用了外面的对象,会对所引用的对象进行一次retain操作,为了不对所引用的对象进行一次retain操作,可以在对象的前面使用下划线下划线block来修饰
     
         __block Test1ViewController *test3 = [[Test1ViewController alloc] init];
     
         void(^testBlock4)() = ^{
         NSLog(@"------%@", test3);
         };
         testBlock4();
     
         testBlock4 = [testBlock4 copy];
     
         // do something ...
     
         [testBlock4 release];
         // test3对象在这里可以正常被释放
         [test3 release];
     
     **/
    
    //----------------------------------------------------
    
    /**
     *  如果对象内部有一个Block属性,而在Block内部又访问了该对象,那么会造成循环引用
     ***情况一***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         @end
     
     
         @implementation Person
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
     
         Block_release(_myBlock);
         [super dealloc];
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
     
         p.myBlock = ^{
         NSLog(@"------%@", p);
         };
         p.myBlock();
     // 因为myBlock作为Person的属性,采用copy修饰符修饰(这样才能保证Block在堆里面,以免Block在栈中被系统释放),所以Block会对Person对象进行一次retain操作,导致循环引用无法释放
         [p release];
     
     
     ***情况二***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         - (void)resetBlock;
     
         @end
     
     
         @implementation Person
     
         - (void)resetBlock
         {
         self.myBlock = ^{
         NSLog(@"------%@", self);
         };
         }
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
     
         Block_release(_myBlock);
     
         [super dealloc];
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
         [p resetBlock];
     
     // Person对象在这里无法正常释放,虽然表面看起来一个alloc对应一个release符合内存管理规则,但是实际在resetBlock方法实现中,Block内部对self进行了一次retain操作,导致循环引用无法释放
     
         [p release];
     */
    
    //-----------------------------------------------------------

    /**
     *  如果对象内部有一个Block属性,而在Block内部又访问了该对象,那么会造成循环引用,解决循环引用的办法是在对象的前面使用下划线下划线block来修饰,以避免Block对对象进行retain操作
     ***情况一***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         @end
     
     
         @implementation Person
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
     
         Block_release(_myBlock);
         [super dealloc];
         }
     
         @end
     
     
         __block Person *p = [[Person alloc] init];
     
         p.myBlock = ^{
         NSLog(@"------%@", p);
         };
         p.myBlock();
          // Person对象在这里可以正常被释放
         [p release];
     
     
     ***情况二***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         - (void)resetBlock;
     
         @end
     
     
         @implementation Person
     
         - (void)resetBlock
         {
         // 这里为了通用一点,可以使用__block typeof(self) p = self;
         __block Person *p = self;
         self.myBlock = ^{
         NSLog(@"------%@", p);
         };
         }
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
     
         Block_release(_myBlock);
     
         [super dealloc];
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
         [p resetBlock];
     // Person对象在这里可以正常被释放
         [p release];
     */
    
    
}

#pragma mark -- block在ARC下的内存管理
-(void)blockMemoryManagementWithARC{
    /**
     * 在ARC默认情况下,Block的内存存储在堆中,ARC会自动进行内存管理,程序员只需要避免循环引用即可
         // 当Block变量出了作用域,Block的内存会被自动释放
         void(^myBlock)() = ^{
         NSLog(@"------");
         };
         myBlock();

     **/
    
    /**
     *   在Block的内存存储在堆中时,如果在Block中引用了外面的对象,会对所引用的对象进行强引用,但是在Block被释放时会自动去掉对该对象的强引用,所以不会造成内存泄漏
     
             Person *p = [[Person alloc] init];
     
             void(^myBlock)() = ^{
             NSLog(@"------%@", p);
             };
             myBlock();
     
             // Person对象在这里可以正常被释放
     **/
    
    /**
     *   如果对象内部有一个Block属性,而在Block内部又访问了该对象,那么会造成循环引用
     ***情况一***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         @end
     
     
         @implementation Person
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
     
         p.myBlock = ^{
         NSLog(@"------%@", p);
         };
         p.myBlock();
     
         // 因为myBlock作为Person的属性,采用copy修饰符修饰(这样才能保证Block在堆里面,以免Block在栈中被系统释放),所以Block会对Person对象进行一次强引用,导致循环引用无法释放
     
     ***情况二***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         - (void)resetBlock;
     
         @end
     
     
         @implementation Person
     
         - (void)resetBlock
         {
         self.myBlock = ^{
         NSLog(@"------%@", self);
         };
         }
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
         [p resetBlock];
     
         // Person对象在这里无法正常释放,在resetBlock方法实现中,Block内部对self进行了一次强引用,导致循环引用无法释放

     **/
    
    /**
     *  如果对象内部有一个Block属性,而在Block内部又访问了该对象,那么会造成循环引用,解决循环引用的办法是使用一个弱引用的指针指向该对象,然后在Block内部使用该弱引用指针来进行操作,这样避免了Block对对象进行强引用
     ***情况一***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         @end
     
     
         @implementation Person
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
         __weak typeof(p) weakP = p;
     
         p.myBlock = ^{
         NSLog(@"------%@", weakP);
         };
         p.myBlock();
     
         // Person对象在这里可以正常被释放
     ***情况二***
         @interface Person : NSObject
     
         @property (nonatomic, copy) void(^myBlock)();
     
         - (void)resetBlock;
     
         @end
     
     
         @implementation Person
     
         - (void)resetBlock
         {
         // 这里为了通用一点,可以使用__weak typeof(self) weakP = self;
         __weak Person *weakP = self;
         self.myBlock = ^{
         NSLog(@"------%@", weakP);
         };
         }
     
         - (void)dealloc
         {
         NSLog(@"Person dealloc");
         }
     
         @end
     
     
         Person *p = [[Person alloc] init];
         [p resetBlock];
     
         // Person对象在这里可以正常被释放
     **/
    
}

#pragma mark - 弱引用
-(void)blockManagerWithWeak{
    /**
     *  在MRC中,我们从当前控制器采用模态视图方式present进入MyViewController控制器,在Block中会对myViewController进行一次retain操作,造成循环引用
     
         MyViewController *myController = [[MyViewController alloc] init];
         // ...
         myController.completionHandler =  ^(NSInteger result) {
            [myController dismissViewControllerAnimated:YES completion:nil];
         };
         [self presentViewController:myController animated:YES completion:^{
            [myController release];
         }];
     **/
    
    /**
     *      ||
     *      ||
     *     \  /
     *      \/
     **/
    
    /**
     *  在MRC中解决循环引用的办法即在变量前使用下划线下划线block修饰,禁止Block对所引用的对象进行retain操作
         __block MyViewController *myController = [[MyViewController alloc] init];
         // ...
         myController.completionHandler =  ^(NSInteger result) {
            [myController dismissViewControllerAnimated:YES completion:nil];
         };
         [self presentViewController:myController animated:YES completion:^{
            [myController release];
         }];
     **/
    
    /**
     *      ||
     *      ||
     *     \  /
     *      \/
     **/
    
    /**
     *  但是上述方法在ARC下行不通,因为下划线下划线block在ARC中并不能禁止Block对所引用的对象进行强引用,解决办法可以是在Block中将myController置空(为了可以修改myController,还是需要使用下划线下划线block对变量进行修饰)
         __block MyViewController *myController = [[MyViewController alloc] init];
         // ...
         myController.completionHandler =  ^(NSInteger result) {
            [myController dismissViewControllerAnimated:YES completion:nil];
            myController = nil;
         };
         [self presentViewController:myController animated:YES completion:^{}];
     **/
    
    /**
     *      ||
     *      ||
     *     \  /
     *      \/
     **/
    
    /**
     *  上述方法确实可以解决循环引用,但是在ARC中还有更优雅的解决办法,新创建一个弱指针来指向该对象,并将该弱指针放在Block中使用,这样Block便不会造成循环引用
         MyViewController *myController = [[MyViewController alloc] init];
         // ...
         __weak MyViewController *weakMyController = myController;
         myController.completionHandler =  ^(NSInteger result) {
            [weakMyController dismissViewControllerAnimated:YES completion:nil];
         };
         [self presentViewController:myController animated:YES completion:^{}];
     **/
    
    /**
     *  虽然解决了循环引用,但是也容易涉及到另一个问题,因为Block是通过弱引用指向了myController对象,那么有可能在调用Block之前myController对象便已经被释放了,所以我们需要在Block内部再定义一个强指针来指向myController对象
         MyViewController *myController = [[MyViewController alloc] init];
         // ...
         __weak MyViewController *weakMyController = myController;
         myController.completionHandler =  ^(NSInteger result) {
             MyViewController *strongMyController = weakMyController;
             if (strongMyController)
             {
             [strongMyController dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
             // Probably nothing...
             }
         };
         [self presentViewController:myController animated:YES completion:^{}];
     
     *  这里需要补充一下,在Block内部定义的变量,会在作用域结束时自动释放,Block对其并没有强引用关系,且在ARC中只需要避免循环引用即可,如果只是Block单方面地对外部变量进行强引用,并不会造成内存泄漏
     *  上面这个也可以用strong 不知道 self 什么时候会被释放，为了保证在block内不会被释放，我们添加__strong。更多的时候需要配合strongSelf使用
         __weak __typeof(self) weakSelf = self; self.testBlock =  ^{
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             [strongSelf test];
         });
     **/
    
}

#pragma mark -- block声明
-(void)declarationBlock{
   /**
    *   有返回值或有参数时 等号后面要对应的写上 没有的话 可以省略或者写void
    *   typedf的声明方式是对block的一种简化
    *   returnType为返回值 blockName为block的名称 parameter为参数，多个参数用,隔开
    *   returnType (^blockName) (parameter) = ^ returnType (parameter){};
    **/

    void (^block1)(void) = ^{
        NSLog(@"没有返回值，没有参数的最简写法");
    };
    void (^block2)(void) = ^void (void){
        NSLog(@"没有返回值，没有参数的完整的写法");
    };
    void (^block3)(void) = ^(void){
        NSLog(@"没有返回值，没有参数的只写参数");
    };
    //------------------------------------------
    NSInteger (^block4)(void) =  ^NSInteger (void){
        NSLog(@"有返回值，没有参数");
        return 3;
    };
    NSInteger (^block5)(void) =  ^NSInteger {
        NSLog(@"有返回值，没有参数简写");
        return 3;
    };
    
    //-------------------------------------------
    void (^block6)(NSInteger num) = ^void (NSInteger num){
        NSLog(@"没有返回值，有参数");
    };
    
    void (^block7)(NSInteger num) = ^(NSInteger num){
        NSLog(@"没有返回值，有参数简写");
    };

    block1();
    block2();
    block3();
    block4();
    block5();
    block6(2);
    block7(3);
    
    
    //-------------------------------------------
    //匿名block调用时，直接在后面写上就可以，有参数写参数，无参数直接是()
   ^NSInteger {
       NSLog(@"匿名block");
       return 6;
   }();
    //匿名block有参数的形式
    ^NSInteger(NSInteger v){
        NSLog(@"匿名参数 -- %ld",v);
        return v;
    }(5555555555);
  
    //------------------用typedef简化block-----------------------
    Test1ViewController *test1VC = [[Test1ViewController alloc] init];
    //typedef简化block4
    test1VC.block8 = ^{
        NSLog(@"用typedef简化block");
    };
    //调用
    [test1VC callBlock8];
    
    //typedef声明的代码块做为方法中的参数
    [test1VC blockWithNum:3 handleBlock:^{
        NSLog(@"走了吗");
    }];
    
    /**
     *  匿名block可以直接在方法里做为参数进行传递
     *  method为方法，冒号后面为匿名block做为参数
     *  method:(returnType (^)(parmaer))block{
     *      这句话一定要写，否则再调用此方法时，不会走代码块中的内容
     *      block(parameter);
     *  }
     **/
    [test1VC blockWithNoParamer:5 block:^(NSInteger num) {
        NSLog(@"匿名block传的参--%ld",num);
    }];

    /**
     *  block作为返回值时 需要再次调用一次 才能走方法里的内容
     **/
    block6 = [test1VC blockWithNums:9];
    block6(99999);
    
}


void (^blk)(void) = ^{
    NSLog(@"Global Block");
};


#pragma mark - 查看block的类型
-(void)checkBlockType{
    void (^block)(void) = ^{
        NSLog(@"block");
    };
    NSLog(@"%@",[block class]);
    NSLog(@"%@",[[block class] superclass]);
    NSLog(@"%@",[[[block class] superclass] superclass]);
    NSLog(@"%@",[[[[block class] superclass] superclass] superclass]);
    NSLog(@"%@",[[[[[block class] superclass] superclass] superclass] superclass]);
    
    //代码展示三种类型
    int age = 1;
    void (^block1)(void) = ^{
        NSLog(@"没有截获自动变量");
    };
    
    void (^block2)(void) = ^{
        NSLog(@"截获了自动变量:%d",age);
    };
    
    NSLog(@"\n%@\n%@\n%@\n%@",[block1 class],[block2 class],[^{
        NSLog(@"block3:%d",age);
    } class],[blk class]);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
