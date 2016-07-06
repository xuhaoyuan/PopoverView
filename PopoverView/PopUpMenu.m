//
//  PopUpMenu.m
//  PopUp
//
//  Created by XU on 15/9/4.
//  Copyright © 2015年 ASOU. All rights reserved.
//

#import "PopUpMenu.h"


/**
 *  修改 倒三角大小
 */
const CGFloat ViewHeight = 5.f;
/**
 *  修改按钮高度
 */
const CGFloat ButtonHeight = 40.f;


@interface  PopoverView: UIView

@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, copy)buttonClick listBtnClick;

@property (nonatomic, assign) NSInteger section;

- (id)initWithFrame:(CGRect)frame listTitle:(NSArray *)array callBack:(buttonClick)click;

@end

@implementation PopoverView


- (id)initWithFrame:(CGRect)frame listTitle:(NSArray *)array callBack:(buttonClick)click{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.alpha = 0;
        self.listBtnClick = click;
        self.rowArray = array;
        [self addPopoverMenuTitle:array];
    }
    return self;
}

- (void) addPopoverMenuTitle:(NSArray *)titleArr{
    
    [titleArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        CGFloat Y = (CGRectGetHeight(self.frame) - ViewHeight)/titleArr.count * idx;
        CGFloat W = CGRectGetWidth(self.frame);
        CGFloat H = (CGRectGetHeight(self.frame) - ViewHeight)/titleArr.count;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,Y,W,H)];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTag:idx + 88];
    }];
    
}

- (void)buttonClick:(UIButton *)button{
    
    self.listBtnClick(_section,button.tag - 88);
}


- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath setLineWidth:1];
    [arrowPath setLineCapStyle:kCGLineCapSquare];
    const CGFloat arrowXM = CGRectGetWidth(self.frame)-1;
    const CGFloat arrowY0 = CGRectGetHeight(self.frame)-ViewHeight;
    const CGFloat arrowX0 = CGRectGetWidth(self.frame)/2 - ViewHeight;
    const CGFloat arrowX1 = CGRectGetWidth(self.frame)/2 + ViewHeight;
    const CGFloat arrowYL = CGRectGetHeight(self.frame) - 1;
    const CGFloat arrowXL = CGRectGetWidth(self.frame)/2;
    
    [arrowPath moveToPoint:    (CGPoint){1, 1}];
    [arrowPath addLineToPoint: (CGPoint){arrowXM, 1}];
    [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowXL, arrowYL}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){1, arrowY0}];
    [arrowPath closePath];
    
    [[UIColor colorWithWhite:0.976 alpha:1.000] setFill];
    [[UIColor colorWithRed:0.784 green:0.796 blue:0.749 alpha:1.000] setStroke];
    
    [arrowPath stroke];
    [arrowPath fill];
    
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    
    [bezier setLineWidth:0.5f];
    
    __weak typeof(self) _self = self;
    [_rowArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        if (idx == _self.rowArray.count -1 ) {
            return ;
        }
        [[UIColor colorWithRed:0.784 green:0.796 blue:0.749 alpha:1.000] set];
        [bezier setLineWidth:0.5f];
        CGFloat x = 10;
        CGFloat xm = rect.size.width - 10;
        CGFloat y = (rect.size.height - ViewHeight) / _self.rowArray.count * idx + (rect.size.height - ViewHeight) / _self.rowArray.count;
        
        [bezier moveToPoint:(CGPoint){x, y}];
        [bezier addLineToPoint:(CGPoint){xm,y}];
        [bezier stroke];
        
        
    }];
    
    
}

@end


@interface PopUpMenu()
{
    CGFloat _borderWidth;
    UIViewController *_superView;
}
@property (nonatomic, strong) NSDictionary *ListDic;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSArray *btnListArr;
@property (nonatomic, copy) buttonClick touchNum;


@end


@implementation PopUpMenu

+(instancetype)showViewWithFrame :(CGRect)frame Dic:(NSDictionary *)diction Con:(UIViewController *)controller WithClickBacK:(buttonClick)touch{
    
    PopUpMenu *pop = [[PopUpMenu alloc]initWithFrame:frame Dic:diction Con:controller WithClickBacK:touch];
    [controller.view addSubview:pop];
    return pop;
}

-(instancetype)initWithFrame:(CGRect)frame Dic:(NSDictionary *)diction Con:(UIViewController *)controller WithClickBacK:(buttonClick)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTouchNum:touch];
        self.ListDic = diction;
        _borderWidth = 0.25f;
        _superView = controller;
        self.btnListArr = [self.ListDic objectForKey:@"listName"];;
        [self addButtonWithTitle:[self.ListDic objectForKey:@"name"]];
        
        UITapGestureRecognizer *topges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewGes)];
        [_superView.view addGestureRecognizer:topges];
    }
    return self;
}

- (void)addButtonWithTitle:(NSArray *)titles{
    
    [titles enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/titles.count * idx, 0 , CGRectGetWidth(self.frame)/titles.count, CGRectGetHeight(self.frame))];
        [self addSubview:button];
        [button setBackgroundColor:[UIColor colorWithWhite:0.976 alpha:1.000]];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.318 alpha:1.000] forState:UIControlStateNormal];
        [button setTag:idx];
        [button.layer setBorderWidth:0.5f];
        [button.layer setBorderColor:[UIColor colorWithWhite:0.804 alpha:1.000].CGColor];
        
        CGRect buttonReck = button.frame;
        buttonReck.origin.x = CGRectGetMinX(buttonReck) - _borderWidth;
        buttonReck.size.width = CGRectGetWidth(buttonReck) + _borderWidth * 2 ;
        button.frame = buttonReck;
        [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }];
}

- (void)buttonTouch:(UIButton *)btn{
    
    if ([self needToLoadWith:btn.tag]) {
        [self popViewRemoveWith:btn.tag];
        [self addlistButton:self.btnListArr[btn.tag] buttonFrame:btn];
    }else{
        [self popViewRemoveWith:btn.tag];
    }
}


- (void)addlistButton:(NSArray *)listArray buttonFrame:(UIButton* )btn{
    
    CGRect viewFram = btn.frame;
    viewFram.size.height = listArray.count *ButtonHeight + ViewHeight;
    viewFram.origin.x = viewFram.origin.x +10;
    viewFram.size.width = viewFram.size.width - 20;
    viewFram.origin.y = CGRectGetHeight(_superView.view.frame) - CGRectGetHeight(self.frame);
    
    PopoverView *popView = [[PopoverView alloc]initWithFrame:viewFram listTitle:listArray callBack:self.touchNum];

    [popView setSection:btn.tag];
    
    [_superView.view insertSubview:popView belowSubview:self];
    
    viewFram.origin.y = CGRectGetHeight(_superView.view.frame) - CGRectGetHeight(self.frame) - ViewHeight -viewFram.size.height;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        [popView setFrame:viewFram];
        [popView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)superViewGes{
    [self popViewRemoveWith:-1];
    
}
- (BOOL)needToLoadWith:(NSInteger)btnTag{
    
    for (UIView *view in _superView.view.subviews) {
        if ([view isKindOfClass:[PopoverView class]]) {
            return ((PopoverView *)view).section == btnTag ? NO : YES;
        }
    }
    return YES;
}
- (void)popViewRemoveWith:(NSInteger)btnTag{
    
    for (UIView *view in _superView.view.subviews) {
        if ([view isKindOfClass:[PopoverView class]]) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect viewReck = view.frame;
                viewReck.origin.y = CGRectGetHeight(_superView.view.frame);
                [view setFrame:viewReck];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
            
        }
    }
}

@end








