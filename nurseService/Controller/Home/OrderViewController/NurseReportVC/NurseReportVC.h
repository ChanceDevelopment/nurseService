//
//  NurseReportVC.h
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface NurseReportVC : HeBaseViewController
{
    NSDictionary *infoData;
}
@property (strong, nonatomic)NSDictionary *infoData;
@property (assign, nonatomic)BOOL isDetail; //YES 详情展示
@property (assign, nonatomic)NSInteger reportType; //  0 已完成订单查看, 1 我的护理报告查看, 2 填写护理报告 YES 详情展示

@end
