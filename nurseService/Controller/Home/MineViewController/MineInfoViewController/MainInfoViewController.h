//
//  MainInfoViewController.h
//  nurseService
//
//  Created by 梅阳阳 on 16/12/20.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeBaseViewController.h"

@interface MainInfoViewController : HeBaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *telephoneNum;
@property (strong, nonatomic) IBOutlet UILabel *idCardNum;
@property (strong, nonatomic) IBOutlet UILabel *sexType;
@property (strong, nonatomic) IBOutlet UILabel *advantageInfo;
@property (strong, nonatomic) IBOutlet UILabel *addressInfo;

@end
