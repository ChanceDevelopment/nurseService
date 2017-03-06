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
@synthesize userInfoL1;
@synthesize remarkInfoL;
@synthesize exclusiveImageView;
@synthesize sendTimeL;
@synthesize orderNumL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        CGFloat bgView_W = SCREENWIDTH-10;
        CGFloat bgView_H = cellsize.height;//400+40;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 40, bgView_W, bgView_H)];
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
        CGFloat serviceContentLW = SCREENWIDTH - 180;
        CGFloat serviceContentLH = 35;
        
        serviceContentL = [[UILabel alloc] initWithFrame:CGRectMake(serviceContentLX+30, serviceContentLY, serviceContentLW, serviceContentLH)];
        serviceContentL.userInteractionEnabled = YES;
        serviceContentL.textColor = APPDEFAULTTITLECOLOR;
        serviceContentL.font = [UIFont systemFontOfSize:15.0];
        serviceContentL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:serviceContentL];
        serviceContentL.adjustsFontSizeToFitWidth = YES;

        CGFloat payTipX = CGRectGetMaxX(serviceContentL.frame);
        UILabel *payTip = [[UILabel alloc] initWithFrame:CGRectMake(payTipX, 5, 50, 35)];
        payTip.textColor = [UIColor grayColor];
        payTip.userInteractionEnabled = YES;
        payTip.textAlignment = NSTextAlignmentRight;
        payTip.font = [UIFont systemFontOfSize:12.0];
        payTip.text = @"预计收入";
        payTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:payTip];

        CGFloat orderMoneyX = CGRectGetMaxX(payTip.frame);
        orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(orderMoneyX, 5, 55, 35)];
        orderMoney.textColor = [UIColor redColor];
        orderMoney.font = [UIFont systemFontOfSize:12.0];
        orderMoney.backgroundColor = [UIColor clearColor];
        orderMoney.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:orderMoney];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 44, bgView_W-10, 1)];
        [bgView addSubview:line];
        line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        
        UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(5, 44+40, bgView_W-10, 1)];
        [bgView addSubview:line6];
        line6.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        CGFloat timeAddressViewX = 0;
        CGFloat timeAddressViewY = CGRectGetMaxY(line6.frame);
        CGFloat timeAddressViewW = SCREENWIDTH;
        CGFloat timeAddressViewH = 46;
        UIView *timeAddressView = [[UIView alloc] initWithFrame:CGRectMake(timeAddressViewX, timeAddressViewY, timeAddressViewW, timeAddressViewH)];
        timeAddressView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:timeAddressView];
        
        UILabel *stopTimeTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 20)];
        stopTimeTip.textColor = [UIColor grayColor];
        stopTimeTip.font = [UIFont systemFontOfSize:12.0];
        stopTimeTip.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:stopTimeTip];
        stopTimeTip.text = @"时间";
        
        stopTimeL = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 20)];
        stopTimeL.textColor = [UIColor blackColor];
        stopTimeL.font = [UIFont systemFontOfSize:12.0];
        stopTimeL.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:stopTimeL];
    
        UILabel *addressTip = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(stopTimeL.frame), 30, 20)];
        addressTip.textColor = [UIColor grayColor];
        addressTip.font = [UIFont systemFontOfSize:12.0];
        addressTip.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:addressTip];
        addressTip.text = @"地址";
        
        CGFloat addressW = SCREENWIDTH-CGRectGetMaxX(addressTip.frame)-80;
        
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(stopTimeL.frame), addressW, 20)];
        addressL.textColor = [UIColor blackColor];
        addressL.font = [UIFont systemFontOfSize:12.0];
        addressL.adjustsFontSizeToFitWidth = YES;
        addressL.backgroundColor = [UIColor clearColor];
        [timeAddressView addSubview:addressL];
        
        UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressL.frame), CGRectGetMaxY(stopTimeL.frame)-3, 65, 25)];
        locationButton.backgroundColor = APPDEFAULTTITLECOLOR;
        locationButton.tag = 0;
        [locationButton setTitle:@"查看地图" forState:UIControlStateNormal];
        locationButton.layer.cornerRadius = 4.0;
        [locationButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [locationButton addTarget:self action:@selector(goToLocationView) forControlEvents:UIControlEventTouchUpInside];
        [timeAddressView addSubview:locationButton];
        
//        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, CGRectGetMaxY(stopTimeL.frame), 20, 20)];
//        [locationImageView setBackgroundColor:[UIColor clearColor]];
//        locationImageView.userInteractionEnabled = YES;
//        locationImageView.image = [UIImage imageNamed:@"icon_address"];
//        [timeAddressView addSubview:locationImageView];
//        
//        UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLocationView)];
//        locationTap.numberOfTapsRequired = 1;
//        locationTap.numberOfTapsRequired = 1;
//        timeAddressView.userInteractionEnabled = YES;
//        [timeAddressView addGestureRecognizer:locationTap];
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 91+40, bgView_W-10, 1)];
        [bgView addSubview:line1];
        line1.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UILabel *userTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 91+40, 30, 30)];
        userTip.textColor = [UIColor grayColor];
        userTip.text = @"姓名";
        userTip.font = [UIFont systemFontOfSize:12.0];
        userTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userTip];
        
        CGFloat userInfoX = CGRectGetMaxX(userTip.frame);
        CGFloat userInfoW = SCREENWIDTH-userInfoX-10;
        
        userInfoL = [[UILabel alloc] initWithFrame:CGRectMake(userInfoX, 91+40, userInfoW, 30)];
        userInfoL.textColor = [UIColor blackColor];
        userInfoL.userInteractionEnabled = YES;
        userInfoL.font = [UIFont systemFontOfSize:12.0];
        userInfoL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userInfoL];
        
        userInfoL1 = [[UILabel alloc] initWithFrame:CGRectMake(userInfoX, CGRectGetMaxY(userInfoL.frame)-5, userInfoW, 25)];
        userInfoL1.textColor = [UIColor blackColor];
        userInfoL1.userInteractionEnabled = YES;
        userInfoL1.font = [UIFont systemFontOfSize:12.0];
        userInfoL1.backgroundColor = [UIColor clearColor];
        [bgView addSubview:userInfoL1];
        
