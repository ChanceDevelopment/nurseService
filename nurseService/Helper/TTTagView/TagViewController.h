//
//  ViewController.h
//  Tags
//
//  Created by 赵春浩 on 16/8/15.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeBaseViewController.h"

@class TagViewController;

@protocol ViewControllerDelegate <NSObject>
@optional

- (void)updateTagsLabelWithTagsString:(NSString *)tags;

@end

@interface TagViewController : HeBaseViewController

@property (nonatomic ,strong)NSString *bqlabStr;

@property (weak, nonatomic) id <ViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *tagListArr;

@end

