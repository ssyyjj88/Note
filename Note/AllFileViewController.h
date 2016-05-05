//
//  AllFileViewController.h
//  Note
//
//  Created by syj on 16/4/28.
//  Copyright © 2016年 syj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllFileViewController : UIViewController

@property (strong) NSArray *dataSource;
@property (strong) void (^select)(int);

@end
