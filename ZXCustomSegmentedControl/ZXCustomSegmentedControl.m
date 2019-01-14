//
//  ZXCustomSegmentedControl.m
//  TestZXCustomSegmentedControl
//
//  Created by xu zhao on 2019/1/11.
//  Copyright © 2019 xu zhao. All rights reserved.
//

#import "ZXCustomSegmentedControl.h"
#import <Masonry.h>
#import <UIColor+Additions.h>

#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

static NSInteger const ZXCustomSegmentFontSize = 13;
static NSInteger const ZXCustomSegmentHeight = 27;
static NSInteger const ZXCustomSegmentMargin = 15;

@interface ZXCustomSegment : UIView

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) ZXCustomSegmentType segmentType;

@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic, copy) NSString *normalTitleColor;
@property (nonatomic, copy) NSString *selectedTitleColor;

@property (nonatomic, copy) NSString *normalBackColor;
@property (nonatomic, copy) NSString *selectedBackColor;

@property (nonatomic, copy) NSString *normalBackImage;
@property (nonatomic, copy) NSString *selectedBackImage;

@property (nonatomic, copy) NSString *gradientStartColor;
@property (nonatomic, copy) NSString *gradientEndColor;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, copy) void(^clickCallBack)(ZXCustomSegment *segment);

@property (nonatomic, strong) MASConstraint *backImageWidthConstraint;

- (void)updateContent;

@end

@implementation ZXCustomSegment

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //default
        _normalTitle = @"";
        _selectedTitle = @"";
        
        _normalBackColor = @"#FFFFFF";
        _selectedBackColor = @"#FF5500";
        
        _normalTitleColor = @"#FF5500";
        _selectedTitleColor = @"#FFFFFF";
        
        _normalBackImage = @"";
        _selectedBackImage = @"";
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:ZXCustomSegmentFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc]init];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backImageView];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ZXCustomSegmentMargin).priority(MASLayoutPriorityDefaultHigh);
            make.right.mas_equalTo(-ZXCustomSegmentMargin).priority(MASLayoutPriorityDefaultHigh);
            make.top.bottom.mas_equalTo(0).priority(MASLayoutPriorityDefaultHigh);
        }];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(ZXCustomSegmentHeight);
            self.backImageWidthConstraint = make.width.mas_equalTo(0);
//            make.left.mas_equalTo(self.titleLabel.mas_left).offset(-ZXCustomSegmentMargin).priority(MASLayoutPriorityRequired);
//            make.right.mas_equalTo(self.titleLabel.mas_right).offset(ZXCustomSegmentMargin).priority(MASLayoutPriorityRequired);
//            make.top.mas_equalTo(self.titleLabel.mas_top);
//            make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        }];
        
//        [_backImageView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//        [_backImageView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        self.segmentType = ZXCustomSegmentTypeNormal;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)]];
    }
    return self;
}

- (void)click{
    if (self.clickCallBack) {
        self.clickCallBack(self);
    }
}

- (void)updateContent{
    [self.gradientLayer removeFromSuperlayer];
    switch (self.segmentType) {
        case ZXCustomSegmentTypeNormal:
        {
            //设置背景色
            self.backgroundColor = [UIColor colorWithHexString:self.normalBackColor];
            
            if (!IsStrEmpty(self.normalBackImage)) {
                self.backImageView.hidden = NO;
                self.backImageView.image = [UIImage imageNamed:self.normalBackImage];
            }
            else{
                self.backImageView.hidden = YES;
            }
            
            self.titleLabel.textColor = [UIColor colorWithHexString:self.normalTitleColor];
            self.titleLabel.text = self.normalTitle;
            self.backImageWidthConstraint.mas_equalTo(self.titleLabel.frame.size.width + 2 * ZXCustomSegmentMargin);
        }
            break;
        case ZXCustomSegmentTypeSelected:
        {
            //设置背景色
            self.backgroundColor = [UIColor colorWithHexString:self.selectedBackColor];
            
            if (!IsStrEmpty(self.selectedBackImage)) {
                self.backImageView.hidden = NO;
                self.backImageView.image = [UIImage imageNamed:self.selectedBackImage];
            }
            else{
                self.backImageView.hidden = YES;
            }
            
            self.titleLabel.textColor = [UIColor colorWithHexString:self.selectedTitleColor];
            self.titleLabel.text = IsStrEmpty(self.selectedTitle) ? self.normalTitle : self.selectedTitle;
            
            if (!IsStrEmpty(self.gradientStartColor) && !IsStrEmpty(self.gradientEndColor)) {
                self.gradientLayer = [self addGradientLayerWithColors:@[(__bridge id)[UIColor colorWithHexString:self.gradientStartColor].CGColor,(__bridge id)[UIColor colorWithHexString:self.gradientEndColor].CGColor] frame:self.bounds];
            }
            
            self.backImageWidthConstraint.mas_equalTo(self.frame.size.width);
        }
            break;
        default:
            break;
    }
}

- (void)layoutSubviews{
    [self updateContent];
}

- (void)setSegmentType:(ZXCustomSegmentType)segmentType{
    _segmentType = segmentType;
    [self updateContent];
}

@end

@interface ZXCustomSegmentedControl()

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) NSMutableArray *segmentArray;

@property (nonatomic, strong) ZXCustomSegment *currentSelectSegment;

@end

@implementation ZXCustomSegmentedControl

