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
static NSInteger const ZXCustomSegmentHeight = 25;
static NSInteger const ZXCustomSegmentMargin = 15;


@interface UIView (ZXCustomSegmentedControl)

- (CAGradientLayer *)addGradientLayerWithColors:(NSArray *)colors frame:(CGRect)frame;

@end

@implementation UIView (ZXCustomSegmentedControl)

- (CAGradientLayer *)addGradientLayerWithColors:(NSArray *)colors frame:(CGRect)frame{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.frame = frame;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}

@end

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

@property (nonatomic, weak) MASConstraint *topConstraint;
@property (nonatomic, weak) MASConstraint *bottomConstraint;
@property (nonatomic, weak) MASConstraint *heightConstraint;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, copy) void(^clickCallBack)(ZXCustomSegment *segment ,BOOL executeBlock);

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
            make.height.mas_equalTo(self.mas_height);
            self.backImageWidthConstraint = make.width.mas_equalTo(0);
        }];
        self.segmentType = ZXCustomSegmentTypeNormal;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)]];
    }
    return self;
}

- (void)click{
    if (self.clickCallBack) {
        self.clickCallBack(self, YES);
    }
}

- (void)updateContent{
    [self.gradientLayer removeFromSuperlayer];
    switch (self.segmentType) {
        case ZXCustomSegmentTypeNormal:
        {
            self.backgroundColor = [UIColor colorWithHexString:self.normalBackColor];
            self.layer.mask.backgroundColor = [UIColor colorWithHexString:self.normalBackColor].CGColor;
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
            self.backgroundColor = [UIColor colorWithHexString:self.selectedBackColor];
            self.layer.mask.backgroundColor = [UIColor colorWithHexString:self.selectedBackColor].CGColor;
            
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

@property (nonatomic, strong) NSMutableArray <UIView *>*segmentArray;

@property (nonatomic, strong) ZXCustomSegment *currentSelectSegment;

@property (nonatomic, strong) NSMutableArray<UIView *> *intervalArray;

@property (nonatomic, strong) CAShapeLayer *leftArcLayer;

@property (nonatomic, strong) CAShapeLayer *rightArcLayer;


@end

@implementation ZXCustomSegmentedControl

- (instancetype)initWithItemArray:(NSArray <NSString *>*)itemArray
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _itemArray = itemArray;
        _segmentArray = [NSMutableArray array];
        _intervalArray = [NSMutableArray array];
      
        ZXCustomSegment *lastSegment = nil;
        for (int i = 0; i < _itemArray.count; i++) {
            NSString *title = [_itemArray objectAtIndex:i];
            ZXCustomSegment *segment = [[ZXCustomSegment alloc]init];
            
            segment.normalTitle = title;
            [_segmentArray addObject:segment];
            segment.segmentType = ZXCustomSegmentTypeNormal;
            __weak typeof(self)weakSelf = self;
            segment.clickCallBack = ^(ZXCustomSegment *segment, BOOL executeBlock)  {
                
                NSInteger segmentIndex = [weakSelf.segmentArray indexOfObject:segment];
                if (executeBlock &&weakSelf.willChangeIndexHandle) {
                    weakSelf.willChangeIndexHandle(weakSelf.currentIndex, segmentIndex);
                }
                
                NSInteger lastIndex = weakSelf.currentIndex;
                ZXCustomSegment *lastSegment = weakSelf.currentSelectSegment;
                weakSelf.currentSelectSegment.segmentType = ZXCustomSegmentTypeNormal;
                segment.segmentType = ZXCustomSegmentTypeSelected;
                weakSelf.currentSelectSegment = segment;
                if (executeBlock && weakSelf.didChangeIndexHandle) {
                    weakSelf.didChangeIndexHandle(weakSelf.currentIndex, lastIndex);
                }
                ZXCustomSegment *currentSegment = weakSelf.currentSelectSegment;
                if (lastSegment) {
                    lastSegment.topConstraint.mas_equalTo(1);
                    lastSegment.bottomConstraint.mas_equalTo(-1);
                    lastSegment.heightConstraint.mas_equalTo(ZXCustomSegmentHeight);
                }
                if (currentSegment) {
                    currentSegment.topConstraint.mas_equalTo(0);
                    currentSegment.bottomConstraint.mas_equalTo(0);
                    currentSegment.heightConstraint.mas_equalTo(ZXCustomSegmentHeight + 2);
                }
                
                NSInteger currentIndex = weakSelf.currentIndex;
                if (lastIndex == 0) {
                    weakSelf.intervalArray.firstObject.hidden = NO;
                }
                else if (lastIndex == self.segmentArray.count -1){
                    weakSelf.intervalArray.lastObject.hidden = NO;
                }
                else{
                    [weakSelf.intervalArray objectAtIndex:lastIndex - 1].hidden = NO;
                    [weakSelf.intervalArray objectAtIndex:lastIndex].hidden = NO;
                }
                
                if (currentIndex == 0) {
                    weakSelf.intervalArray.firstObject.hidden = YES;
                }
                else if (currentIndex == self.segmentArray.count -1){
                    weakSelf.intervalArray.lastObject.hidden = YES;
                }
                else{
                    [weakSelf.intervalArray objectAtIndex:currentIndex -1].hidden = YES;
                    [weakSelf.intervalArray objectAtIndex:currentIndex].hidden = YES;
                }
            };
            [self addSubview:segment];
            if (i == 0) {
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    segment.topConstraint = make.top.mas_equalTo(1);
                    segment.bottomConstraint = make.bottom.mas_equalTo(-1);
                    segment.heightConstraint = make.height.mas_equalTo(ZXCustomSegmentHeight).priority(MASLayoutPriorityDefaultHigh);
                }];
            }
            else if (i == _itemArray.count -1){
               
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right);
                    make.right.mas_equalTo(0);
                    segment.topConstraint = make.top.mas_equalTo(1);
                    segment.bottomConstraint = make.bottom.mas_equalTo(-1);
                    segment.heightConstraint = make.height.mas_equalTo(ZXCustomSegmentHeight);
                }];
                
                UIView *intervalView = [[UIView alloc]init];
                intervalView.backgroundColor = [UIColor clearColor];
                [self addSubview:intervalView];
                [intervalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right).offset(-0.5);
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(1);
                }];
                [self.intervalArray addObject:intervalView];
                
            }
            else{
                [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right);
                    segment.topConstraint = make.top.mas_equalTo(1);
                    segment.bottomConstraint = make.bottom.mas_equalTo(-1);
                    segment.heightConstraint = make.height.mas_equalTo(ZXCustomSegmentHeight);
                }];
                UIView *intervalView = [[UIView alloc]init];
                intervalView.backgroundColor = [UIColor clearColor];
                [self addSubview:intervalView];
                [intervalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastSegment.mas_right).offset(-0.5);
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(1);
                }];
                [self.intervalArray addObject:intervalView];
            }
            lastSegment = segment;
        }
        self.originIndex = 0;
        self.borderColor = @"#FF5500";
    }
    return self;
}

