//
//  DFLikeJoinView.h
//  huayoutong
//
//  Created by HeDongMing on 16/4/13.
//  Copyright © 2016年 HeDongMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBaseLineItem.h"

@protocol DFLikeJoinViewDelegate <NSObject>

@required
-(void) onClickUser:(NSString *) userId;

@end

@interface DFLikeJoinView : UIView
@property (nonatomic, assign) id<DFLikeJoinViewDelegate> delegate;

-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getHeight:(DFBaseLineItem *) item maxWidth:(CGFloat)maxWidth;

@end
