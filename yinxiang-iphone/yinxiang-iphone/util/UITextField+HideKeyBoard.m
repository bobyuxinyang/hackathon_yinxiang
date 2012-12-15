//
//  UITextField+HideKeyBoard.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/16/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "UITextField+HideKeyBoard.h"

@implementation UITextField (HideKeyBoard)

- (void)hideKeyBoard:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(doHideKeyBoard)];
    
    tap.numberOfTapsRequired = 1;
    [view  addGestureRecognizer: tap];
    [tap setCancelsTouchesInView:NO];
}

- (void)doHideKeyBoard{
    [self resignFirstResponder];
}

@end