- (void)layoutSegmentCtrlToView:(UIView *)superView centerPosition:(CGPoint)center{
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(center.x - superView.center.x);
        make.centerY.mas_equalTo(center.y - superView.center.y);
//        make.centerX.mas_equalTo(superView.mas_top);
//        make.centerY.mas_equalTo(superView.mas_left);
    }];
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1 constant:center.x]];
//    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:center.y]];
}

- (void)layoutSubviews{
    if (self.frame.size.width != 0 && !self.layer.mask) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.bounds.size.height * 0.5 , self.bounds.size.height * 0.5)];
        maskPath.lineWidth = 5;
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

        maskLayer.frame = self.bounds;

        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        CAShapeLayer *leftArcLayer=[CAShapeLayer layer];
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 addArcWithCenter:CGPointMake(self.bounds.size.height * 0.5 , self.bounds.size.height * 0.5) radius:(ZXCustomSegmentHeight + 1) * 0.5 startAngle:0.5f *((float)M_PI) endAngle:1.5f * ((float)M_PI) clockwise:YES];
        leftArcLayer.fillColor = [UIColor clearColor].CGColor;
        leftArcLayer.strokeColor = [UIColor colorWithHexString:self.borderColor].CGColor;
        leftArcLayer.lineWidth = 1;
        leftArcLayer.path = path1.CGPath;
        self.leftArcLayer = leftArcLayer;
        CAShapeLayer *rightArcLayer = [CAShapeLayer layer];
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 addArcWithCenter:CGPointMake(self.frame.size.width - self.bounds.size.height * 0.5 , self.bounds.size.height * 0.5) radius:(ZXCustomSegmentHeight + 1) * 0.5 startAngle:1.5f *((float)M_PI) endAngle:0.5f * ((float)M_PI) clockwise:YES];
        rightArcLayer.fillColor = [UIColor clearColor].CGColor;
        rightArcLayer.strokeColor = [UIColor colorWithHexString:self.borderColor].CGColor;
        rightArcLayer.lineWidth = 1;
        rightArcLayer.path = path2.CGPath;
        self.rightArcLayer = rightArcLayer;
    }
    if (self.currentIndex != 0) {
        [self.layer addSublayer:self.leftArcLayer];
    }
    else{
        [self.leftArcLayer removeFromSuperlayer];
    }
    
    if (self.currentIndex != self.segmentArray.count - 1) {
        [self.layer addSublayer:self.rightArcLayer];
    }
    else{
        [self.rightArcLayer removeFromSuperlayer];
    }
}

