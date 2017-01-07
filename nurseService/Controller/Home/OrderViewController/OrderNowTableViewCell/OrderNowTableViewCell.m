//
//  OrderNowTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/1.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "OrderNowTableViewCell.h"

@implementation OrderNowTableViewCell
@synthesize serviceContentL;
@synthesize stopTimeL;
@synthesize orderMoney;
@synthesize addressL;
@synthesize userInfoL;
@synthesize orderInfoDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        CGFloat bgView_W = SCREENWIDTH-10;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, bgView_W, 150)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView.layer setMasksToBounds:YES];
        bgView.layer.cornerRadius = 4.0;
        
        CGFloat serviceContentLX = 10;
        CGFloat serviceContentLY = 5;
        CGFloat serviceContentLW = SCREENWIDTH - serviceContentLX;
        CGFloat serviceContentLH = 44;
        
        serviceContentL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX, serviceContentLY, serviceContentLW, serviceContentLH)];
        serviceContentL.userInteractionEnabled = YES;
        serviceContentL.textColor = APPDEFAULTORANGE;
        serviceContentL.font = [UIFont systemFontOfSize:15.0];
        serviceContentL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:serviceContentL];
        
        UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_W-30, 14, 20, 20)];
        rightV.backgroundColor = [UIColor clearColor];
        rightV.image = [UIImage imageNamed:@"icon_into_right"];
        rightV.userInteractionEnabled = YES;
        [bgView addSubview:rightV];
        
        UITapGestureRecognizer *showOrderDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderDetail)];
        [serviceContentL addGestureRecognizer:showOrderDetailTap];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 44, bgView_W-10, 1)];
        [bgView addSubview:line];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        CGFloat timeAddressViewX = 0;
        CGFloat timeAddressViewY = CGRectGetMaxY(line.frame);
        CGFloat timeAddressViewW = SCREENWIDTH;
        CGFloat timeAddressViewH = 46;
        UIView *timeAddressView = [[UIView alloc] initWithFrame:CGRectMake(timeAddressViewX, timeAddressViewY, timeAddressViewW, timeAddressViewH)];
        timeAddressView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:timeAddressView];
        
        stopTimeL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        stopTimeL.textColor = [UIColor blackColor];
        stopTimeL.font = [UIFont systemFontOfSize:12.0];
        stopTimeL.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:stopTimeL];
        
        orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-150, 0, 130, 20)];
        orderMoney.textColor = [UIColor orangeColor];
        orderMoney.textAlignment = NSTextAlignmentRight;
        orderMoney.font = [UIFont systemFontOfSize:12.0];
        orderMoney.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:orderMoney];

        addressL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(stopTimeL.frame), 300, 20)];
        addressL.textColor = [UIColor blackColor];
        addressL.font = [UIFont systemFontOfSize:12.0];
        addressL.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:addressL];
        
        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, CGRectGetMaxY(stopTimeL.frame), 20, 20)];
        [locationImageView setBackgroundColor:[UIColor clearColor]];
        locationImageView.userInteractionEnabled = YES;
        locationImageView.image = [UIImage imageNamed:@"icon_address"];
        [timeAddressView addSubview:locationImageView];
        
        UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLocationView)];
        locationTap.numberOfTapsRequired = 1;
        locationTap.numberOfTouchesRequired = 1;
        [timeAddressView addGestureRecognizer:locationTap];
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 91, bgView_W-10, 1)];
        [bgView addSubview:line1];
        line1.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UILabel *userTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 91, 200, 20)];
        userTip.textColor = [UIColor blackColor];
        userTip.text = @"患者信息";
        userTip.font = [UIFont systemFontOfSize:12.0];
        userTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userTip];

        userInfoL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-160, 91, 130, 20)];
        userInfoL.textColor = [UIColor blackColor];
        userInfoL.userInteractionEnabled = YES;
        userInfoL.font = [UIFont systemFontOfSize:12.0];
        userInfoL.textAlignment = NSTextAlignmentRight;
        userInfoL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userInfoL];

        UIImageView *rightV1 = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_W-20, 96, 10, 10)];
        rightV1.backgroundColor = [UIColor clearColor];
        rightV1.image = [UIImage imageNamed:@"icon_into_right"];
        rightV1.userInteractionEnabled = YES;
        [bgView addSubview:rightV1];
        
        UITapGestureRecognizer *userInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [userInfoL addGestureRecognizer:userInfoTap];
        
        UILabel *cancleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, 90, 35)];
        cancleL.textColor = [UIColor grayColor];
        cancleL.userInteractionEnabled = YES;
        cancleL.textAlignment = NSTextAlignmentCenter;
        cancleL.font = [UIFont systemFontOfSize:12.0];
        cancleL.text = @"请求取消";
        cancleL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:cancleL];
        
        UITapGestureRecognizer *cancleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleRequst)];
        [cancleL addGestureRecognizer:cancleTap];

        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 113, 1, 30)];
        [bgView addSubview:line2];
        line2.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];

        
        UILabel *nextStepL = [[UILabel alloc] initWithFrame:CGRectMake(90, 111, SCREENWIDTH-100, 35)];
        nextStepL.textColor = [UIColor grayColor];
        nextStepL.userInteractionEnabled = YES;
        nextStepL.textAlignment = NSTextAlignmentCenter;
        nextStepL.font = [UIFont systemFontOfSize:12.0];
        nextStepL.text = @"下一步（填写报告）";
        nextStepL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:nextStepL];
        
        UITapGestureRecognizer *nextStepTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextStepRequst)];
        [nextStepL addGestureRecognizer:nextStepTap];
        
    }
    return self;
}

- (void)showOrderDetail{
    if (self.showOrderDetailBlock) {
        self.showOrderDetailBlock();
    }
}

- (void)cancleRequst{
    if (self.cancleRequstBlock) {
        self.cancleRequstBlock();
    }
}

- (void)nextStepRequst{
    if (self.nextStepBlock) {
        self.nextStepBlock();
    }
}

- (void)goToLocationView{
    if (self.locationBlock) {
        self.locationBlock();
    }
}

- (void)showUserInfo{
    if (self.showUserInfoBlock) {
        self.showUserInfoBlock();
    }
}

@end