- (instancetype)initWithItemArray:(NSArray <NSString *>*)itemArray
{
    self = [super init];
    if (self) {
        self.borderColor = @"#FF5500";
        _itemArray = itemArray;
        _segmentArray = [NSMutableArray array];
        _originIndex = 0;
        ZXCustomSegment *lastSegment = nil;
        for (int i = 0; i < _itemArray.count; i++) {
            NSString *title = [_itemArray objectAtIndex:i];
            ZXCustomSegment *segment = [[ZXCustomSegment alloc]init];
            
            segment.normalTitle = title;
            [_segmentArray addObject:segment];
            if (i == _originIndex) {
                segment.segmentType = ZXCustomSegmentTypeSelected;
                _currentSelectSegment = segment;
            }
            else{
                 segment.segmentType = ZXCustomSegmentTypeNormal;
            }
            __weak typeof(self)weakSelf = self;
            segment.clickCallBack = ^(ZXCustomSegment *segment) {
                weakSelf.currentSelectSegment.segmentType = ZXCustomSegmentTypeNormal;
                segment.segmentType = ZXCustomSegmentTypeSelected;
                weakSelf.currentSelectSegment = segment;
                if (weakSelf.selectChangeHandle) {
                    weakSelf.selectChangeHandle(weakSelf.currentIndex);
                }
            };
            [self addSubview:segment];
            if (i == 0) {
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(ZXCustomSegmentHeight).priority(MASLayoutPriorityDefaultHigh);
                }];
            }
            else if (i == _itemArray.count -1){
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right).offset(1);
                    make.right.mas_equalTo(0);
                    make.top.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(ZXCustomSegmentHeight).priority(MASLayoutPriorityDefaultHigh);
                }];
            }
            else{
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right).offset(1);
                    make.top.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(ZXCustomSegmentHeight).priority(MASLayoutPriorityDefaultHigh);
                }];
            }
            lastSegment = segment;
        }
      
    }
    return self;
}

- (NSInteger)currentIndex{
    return [self.segmentArray indexOfObject:self.currentSelectSegment];
}

- (void)setOriginIndex:(NSInteger)originIndex{
    _originIndex = originIndex;
    if (originIndex >= 0 && originIndex < self.segmentArray.count) {
        self.currentSelectSegment.segmentType = ZXCustomSegmentTypeNormal;
        ZXCustomSegment *segment = [self.segmentArray objectAtIndex:originIndex];
        if (segment) {
            segment.segmentType = ZXCustomSegmentTypeSelected;
            self.currentSelectSegment = segment;
        }
    }
}

- (void)setBorderColor:(NSString *)borderColor{
    _borderColor = borderColor;
    self.layer.cornerRadius = ZXCustomSegmentHeight * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:borderColor].CGColor;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:borderColor];
}

- (void)setNormalBackColor:(NSString *)normalBackColor{
    _normalBackColor = normalBackColor;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.normalBackColor = normalBackColor;
        [segment updateContent];
    }
}

- (void)setSelectedBackColor:(NSString *)selectedBackColor{
    _selectedBackColor = selectedBackColor;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.selectedBackColor = selectedBackColor;
        [segment updateContent];
    }
}

- (void)setNormalTitleColor:(NSString *)normalTitleColor{
    _normalTitleColor = normalTitleColor;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.normalTitleColor = normalTitleColor;
        [segment updateContent];
    }
}

- (void)setSelectedTitleColor:(NSString *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.selectedTitleColor = selectedTitleColor;
        [segment updateContent];
    }
}

- (void)setSelectedBackImage:(NSString *)selectedBackImage{
    _selectedBackImage = selectedBackImage;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.selectedBackImage = selectedBackImage;
        [segment updateContent];
    }
}

- (void)setNormalBackImage:(NSString *)normalBackImage{
    _normalBackImage = normalBackImage;
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.normalBackImage = normalBackImage;
        [segment updateContent];
    }
}

- (void)configGradientBackColorWithStartColor:(NSString *)startColor endColor:(NSString *)endColor{
    for (ZXCustomSegment *segment in self.segmentArray) {
        segment.gradientStartColor = startColor;
        segment.gradientEndColor = endColor;
        [segment updateContent];
    }
}

- (void)configGradientBackColorWithStartColor:(NSString *)startColor endColor:(NSString *)endColor forIndex:(NSInteger)index{
    ZXCustomSegment *segment = [self.segmentArray objectAtIndex:index];
    segment.gradientStartColor = startColor;
    segment.gradientEndColor = endColor;
    [segment updateContent];
}

- (void)setTitle:(NSString *)title forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index{
    ZXCustomSegment *segment = [self.segmentArray objectAtIndex:index];
    if (segment) {
        switch (type) {
            case ZXCustomSegmentTypeNormal:
            {
                segment.normalTitle = title;
            }
                break;
            case ZXCustomSegmentTypeSelected:
            {
                segment.selectedTitle = title;
            }
                break;
                
            default:
                break;
        }
    }
    [segment updateContent];
}

- (void)setTitleColor:(NSString *)TitleColor forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index{
    ZXCustomSegment *segment = [self.segmentArray objectAtIndex:index];
    if (segment) {
        switch (type) {
            case ZXCustomSegmentTypeNormal:
            {
                segment.normalTitleColor = TitleColor;
            }
                break;
            case ZXCustomSegmentTypeSelected:
            {
                segment.selectedTitleColor = TitleColor;
            }
                break;
                
            default:
                break;
        }
    }
    [segment updateContent];
}

- (void)setBackImage:(NSString *)backImage forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index{
    ZXCustomSegment *segment = [self.segmentArray objectAtIndex:index];
    if (segment) {
        switch (type) {
            case ZXCustomSegmentTypeNormal:
            {
                segment.normalBackImage = backImage;
            }
                break;
            case ZXCustomSegmentTypeSelected:
            {
                segment.selectedBackImage = backImage;
            }
                break;
                
            default:
                break;
        }
    }
    [segment updateContent];
}

@end
