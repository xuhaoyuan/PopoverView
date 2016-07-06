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


@interface PopUpMenu()
{
    CGFloat _borderWidth;
    UIViewController *_superView;
}
@property (nonatomic, strong) NSDictionary *ListDic;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *popViewArray;
@property (nonatomic, strong) NSArray *btnListArr;
@property (nonatomic, strong) PopoverView *popView;


@end


@implementation PopUpMenu


-(id)initWithFrame:(CGRect)frame Dic:(NSDictionary *)diction Con:(UIViewController *)controller WithClickBacK:(buttonClick)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTouchNum:touch];
        self.ListDic = diction;
        _borderWidth = 0.25f;
        _superView = controller;
        self.btnListArr = [self.ListDic objectForKey:@"listName"];;
        [self addButtonWithTitle:[self.ListDic objectForKey:@"name"]];
        
        
    }
    return self;
}
- (NSMutableArray *)tagArray{
    if (!_tagArray ) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    return _tagArray;
}
-(NSMutableArray *)popViewArray{
    if (!_popViewArray) {
        _popViewArray = [[NSMutableArray alloc] init];
    }
    return _popViewArray;
}
- (void)addButtonWithTitle:(NSArray *)titles{
    
    [titles enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/titles.count * idx, 0 , CGRectGetWidth(self.frame)/titles.count, CGRectGetHeight(self.frame))];
        [self addSubview:button];
        [button setBackgroundColor:[UIColor colorWithWhite:0.976 alpha:1.000]];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.318 alpha:1.000] forState:UIControlStateNormal];
        [button setTag:idx +333];
        [button.layer setBorderWidth:0.5f];
        [button.layer setBorderColor:[UIColor colorWithWhite:0.804 alpha:1.000].CGColor];
        CGRect buttonReck = button.frame;
        buttonReck.origin.x = CGRectGetMinX(buttonReck) - _borderWidth;
        buttonReck.size.width = CGRectGetWidth(buttonReck) + _borderWidth * 2 ;
        button.frame = buttonReck;
        [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }];
}

- (void)buttonTouch:(UIButton *)Btn{
    [self popViewRemove];
    if (Btn.tag - 333 <= self.btnListArr.count-1) {
        [self addlistButton:self.btnListArr[Btn.tag - 333] buttonFrame:Btn];
    }
}


- (void)addlistButton:(NSArray *)listArray buttonFrame:(UIButton* )btn{
    
    [self.tagArray addObject:[NSNumber numberWithInteger:btn.tag]];
    if (self.tagArray.count > 2) {
        [self.tagArray removeObjectAtIndex:0];
    }
    
    if(self.tagArray .count == 2  &&
       ([[self.tagArray firstObject]integerValue] == [(NSNumber *)[self.tagArray lastObject]integerValue])){
        
        [self.tagArray removeAllObjects];
        return;
        
    }else{
        CGRect viewFram = btn.frame;
        viewFram.size.height = listArray.count *ButtonHeight + ViewHeight;
        viewFram.origin.x = viewFram.origin.x +10;
        viewFram.size.width = viewFram.size.width - 20;
        viewFram.origin.y =CGRectGetHeight(_superView.view.frame) - CGRectGetHeight(btn.frame)- ViewHeight;
        
        self.popView = [[PopoverView alloc]initWithFrame:viewFram listTitle:listArray];
        UITapGestureRecognizer *topges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewGes)];
        [_superView.view addGestureRecognizer:topges];
        __weak typeof(self) vc = self;
        [self.popView setListBtnClick:^(NSInteger num) {
            vc.touchNum((btn.tag - 333)* 10 + num);
            [vc.popView removeFromSuperview];
        }];
        
        viewFram.size.height = 0;
        [self.popView setClipsToBounds:YES];
        [self.popView setFrame:viewFram];
        [self.popView setAlpha:0];
        [self.popView setTag:btn.tag+300];
        [self.popViewArray addObject:self.popView];
        [_superView.view addSubview:self.popView];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect viewFrame = viewFram;
            viewFrame.size.height = listArray.count *ButtonHeight + ViewHeight;
            viewFrame.origin.y = CGRectGetHeight(_superView.view.frame) - CGRectGetHeight(btn.frame)- ViewHeight -viewFrame.size.height;
            [self.popView setFrame:viewFrame];
            [self.popView setAlpha:1];
        }];
    }
    

    
}
- (void)superViewGes{
    [self popViewRemove];
    
    
}
- (void)popViewRemove{

    if (self.popViewArray.count == 1) {
        PopoverView *view = (PopoverView *)self.popViewArray[0];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect viewReck = view.frame;
            viewReck.origin.y = viewReck.origin.y + viewReck.size.height;
            viewReck.size.height = 0;
            [view setFrame:viewReck];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        [self.popViewArray removeObjectAtIndex:0];

    }
}

@end



@interface  PopoverView()
{
    NSArray *_array;
}
@end

@implementation PopoverView


- (id)initWithFrame:(CGRect)frame listTitle:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _array = array;
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
        [button setTag:idx +888];
    }];
    
}

- (void)buttonClick:(UIButton *)button{
    self.listBtnClick(button.tag - 888);
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
        [_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        if (idx == _array.count -1 ) {
            return ;
        }
        [[UIColor colorWithRed:0.784 green:0.796 blue:0.749 alpha:1.000] set];
        [bezier setLineWidth:0.5f];
        CGFloat x = 10;
        CGFloat xm = rect.size.width - 10;
        CGFloat y = (rect.size.height - ViewHeight) / _array.count * idx + (rect.size.height - ViewHeight) / _array.count;
        
        [bezier moveToPoint:(CGPoint){x, y}];
        [bezier addLineToPoint:(CGPoint){xm,y}];
        [bezier stroke];

        
    }];
    
    
}
     
@end