//        UIImageView *rightV1 = [[UIImageView alloc] initWithFrame:CGRectMake(bgView_W-20, 101, 10, 10)];
//        rightV1.backgroundColor = [UIColor clearColor];
//        rightV1.image = [UIImage imageNamed:@"icon_into_right"];
//        rightV1.userInteractionEnabled = YES;
//        [bgView addSubview:rightV1];
//        
//        UITapGestureRecognizer *userInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
//        [userInfoL addGestureRecognizer:userInfoTap];

        
        
        UILabel *remarkTip = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(userInfoL1.frame), 30, 30)];
        remarkTip.textColor = [UIColor grayColor];
        remarkTip.text = @"备注";
        remarkTip.font = [UIFont systemFontOfSize:12.0];
        remarkTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:remarkTip];
        
        CGFloat remarkInfoX = CGRectGetMaxX(remarkTip.frame);
        CGFloat remarkInfoW = SCREENWIDTH-remarkInfoX-10;
        
        remarkInfoL = [[UILabel alloc] initWithFrame:CGRectMake(remarkInfoX, CGRectGetMaxY(userInfoL1.frame), remarkInfoW, 30)];
        remarkInfoL.textColor = [UIColor blackColor];
        remarkInfoL.userInteractionEnabled = YES;
        remarkInfoL.font = [UIFont systemFontOfSize:12.0];
        remarkInfoL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:remarkInfoL];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(remarkInfoL.frame), bgView_W-10, 1)];
        [bgView addSubview:line2];
        line2.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        UIImageView *piccImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(remarkInfoL.frame)+10, 90, 40)];
        [piccImageView setBackgroundColor:[UIColor clearColor]];
        piccImageView.userInteractionEnabled = YES;
        piccImageView.image = [UIImage imageNamed:@"icon_picc"];
        [bgView addSubview:piccImageView];
        
        UILabel *piccTipL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(piccImageView.frame), CGRectGetMaxY(remarkInfoL.frame)+5, SCREENWIDTH-CGRectGetMaxX(piccImageView.frame)-40, 50)];
        piccTipL.textColor = [UIColor grayColor];
        piccTipL.userInteractionEnabled = YES;
        piccTipL.numberOfLines = 0;
        piccTipL.text = @"【护士上门】将免费为患者和医护人员投保中国人寿意外险";
        piccTipL.font = [UIFont systemFontOfSize:12.0];
        piccTipL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:piccTipL];
        
        
        UIImageView *quessionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(piccTipL.frame), CGRectGetMaxY(remarkInfoL.frame)+20, 20, 20)];
        [quessionImageView setBackgroundColor:[UIColor clearColor]];
        quessionImageView.userInteractionEnabled = YES;
        quessionImageView.image = [UIImage imageNamed:@"icon_question"];
        [bgView addSubview:quessionImageView];
        
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(piccImageView.frame)+5, bgView_W-10, 1)];
        [bgView addSubview:line3];
        line3.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        CGFloat sendTimeY = CGRectGetMaxY(line3.frame);
        CGFloat sendTimeW = 60;
        UILabel *sendTimeTip = [[UILabel alloc] initWithFrame:CGRectMake(10, sendTimeY, sendTimeW, 20)];
        sendTimeTip.textColor = [UIColor grayColor];
        sendTimeTip.font = [UIFont systemFontOfSize:12.0];
        sendTimeTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:sendTimeTip];
        sendTimeTip.text = @"发单时间";
        
        sendTimeW = SCREENWIDTH-CGRectGetMaxX(sendTimeTip.frame)-10;
        sendTimeL = [[UILabel alloc] initWithFrame:CGRectMake(70, sendTimeY, sendTimeW, 20)];
        sendTimeL.textColor = [UIColor blackColor];
        sendTimeL.font = [UIFont systemFontOfSize:12.0];
        sendTimeL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:sendTimeL];

        CGFloat orderNumY = CGRectGetMaxY(sendTimeL.frame);
        CGFloat orderNumW = 60;
        UILabel *orderNumTip = [[UILabel alloc] initWithFrame:CGRectMake(10, orderNumY, orderNumW, 20)];
        orderNumTip.textColor = [UIColor grayColor];
        orderNumTip.font = [UIFont systemFontOfSize:12.0];
        orderNumTip.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderNumTip];
        orderNumTip.text = @"订单编号";
        
        orderNumW = SCREENWIDTH-CGRectGetMaxX(orderNumTip.frame)-10;
        orderNumL = [[UILabel alloc] initWithFrame:CGRectMake(70, orderNumY, orderNumW, 20)];
        orderNumL.textColor = [UIColor blackColor];
        orderNumL.font = [UIFont systemFontOfSize:12.0];
        orderNumL.backgroundColor = [UIColor clearColor];
        [bgView addSubview:orderNumL];
        
        UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(orderNumL.frame), bgView_W-10, 1)];
        [bgView addSubview:line4];
        line4.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        
        
        
        CGFloat buttonH = 35;
        CGFloat buttonW = 70;
        CGFloat buttonX = (SCREENWIDTH/2.0-buttonW)/2.0;
        CGFloat buttonY = bgView_H-110;//30;
        
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        cancelButton.backgroundColor = [UIColor blackColor];
        cancelButton.tag = 0;
        [cancelButton setTitle:@"忽略" forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius = 4.0;
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelButton];
        
        buttonX = SCREENWIDTH/2.0 + buttonX;
        UIButton *receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        receiveButton.backgroundColor = APPDEFAULTTITLECOLOR;
        receiveButton.layer.cornerRadius = 4.0;
        //    [receiveButton setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
        receiveButton.tag = 1;
        [receiveButton setTitle:@"接单" forState:UIControlStateNormal];
        [receiveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [receiveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:receiveButton];

    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 0) {
        if (self.cancleOrderBlock) {
            self.cancleOrderBlock();
        }
    }else{
        if (self.receiveOrderBlock) {
            self.receiveOrderBlock();
        }
    }
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
