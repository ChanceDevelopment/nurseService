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
@property (assign, nonatomic)BOOL isDetail;

@end
