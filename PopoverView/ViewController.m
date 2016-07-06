//
//  ViewController.m
//  PopoverView
//
//  Created by XU on 15/9/4.
//  Copyright (c) 2015年 ASOU. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "PopUpMenu.h"

@interface ViewController ()
#define H_SCREEN  [UIScreen mainScreen].bounds.size.height
#define W_SCREEN  [UIScreen mainScreen].bounds.size.width


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  修改 需要显示的选项
     */
    
    NSDictionary *dic = @{
                          @"name": @[
                                  @"AA",
                                  @"BB",
                                  @"CC",
                                  ],
                          @"listName": @[
                                  @[
                                      @"A1",
                                      @"A2",
                                      @"A2",
                                      @"A2",
                                      @"A3"
                                      ],
                                  @[
                                      @"B1",
                                      @"B2",
                                      @"B2",
                                      @"B2",
                                      @"B2",
                                      @"B2",
                                      @"B3"
                                      ],
                                  @[
                                      @"C1",
                                      @"C2",
                                      @"C3",
                                      @"123",
                                      @"asdadasd"
                                      ]
                                  ]
                          };
    
    [PopUpMenu showViewWithFrame:CGRectMake(0, H_SCREEN - 50, W_SCREEN, 50) Dic:dic Con:self WithClickBacK:^(NSInteger section, NSInteger num) {
        
        FirstViewController *first = [[FirstViewController alloc] init];
        [first setTitle:[NSString stringWithFormat:@"%ld--%ld",section,num]];
        [self.navigationController pushViewController:first animated:YES];
        
    }];
    
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
