//
//  HeOrderDetailVC.h
//  nurseService
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"



@interface HeOrderDetailVC : HeBaseViewController
{
    NSDictionary *infoDic;
    NSString *orderId;
}
@property(strong,nonatomic)NSDictionary *infoDic;
@property(strong,nonatomic)NSString *orderId;


@end
