//
//  PopUpMenu.h
//  PopUp
//
//  Created by XU on 15/9/4.
//  Copyright © 2015年 ASOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpMenu : UIView

typedef void(^buttonClick)(NSInteger section, NSInteger row);



+ showViewWithFrame:(CGRect)frame Dic:(NSDictionary *)diction Con:(UIViewController *)controller WithClickBacK:(buttonClick)touch;


@end


