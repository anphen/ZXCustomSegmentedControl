//
//  ViewController.m
//  TestZXCustomSegmentedControl
//
//  Created by xu zhao on 2019/1/11.
//  Copyright © 2019 xu zhao. All rights reserved.
//

#import "ViewController.h"
#import "ZXCustomSegmentedControl.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) ZXCustomSegmentedControl *segmentCtrl;

@end

@implementation ViewController

- (IBAction)change3NO:(id)sender {
    [self.segmentCtrl changeSelectIndex:3 executeBlock:NO];
}

- (IBAction)change3YES:(id)sender {
    [self.segmentCtrl changeSelectIndex:3 executeBlock:YES];
}

- (IBAction)refresh:(id)sender {
    [self.segmentCtrl removeFromSuperview];
    self.segmentCtrl = nil;
    ZXCustomSegmentedControl *segmentCtrl = [[ZXCustomSegmentedControl alloc]initWithItemArray:@[@"分类一",@"分类第一二",@"分类三",@"分类四"]];
    //    [segmentCtrl setTitle:@"jdb" forType:ZXCustomSegmentTypeSelected AtIndex:1];
    //    segmentCtrl.selectedBackImage = @"cps_home_left_select";
   

//    segmentCtrl.normalTitleColor = @"AE8F00";
//    segmentCtrl.selectedTitleColor = @"F75000";
//    segmentCtrl.normalBackColor = @"d0d0d0";
//    segmentCtrl.selectedBackColor = @"FF79BC";
//    segmentCtrl.originIndex = 0;
//    segmentCtrl.borderColor = @"#0000C6";
//
//    [segmentCtrl configGradientBackColorWithStartColor:@"#FF9105" endColor:@"#FF6404"];
//    [segmentCtrl configGradientBackColorWithStartColor:@"#ffffff" endColor:@"#000000" forIndex:1];
//    [segmentCtrl setBackImage:@"2" forType:ZXCustomSegmentTypeSelected forIndex:2];
//    [segmentCtrl setTitleColor:@"004B97" forType:ZXCustomSegmentTypeSelected forIndex:3];
    
    segmentCtrl.willChangeIndexHandle = ^(NSInteger currentIndex, NSInteger targetIndex) {
        NSLog(@"====== current = %ld  targetIndex = %ld =======", currentIndex, targetIndex);
    };
    segmentCtrl.didChangeIndexHandle = ^(NSInteger currentIndex, NSInteger lastIndex) {
        NSLog(@"====== current = %ld  last = %ld =======", currentIndex, lastIndex);
    };
    
    [self.view addSubview:segmentCtrl];
    [segmentCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.height.mas_equalTo(27);
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.segmentCtrl = segmentCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh:nil];
}


@end
