//
//  MyInfoTableViewCell.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/23.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MyInfoTableViewCell.h"

@implementation MyInfoTableViewCell
@synthesize name,nameText,headImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellsize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellsize];
    if (self) {
        
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 48)];
        name.textColor = [UIColor blackColor];
        name.textAlignment = NSTextAlignmentLeft;
        name.font = [UIFont systemFontOfSize:15.0];
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        
        nameText = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-180, 0, 150, 48)];
        nameText.textColor = [UIColor grayColor];
        nameText.textAlignment = NSTextAlignmentRight;
        nameText.font = [UIFont systemFontOfSize:15.0];
        nameText.backgroundColor = [UIColor clearColor];
        [self addSubview:nameText];
        
        headImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-70, 4, 40, 40)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.masksToBounds = YES;
        headImageView.placeholderImage = [UIImage imageNamed:@"defalut_icon"];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderWidth = 0.0;
        headImageView.layer.cornerRadius = 40 / 2.0;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-25, 14, 20, 20)];
        rightV.backgroundColor = [UIColor clearColor];
        rightV.image = [UIImage imageNamed:@"icon_into_right"];
        [self addSubview:rightV];
    }
    return self;
}


@end