- (NSInteger)currentIndex{
    return [self.segmentArray indexOfObject:self.currentSelectSegment];
}

- (void)setOriginIndex:(NSInteger)originIndex{
    _originIndex = originIndex;
    if (originIndex >= 0 && originIndex < self.segmentArray.count) {
        NSInteger lastIndex = self.currentIndex;
        ZXCustomSegment *lastSegment = self.currentSelectSegment;
        self.currentSelectSegment.segmentType = ZXCustomSegmentTypeNormal;
        
        ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:originIndex];
        segment.segmentType = ZXCustomSegmentTypeSelected;
        
        self.currentSelectSegment = segment;
        NSInteger currentIndex = self.currentIndex;
        ZXCustomSegment *currentSegment = self.currentSelectSegment;
        if (lastSegment) {
            lastSegment.topConstraint.mas_equalTo(1);
            lastSegment.bottomConstraint.mas_equalTo(-1);
            lastSegment.heightConstraint.mas_equalTo(ZXCustomSegmentHeight);
        }
        if (currentSegment) {
            currentSegment.topConstraint.mas_equalTo(0);
            currentSegment.bottomConstraint.mas_equalTo(0);
            currentSegment.heightConstraint.mas_equalTo(ZXCustomSegmentHeight +2);
        }
        if (lastIndex == 0) {
            self.intervalArray.firstObject.hidden = NO;
        }
        else if (lastIndex == self.segmentArray.count -1){
            self.intervalArray.lastObject.hidden = NO;
        }
        else if (lastIndex >= 0 && lastIndex < self.segmentArray.count){
            [self.intervalArray objectAtIndex:lastIndex -1].hidden = NO;
            [self.intervalArray objectAtIndex:lastIndex].hidden = NO;
        }
        
        if (currentIndex == 0) {
            self.intervalArray.firstObject.hidden = YES;
        }
        else if (currentIndex == self.segmentArray.count -1){
            self.intervalArray.lastObject.hidden = YES;
        }
        else if (currentIndex >= 0 && currentIndex < self.segmentArray.count){
            [self.intervalArray objectAtIndex:currentIndex -1].hidden = YES;
            [self.intervalArray objectAtIndex:currentIndex].hidden = YES;
        }
    }
}

- (void)setBorderColor:(NSString *)borderColor{
    _borderColor = borderColor;
    self.backgroundColor = [UIColor colorWithHexString:borderColor];
    [self.intervalArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((UIView *)obj).backgroundColor = [UIColor colorWithHexString:borderColor];
    }];
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
    ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:index];
    segment.gradientStartColor = startColor;
    segment.gradientEndColor = endColor;
    [segment updateContent];
}

- (void)setTitle:(NSString *)title forType:(ZXCustomSegmentType)type forIndex:(NSInteger)index{
    ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:index];
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
    ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:index];
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
    ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:index];
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

- (void)changeSelectIndex:(NSInteger)index executeBlock:(BOOL)isExecute{
    ZXCustomSegment *segment = (ZXCustomSegment *)[self.segmentArray objectAtIndex:index];
    if (segment.clickCallBack) {
        segment.clickCallBack(segment, isExecute);
    }
}

@end

