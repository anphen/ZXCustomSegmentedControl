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

- (IBAction)refresh:(id)sender {
    [self.segmentCtrl removeFromSuperview];
    self.segmentCtrl = nil;
    ZXCustomSegmentedControl *segmentCtrl = [[ZXCustomSegmentedControl alloc]initWithItemArray:@[@"分类一",@"分类第一二",@"分类三",@"分类四"]];
    //    [segmentCtrl setTitle:@"jdb" forType:ZXCustomSegmentTypeSelected AtIndex:1];
    //    segmentCtrl.selectedBackImage = @"cps_home_left_select";
    segmentCtrl.borderColor = @"#EA0000";
    segmentCtrl.normalBackColor = @"ffffff";
    segmentCtrl.selectedBackColor = @"E0E0E0";
    [segmentCtrl configGradientBackColorWithStartColor:@"#FF9105" endColor:@"#FF6404"];
    [segmentCtrl configGradientBackColorWithStartColor:@"#000000" endColor:@"FFFFFF" forIndex:3];
    [segmentCtrl setBackImage:@"2" forType:ZXCustomSegmentTypeSelected forIndex:2];
    segmentCtrl.selectChangeHandle = ^(NSInteger index) {
        NSLog(@"====== %ld ======", index);
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
