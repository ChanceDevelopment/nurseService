//
//  OrderRecTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/1.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "OrderRecTableViewCell.h"

@implementation OrderRecTableViewCell
@synthesize serviceContentL;
@synthesize orderMoney;
@synthesize stopTimeL;
@synthesize addressL;
@synthesize userInfoL;
@synthesize remarkInfoL;
@synthesize exclusiveImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        CGFloat bgView_W = SCREENWIDTH-10;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 40, bgView_W, 150)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView.layer setMasksToBounds:YES];
        bgView.layer.cornerRadius = 4.0;
        
        exclusiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 50)];
        exclusiveImageView.backgroundColor = [UIColor clearColor];
        exclusiveImageView.image = [UIImage imageNamed:@"img_exclusive"];
        exclusiveImageView.userInteractionEnabled = YES;
        [self addSubview:exclusiveImageView];
        
        CGFloat serviceContentLX = 10;
        CGFloat serviceContentLY = 5;
        CGFloat serviceContentLW = SCREENWIDTH - 100;
        CGFloat serviceContentLH = 35;
        
        serviceContentL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX, serviceContentLY, serviceContentLW, serviceContentLH)];
        serviceContentL.userInteractionEnabled = YES;
        serviceContentL.textColor = [UIColor blackColor];
        serviceContentL.font = [UIFont systemFontOfSize:15.0];
        serviceContentL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:serviceContentL];
        
        UILabel *payTip = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-150, 5, 50, 35)];
        payTip.textColor = [UIColor grayColor];
        payTip.userInteractionEnabled = YES;
        payTip.textAlignment = NSTextAlignmentRight;
        payTip.font = [UIFont systemFontOfSize:12.0];
        payTip.text = @"预计收入";
        payTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:payTip];

        orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-100, 5, 80, 35)];
        orderMoney.textColor = [UIColor orangeColor];
        orderMoney.font = [UIFont systemFontOfSize:12.0];
        orderMoney.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderMoney];
        
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
        locationTap.numberOfTapsRequired = 1;
        timeAddressView.userInteractionEnabled = YES;
        [timeAddressView addGestureRecognizer:locationTap];
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 91, bgView_W-10, 1)];
        [bgView addSubview:line1];
        line1.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UILabel *userTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 91, 200, 30)];
        userTip.textColor = [UIColor blackColor];
        userTip.text = @"服务信息";
        userTip.font = [UIFont systemFontOfSize:12.0];
        userTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userTip];
        
        userInfoL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-160, 91, 130, 30)];
        userInfoL.textColor = [UIColor blackColor];
        userInfoL.userInteractionEnabled = YES;
        userInfoL.font = [UIFont systemFontOfSize:12.0];
        userInfoL.textAlignment = NSTextAlignmentRight;
        userInfoL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userInfoL];
        
        UIImageView *rightV1 = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_W-20, 101, 10, 10)];
        rightV1.backgroundColor = [UIColor clearColor];
        rightV1.image = [UIImage imageNamed:@"icon_into_right"];
        rightV1.userInteractionEnabled = YES;
        [bgView addSubview:rightV1];
        
        UITapGestureRecognizer *userInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [userInfoL addGestureRecognizer:userInfoTap];

        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 121, bgView_W-10, 1)];
        [bgView addSubview:line2];
        line2.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UILabel *remarkTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 121, 200, 30)];
        remarkTip.textColor = [UIColor blackColor];
        remarkTip.text = @"备注信息";
        remarkTip.font = [UIFont systemFontOfSize:12.0];
        remarkTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:remarkTip];
        
        remarkInfoL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-160, 121, 130, 30)];
        remarkInfoL.textColor = [UIColor blackColor];
        remarkInfoL.userInteractionEnabled = YES;
        remarkInfoL.font = [UIFont systemFontOfSize:12.0];
        remarkInfoL.textAlignment = NSTextAlignmentRight;
        remarkInfoL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:remarkInfoL];
        
    }
    return self;
}

-(void)showOrderDetail{
    if (self.showOrderDetailBlock) {
        self.showOrderDetailBlock();
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
