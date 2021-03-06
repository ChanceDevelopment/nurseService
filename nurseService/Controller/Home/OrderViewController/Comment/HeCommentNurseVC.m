//
//  HeCommentNurseVC.m
//  nurseService
//
//  Created by Tony on 2017/1/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HeCommentNurseVC.h"
#import "IQTextView.h"
#import "SAMTextView.h"

@interface HeCommentNurseVC ()
@property(strong,nonatomic)IBOutlet SAMTextView *textView;
@property(strong,nonatomic)IBOutlet UIImageView *nurseImage;
@property(strong,nonatomic)IBOutlet UILabel *nurseLabel;
@property(strong,nonatomic)IBOutlet UIView *markView;

@end

@implementation HeCommentNurseVC
{
    NSInteger currentRank;
}
@synthesize nurseDict;
@synthesize textView;
@synthesize nurseImage;
@synthesize nurseLabel;
@synthesize markView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"评价";
        [label sizeToFit];
        self.title = @"评价";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}

- (void)initializaiton
{
    [super initializaiton];
}

- (void)initView
{
    [super initView];
    textView.placeholder = @"请写下您对用户的评价";
    nurseImage.layer.masksToBounds = YES;
    nurseImage.layer.cornerRadius = 30;
    
    NSString *nurseHeader = nurseDict[@"userHeader"];
    if ([nurseHeader isMemberOfClass:[NSNull class]] || nurseHeader == nil) {
        nurseHeader = @"";
    }
    nurseHeader = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,nurseHeader];
    [nurseImage sd_setImageWithURL:[NSURL URLWithString:nurseHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];
    
    NSString *nurseNick = nurseDict[@"userNickNew"];
    if ([nurseNick isMemberOfClass:[NSNull class]]) {
        nurseNick = @"";
    }
    nurseLabel.text = nurseNick;
    
    currentRank = 1;
    CGFloat imageDistance = 10;
    CGFloat imageH = 25;
    CGFloat imageW = 25;
    CGFloat imageY = 2.5;
    CGFloat imageX = (SCREENWIDTH - 20 - (5 * imageW) - (4 * imageDistance)) / 2.0;
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_collection_full"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(updateStart:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index + 1;
        if (index < currentRank) {
            button.selected = YES;
        }
        imageX = imageX + imageW + imageDistance;
        [markView addSubview:button];
    }
}

- (void)updateStart:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        currentRank = button.tag;
    }
    else{
        currentRank = button.tag - 1;
    }
    if (currentRank < 0) {
        currentRank = 0;
    }
    NSArray *subViewArray = markView.subviews;
    for (NSInteger index = 0; index < [subViewArray count]; index++) {
        UIButton *button = subViewArray[index];
        if (index < currentRank) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
}

- (IBAction)commitButtonClick:(id)sender
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    NSString *content = textView.text;
    if ([content length] < 5) {
        [self showHint:@"请至少输入五个字"];
        return;
    }
    NSString *nurseId = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    
    NSString *userid = [NSString stringWithFormat:@"%@",nurseDict[@"orderSendUserid"]];
    
    if ([nurseId isMemberOfClass:[NSNull class]] || nurseId == nil) {
        nurseId = @"";
    }
    NSString *sendId = nurseDict[@"orderSendId"];
    if ([sendId isMemberOfClass:[NSNull class]] || sendId == nil) {
        sendId = @"";
    }
    
    NSString *mark = [NSString stringWithFormat:@"%ld",currentRank];
    NSDictionary * params  = @{@"userId":userid,@"nurseId":nurseId,@"sendId":sendId,@"info":content,@"mark":mark};
    [self showHudInView:self.view hint:@"评价中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:ADDNURSEEVALUATE params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *respondDict = [NSDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[respondDict valueForKey:@"errorCode"] integerValue] == REQUESTCODE_SUCCEED){
            
            [self showHint:@"评价成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrder" object:nil];
            [self performSelector:@selector(backToLastView) withObject:nil afterDelay:0.8];
        }
        else{
            NSString *data = respondDict[@"data"];
            if ([data isMemberOfClass:[NSNull class]] || data == nil) {
                data = ERRORREQUESTTIP;
            }
            [self showHint:data];
        }
    } failure:^(NSError* err){
        [self hideHud];
        [self showHint:ERRORREQUESTTIP];
        NSLog(@"errorInfo = %@",err);
    }];
}

- (void)backToLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
