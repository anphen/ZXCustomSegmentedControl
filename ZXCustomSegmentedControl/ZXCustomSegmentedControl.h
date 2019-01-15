//
//  ZXCustomSegmentedControl.h
//  TestZXCustomSegmentedControl
//
//  Created by xu zhao on 2019/1/11.
//  Copyright © 2019 xu zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZXCustomSegmentType) {
    ZXCustomSegmentTypeNormal,
    ZXCustomSegmentTypeSelected,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomSegmentedControl : UIView

@property (nonatomic, copy) void(^didChangeIndexHandle)(NSInteger currentIndex, NSInteger lastIndex);//选中位置发生改变后回调

@property (nonatomic, copy) void(^willChangeIndexHandle)(NSInteger currentIndex, NSInteger targetIndex);//选中位置发生改变后回调

@property (nonatomic, copy) NSString *normalTitleColor;//default #FFFFFF 正常文字颜色，统一设置
@property (nonatomic, copy) NSString *selectedTitleColor;//default #FF5500 选中文字颜色，统一设置

@property (nonatomic, copy) NSString *normalBackImage;//default nil 正常背景图，统一设置
@property (nonatomic, copy) NSString *selectedBackImage;//default nil 选中背景图，统一设置

@property (nonatomic, copy) NSString *normalBackColor;//default #FFFFFF 正常背景色，统一设置
@property (nonatomic, copy) NSString *selectedBackColor;//default #FF5500 选中背景色，统一设置

@property (nonatomic, copy) NSString *borderColor;//default #FF5500 边框颜色，统一设置

@property (nonatomic, assign) NSInteger originIndex;//default 0 设置开始的选中位置

@property (nonatomic, readonly) NSInteger currentIndex;//当前选中的位置

- (instancetype)initWithItemArray:(NSArray <NSString *>*)itemArray;//初始化方法，传入标题数组

- (void)configGradientBackColorWithStartColor:(NSString *)startColor endColor:(NSString *)endColor;//渐变色只会在选中状态下才会显示,全局设置

- (void)configGradientBackColorWithStartColor:(NSString *)startColor endColor:(NSString *)endColor forIndex:(NSInteger)index;//渐变色只会在选中状态下才会显示,定制不同位置

- (void)setTitle:(NSString *)title forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index;//定制不同位置，不同状态下的文字

- (void)setTitleColor:(NSString *)TitleColor forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index;//定制不同位置，不同状态下的文字颜色

- (void)setBackImage:(NSString *)backImage forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index;//定制不同位置，不同状态下的背景图

- (void)changeSelectIndex:(NSInteger)index executeBlock:(BOOL)executeBlock;

@end

NS_ASSUME_NONNULL_END
