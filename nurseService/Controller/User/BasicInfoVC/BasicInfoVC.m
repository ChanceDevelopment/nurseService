//
//  BasicInfoVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "BasicInfoVC.h"
#import "HeBaseTableViewCell.h"
#import "ProfessionInfoVC.h"
@interface BasicInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSArray *statusArray;
    UIImage *userImage;
    NSString *idCardImageStr;
    NSString *headImageStr;
    NSMutableDictionary *infoDic;
    UIImageView *headImageView;        //头像              0
    UIImageView *userImageView;        //个人照片           1
    UIImageView *idCardImageView;      //手持身份证正面照     2
    UIImageView *idCardFrontImageView; //身份证正面照        3
    UIImageView *idCardDownImageView;  //身份证反面照        4
    NSInteger imageTag;
    
    BOOL isHeadImage;
    UIView *windowView;
    NSMutableDictionary *postDic;
    
    UITextField *nameTextField;
    UITextField *idCardTextField;
    UITextField *phoneTextField;
    UITextField *addressTextField;
    UITextField *mailTextField;
    
    UIButton *manSelectBt;
    UIButton *womanSelectBt;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)IBOutlet UIView *statusView;
@end

@implementation BasicInfoVC
@synthesize myTableView;
@synthesize statusView;

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
        label.text = @"基本信息";
        [label sizeToFit];
        self.title = @"基本信息";
        self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
        
//        NSMutableArray *buttons = [[NSMutableArray alloc] init];
//        UIButton *saveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
//        saveBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
//        [saveBt setTitleColor:APPDEFAULTORANGE forState:UIControlStateNormal];
//        [saveBt setTitle:@"保存" forState:UIControlStateNormal];
//        saveBt.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
//        saveBt.layer.borderWidth = 1.0f;
//        saveBt.layer.borderColor = [[UIColor colorWithRed:152.0 / 255.0 green:67.0 / 255.0 blue:141.0 / 255.0 alpha:1.0] CGColor];
//        [saveBt addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
//        saveBt.backgroundColor = [UIColor clearColor];
//        
//        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
//        [buttons addObject:searchItem];
//        self.navigationItem.rightBarButtonItems = buttons;
        
        
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
    statusArray = @[@"基本信息",@"专业信息",@"等待审核"];
    postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"NurseHeader",@"",@"NurseHeaderImage",@"",@"NurseTruePic",@"",@"NurseTruePicImage",@"1",@"NurseSex",@"",@"NurseCardpic1",@"",@"NurseCardpicImage1",@"",@"NurseCardpic2",@"",@"NurseCardpicImage2",@"",@"NurseCardpic3",@"",@"NurseCardpicImage3",@"",@"nurseTruename",@"",@"NurseCard", nil];
    
    infoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    isHeadImage = YES;
    imageTag = 0;
}

- (void)initView
{
    [super initView];
//    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];

    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addStatueViewWithStatus:0];
    
    UIButton *backImage = [[UIButton alloc] init];
    [backImage setBackgroundImage:[UIImage imageNamed:@"navigationBar_back_icon"] forState:UIControlStateNormal];
    [backImage addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    backImage.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backImage];
    backItem.target = self;
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)getNurseData{
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];

    NSDictionary * params  = @{@"nurseId" : userAccount};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSEBASICSINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict objectForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            if ([[respondDict objectForKey:@"json"] isMemberOfClass:[NSNull class]] || [respondDict objectForKey:@"json"] == nil) {

                
            }else{
                NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[respondDict objectForKey:@"json"]];
            }
            
            NSLog(@"success");
        }else if ([[[respondDict objectForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict objectForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];

}

- (void)backItemClick:(id)sender{
    [self showCancleAlertView];
}

- (void)showCancleAlertView{
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 160;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:12.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    
    titleL.text = @"取消验证，返回主页面";
    infoTip.text = @"若未认证或认证不通过，将无法提供相关服务";
    
    NSInteger wordNum_Y = addTextField_Y+44;
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = wordNum_Y+30;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 100;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"tag:%ld",sender.tag);
    if (sender.tag == 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_JUSTTOROOTVIEW object:nil];
    }
    
    if (windowView) {
        [windowView removeFromSuperview];
    }
}


- (void)saveAction{
    NSLog(@"saveAction");
//    [self nextStepAction];
    [self goToProfessionInfoVC];
}

- (void)nextStepAction{

    
    NSString *nurseTruename = nameTextField.text;
    NSString *nurseCard = idCardTextField.text;
    NSString *nursePhone = phoneTextField.text;
    NSString *NurseAddress = addressTextField.text;
    NSString *NurseEmail = mailTextField.text;
    
    if (nurseCard.length > 0) {
        if (![Tool IsIdentityCard:nurseCard]) {
            [self showHint:@"请输入正确的身份证号"];
            return;
        }
    }
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"NurseId" : userAccount,
                               @"NurseTruePic" : [postDic objectForKey:@"NurseTruePic"],
                               @"nurseTruename" : nurseTruename,
                               @"NurseSex" : [postDic objectForKey:@"NurseSex"],
                               @"NurseCard" : nurseCard,
                               @"NursePhone" : nursePhone,
                               @"NurseAddress" : NurseAddress,
                               @"NurseLanguage" : @"",
                               @"NurseEmail" : NurseEmail,
                               @"NurseCardpic" : [postDic objectForKey:@"NurseCardpic"]};
    NSLog(@"%@",params);
    [self showHudInView:self.view hint:@"提交中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:MODIFYUSERINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict objectForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
        }else if ([[[respondDict objectForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict objectForKey:@"data"]] duration:1.2 position:@"center"];
        }
        [self performSelector:@selector(goToProfessionInfoVC) withObject:nil afterDelay:0];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self hideHud];
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
    
}

- (void)addStatueViewWithStatus:(NSInteger)statusType
{
    CGFloat statusLabelX = 5;
    CGFloat statusLabelY = 10;
    CGFloat statusLabelH = 20;
    CGFloat statusLabelW = (SCREENWIDTH - 2 * statusLabelX) / [statusArray count];
    
    CGFloat circleIconX = 0;
    CGFloat circleIconY = 0;
    CGFloat circleIconW = 10;
    CGFloat circleIconH = 10;
    
    CGFloat sepLineX = 0;
    CGFloat sepLineY = 0;
    CGFloat sepLineW = 0;
    CGFloat sepLineH = 1;
    
    for (NSInteger index = 0; index < [statusArray count]; index++) {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabelX, statusLabelY, statusLabelW, statusLabelH)];
        statusLabel.tag = 1;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = APPDEFAULTORANGE;
        statusLabel.font = [UIFont systemFontOfSize:13.0];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = statusArray[index];
        [statusView addSubview:statusLabel];
        
        circleIconX = CGRectGetMidX(statusLabel.frame) - circleIconW / 2.0;
        circleIconY = CGRectGetMaxY(statusLabel.frame) + 5;
        UIImageView *circleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(circleIconX, circleIconY, circleIconW, circleIconH)];
        circleIcon.layer.masksToBounds = YES;
        circleIcon.layer.cornerRadius = circleIconH / 2.0;
        if (index <= statusType) {
            circleIcon.backgroundColor = APPDEFAULTORANGE;
        }
        else{
            circleIcon.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
        }
        [statusView addSubview:circleIcon];
        
        sepLineY = CGRectGetMidY(circleIcon.frame);
        sepLineW = CGRectGetMinX(circleIcon.frame) - sepLineX - 2;
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
        sepLine.backgroundColor = circleIcon.backgroundColor;
        [statusView addSubview:sepLine];
        
        statusLabelX = CGRectGetMaxX(statusLabel.frame);
        sepLineX = CGRectGetMaxX(circleIcon.frame) + 2;
    }
    
    sepLineW = SCREENWIDTH - sepLineX;
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(sepLineX, sepLineY, sepLineW, sepLineH)];
    sepLine.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [statusView addSubview:sepLine];
    
}



#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    switch (row) {
        case 0:
        {
            CGFloat headImageW = 60;
            CGFloat imageX = SCREENWIDTH/2.0-headImageW-30;
            
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 10, headImageW, headImageW)];
            [cell addSubview:headImageView];
            headImageView.userInteractionEnabled = YES;
            headImageView.backgroundColor = [UIColor grayColor];
            headImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
            
            if (![[postDic objectForKey:@"NurseHeader"] isEqualToString:@""]) {
                headImageView.image = (UIImage*)[postDic objectForKey:@"NurseHeaderImage"];
            }
            
            UITapGestureRecognizer *userClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userClickImageAction)];
            [headImageView addGestureRecognizer:userClickTap];
            
            CGFloat userLabelX = 20+headImageW;
            CGFloat userLabelY = CGRectGetMaxY(headImageView.frame)+13;
            UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabelX, userLabelY, 100, 25)];
            userLabel.center = CGPointMake(imageX+headImageW/2.0, userLabelY);
            userLabel.textAlignment = NSTextAlignmentCenter;
            userLabel.backgroundColor = [UIColor clearColor];
            userLabel.text = @"上传头像";
            userLabel.font = [UIFont systemFontOfSize:15.0];
            userLabel.textColor = [UIColor blackColor];
            [cell addSubview:userLabel];
            
            imageX = SCREENWIDTH/2.0+30;
            userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 10, headImageW, headImageW)];
            [cell addSubview:userImageView];
            userImageView.userInteractionEnabled = YES;
            userImageView.backgroundColor = [UIColor grayColor];
            userImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
            UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImageAction)];
            [userImageView addGestureRecognizer:clickTap];
            
            if (![[postDic objectForKey:@"NurseTruePic"] isEqualToString:@""]) {
                userImageView.image = (UIImage*)[postDic objectForKey:@"NurseTruePicImage"];
            }
            
            
            CGFloat tipLabelX = 20+headImageW;
            CGFloat tipLabelY = CGRectGetMaxY(userImageView.frame);
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, 150, 44)];
            tipLabel.center = CGPointMake(imageX+headImageW/2.0, userLabelY);
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"上传个人照片";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel];
            
            CGFloat tipX = 10;
            CGFloat tipY = CGRectGetMaxY(userLabel.frame);
            CGFloat tipW = SCREENWIDTH-20;
            
            UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, 25)];
            tipLabel1.backgroundColor = [UIColor clearColor];
            tipLabel1.text = @"*头像可方便用户识别，也可保护您肖像隐私";
            tipLabel1.font = [UIFont systemFontOfSize:13.0];
            tipLabel1.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel1];
            
            tipY = CGRectGetMaxY(tipLabel1.frame)-10;
            UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipY, tipW, 50)];
            tipLabel2.numberOfLines = 0;
            tipLabel2.backgroundColor = [UIColor clearColor];
            tipLabel2.text = @"*请上传清晰正面头像，职业且富有亲和力的形象更容易获得信赖";
            tipLabel2.font = [UIFont systemFontOfSize:13.0];
            tipLabel2.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel2];
            
            
            break;
        }
        case 1:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"姓名";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat nameTextFieldX = SCREENWIDTH-210;
            CGFloat nameTextFieldW = 200;
            
            nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameTextFieldX, 0, nameTextFieldW, cellSize.height)];
            nameTextField.placeholder = @"请输入您的真实姓名";
            nameTextField.font = [UIFont systemFontOfSize:15.0];
            nameTextField.textAlignment = NSTextAlignmentRight;
            nameTextField.textColor = [UIColor blackColor];
            nameTextField.delegate = self;
            nameTextField.backgroundColor = [UIColor clearColor];
            nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            nameTextField.tag = 100;
            [cell addSubview:nameTextField];
            nameTextField.text = [postDic valueForKey:@"nurseTruename"];
            break;
        }
//        case 2:
//        {
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"性别";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipLabel];
//            
//            CGFloat imageW = 10;
//            CGFloat imageX = SCREENWIDTH-150;
//            manSelectBt = [[UIButton alloc] initWithFrame:CGRectMake(imageX, 17, imageW, imageW)];
//            [cell addSubview:manSelectBt];
//            manSelectBt.backgroundColor = [UIColor clearColor];
//            manSelectBt.userInteractionEnabled = YES;
//            [manSelectBt setBackgroundImage:[UIImage imageNamed:@"icon_dot_violet_select"] forState:UIControlStateSelected];
//            manSelectBt.tag = 1;
//            manSelectBt.selected = YES;
//            [manSelectBt setBackgroundImage:[UIImage imageNamed:@"icon_dot_violet_unselect"] forState:UIControlStateNormal];
//            [manSelectBt addTarget:self action:@selector(changeSexChoose:) forControlEvents:UIControlEventTouchUpInside];
//            
//            womanSelectBt = [[UIButton alloc] initWithFrame:CGRectMake(imageX+70, 17, imageW, imageW)];
//            [cell addSubview:womanSelectBt];
//            womanSelectBt.backgroundColor = [UIColor clearColor];
//            womanSelectBt.userInteractionEnabled  = YES;
//            [womanSelectBt setBackgroundImage:[UIImage imageNamed:@"icon_dot_violet_unselect"] forState:UIControlStateNormal];
//            [womanSelectBt setBackgroundImage:[UIImage imageNamed:@"icon_dot_violet_select"] forState:UIControlStateSelected];
//            womanSelectBt.tag = 2;
//            womanSelectBt.selected = NO;
//            [womanSelectBt addTarget:self action:@selector(changeSexChoose:) forControlEvents:UIControlEventTouchUpInside];
//            
//            UILabel *tipManLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageX+20, 0, 30, cellSize.height)];
//            tipManLabel.backgroundColor = [UIColor clearColor];
//            tipManLabel.text = @"男";
//            tipManLabel.font = [UIFont systemFontOfSize:15.0];
//            tipManLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipManLabel];
//
//            UILabel *tipWomanLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageX+90, 0, 30, cellSize.height)];
//            tipWomanLabel.backgroundColor = [UIColor clearColor];
//            tipWomanLabel.text = @"女";
//            tipWomanLabel.font = [UIFont systemFontOfSize:15.0];
//            tipWomanLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipWomanLabel];
//            
//            break;
//        }
        case 2:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"身份证号";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat nameTextFieldX = SCREENWIDTH-210;
            CGFloat nameTextFieldW = 200;
            
            idCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameTextFieldX, 0, nameTextFieldW, cellSize.height)];
            idCardTextField.placeholder = @"请输入您的身份证号";
            idCardTextField.font = [UIFont systemFontOfSize:15.0];
            idCardTextField.textAlignment = NSTextAlignmentRight;
            idCardTextField.textColor = [UIColor blackColor];
            idCardTextField.backgroundColor = [UIColor clearColor];
            idCardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            idCardTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            idCardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            idCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            idCardTextField.delegate = self;
            idCardTextField.tag = 101;
            [cell addSubview:idCardTextField];
            idCardTextField.text = [postDic valueForKey:@"NurseCard"];
            break;
        }
//        case 4:
//        {
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"联系电话";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipLabel];
//            
//            CGFloat nameTextFieldX = SCREENWIDTH-210;
//            CGFloat nameTextFieldW = 200;
//            
//            phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameTextFieldX, 0, nameTextFieldW, cellSize.height)];
//            phoneTextField.font = [UIFont systemFontOfSize:15.0];
//            phoneTextField.textAlignment = NSTextAlignmentRight;
//            phoneTextField.textColor = [UIColor blackColor];
//            phoneTextField.backgroundColor = [UIColor clearColor];
//            phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [cell addSubview:phoneTextField];
//            break;
//        }
//        case 5:
//        {
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"常住地址";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipLabel];
//            
//            CGFloat nameTextFieldX = SCREENWIDTH-210;
//            CGFloat nameTextFieldW = 200;
//            
//            addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameTextFieldX, 0, nameTextFieldW, cellSize.height)];
//            addressTextField.font = [UIFont systemFontOfSize:15.0];
//            addressTextField.textAlignment = NSTextAlignmentRight;
//            addressTextField.textColor = [UIColor blackColor];
//            addressTextField.backgroundColor = [UIColor clearColor];
//            addressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            addressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            addressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [cell addSubview:addressTextField];
//            break;
//        }
//        case 6:
//        {
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"邮箱";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipLabel];
//            
//            CGFloat nameTextFieldX = SCREENWIDTH-210;
//            CGFloat nameTextFieldW = 200;
//            
//            mailTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameTextFieldX, 0, nameTextFieldW, cellSize.height)];
//            mailTextField.font = [UIFont systemFontOfSize:15.0];
//            mailTextField.textAlignment = NSTextAlignmentRight;
//            mailTextField.textColor = [UIColor blackColor];
//            mailTextField.backgroundColor = [UIColor clearColor];
//            mailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            mailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            mailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [cell addSubview:mailTextField];
//            break;
//        }
        case 3:
        {
            CGFloat headImageW = 130;
            CGFloat imageY = 10;
            idCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:idCardImageView];
            idCardImageView.userInteractionEnabled = YES;
            idCardImageView.backgroundColor = [UIColor clearColor];
            idCardImageView.image = [UIImage imageNamed:@"icon_idcard_hand"];
            if (![[postDic objectForKey:@"NurseCardpic1"] isEqualToString:@""]) {
                idCardImageView.image = (UIImage*)[postDic objectForKey:@"NurseCardpicImage1"];
            }

            UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIdCardAction)];
            [idCardImageView addGestureRecognizer:clickTap];
            
            CGFloat tipLabelX = CGRectGetMaxX(idCardImageView.frame)+10;
            CGFloat tipLabelY = CGRectGetMaxY(idCardImageView.frame)-60;
            CGFloat tipLabelW = SCREENWIDTH-CGRectGetMaxX(idCardImageView.frame)-20;
            
            UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel1.adjustsFontSizeToFitWidth = YES;
            tipLabel1.backgroundColor = [UIColor clearColor];
            tipLabel1.text = @"上传手持身份证正面照";
            tipLabel1.font = [UIFont systemFontOfSize:15.0];
            tipLabel1.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel1];

            
            imageY = CGRectGetMaxY(idCardImageView.frame)+20;
            idCardFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:idCardFrontImageView];
            idCardFrontImageView.userInteractionEnabled = YES;
            idCardFrontImageView.backgroundColor = [UIColor clearColor];
            idCardFrontImageView.image = [UIImage imageNamed:@"icon_idcard1"];
            if (![[postDic objectForKey:@"NurseCardpic2"] isEqualToString:@""]) {
                idCardFrontImageView.image = (UIImage*)[postDic objectForKey:@"NurseCardpicImage2"];
            }
            UITapGestureRecognizer *clickTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFrontIdCardAction)];
            [idCardFrontImageView addGestureRecognizer:clickTap1];
            
            tipLabelX = CGRectGetMaxX(idCardFrontImageView.frame)+10;
            tipLabelY = CGRectGetMaxY(idCardFrontImageView.frame)-60;
            UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel2.adjustsFontSizeToFitWidth = YES;
            tipLabel2.backgroundColor = [UIColor clearColor];
            tipLabel2.text = @"上传身份证正面照";
            tipLabel2.font = [UIFont systemFontOfSize:15.0];
            tipLabel2.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel2];

            imageY = CGRectGetMaxY(idCardFrontImageView.frame)+20;
            idCardDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:idCardDownImageView];
            idCardDownImageView.userInteractionEnabled = YES;
            idCardDownImageView.backgroundColor = [UIColor clearColor];
            idCardDownImageView.image = [UIImage imageNamed:@"icon_idcard2"];
            if (![[postDic objectForKey:@"NurseCardpic3"] isEqualToString:@""]) {
                idCardDownImageView.image = (UIImage*)[postDic objectForKey:@"NurseCardpicImage3"];
            }
            UITapGestureRecognizer *clickTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDownIdCardAction)];
            [idCardDownImageView addGestureRecognizer:clickTap2];
            
            tipLabelX = CGRectGetMaxX(idCardDownImageView.frame)+10;
            tipLabelY = CGRectGetMaxY(idCardDownImageView.frame)-60;
            UILabel *tipLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel3.adjustsFontSizeToFitWidth = YES;
            tipLabel3.backgroundColor = [UIColor clearColor];
            tipLabel3.text = @"上传身份证反面照";
            tipLabel3.font = [UIFont systemFontOfSize:15.0];
            tipLabel3.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel3];
            break;
        }
        case 4:{
            
            UILabel *nextStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, cellSize.height)];
            nextStepLabel.backgroundColor = APPDEFAULTTITLECOLOR;
            nextStepLabel.text = @"下一步";
            nextStepLabel.textAlignment = NSTextAlignmentCenter;
            nextStepLabel.font = [UIFont systemFontOfSize:15.0];
            [cell addSubview:nextStepLabel];
            break;
        }
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    switch (row) {
        case 0:
            return 90*2;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 44;
            break;
        case 3:
            return 100*3;
            break;
        case 4:
            return 40;
            break;
        default:
            break;
    }
    
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
    if (row == 4) {
//        [self nextStepAction];
        [self goToProfessionInfoVC];

    }
}

//手持身份证正面照
- (void)clickIdCardAction{
    isHeadImage = NO;
    imageTag = 2;
    [self showActionSheet];
}

//上传正面
- (void)clickFrontIdCardAction{
    imageTag = 3;
    NSLog(@"clickFrontIdCardAction");
    [self showActionSheet];
}
//上传反面
- (void)clickDownIdCardAction{
    imageTag = 4;
    [self showActionSheet];
    NSLog(@"clickDownIdCardAction");
}
//头像
- (void)userClickImageAction{
    imageTag = 0;
    [self showActionSheet];
    NSLog(@"userClickImageAction");
}
//个人照片
- (void)clickHeadImageAction{
    imageTag = 1;
    isHeadImage = YES;
    [self showActionSheet];
}

- (void)showActionSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开本地相册
            [self pickerPhotoLibrary];
            break;
        case 1:  //打开照相机拍照
            [self pickerCamer];
            break;
            
    }
}

#pragma mark -
#pragma mark ImagePicker method
//从相册中打开照片选择画面(图片库)：UIImagePickerControllerSourceTypePhotoLibrary
//启动摄像头打开照片摄影画面(照相机)：UIImagePickerControllerSourceTypeCamera

//按下相机触发事件
-(void)pickerCamer
{
    //照相机类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断属性值是否可用
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        //UIImagePickerController是UINavigationController的子类
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        //设置可以编辑
        imagePicker.allowsEditing = YES;
        //设置类型为照相机
        imagePicker.sourceType = sourceType;
        //进入照相机画面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//当按下相册按钮时触发事件
-(void)pickerPhotoLibrary
{
    //图片库类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *photoAlbumPicker = [[UIImagePickerController alloc] init];
    photoAlbumPicker.delegate = self;
    photoAlbumPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    //设置可以编辑
    photoAlbumPicker.allowsEditing = YES;
    //设置类型
    photoAlbumPicker.sourceType = sourceType;
    //进入图片库画面
    [self presentViewController:photoAlbumPicker animated:YES completion:nil];
}


#pragma mark -
#pragma mark imagePickerController method
//当拍完照或者选取好照片之后所要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        userImage = [info objectForKey:UIImagePickerControllerEditedImage];
        CGSize sizeImage = userImage.size;
        float a = [self getSize:sizeImage];
        if (a > 0) {
            CGSize size = CGSizeMake(sizeImage.width/a, sizeImage.height/a);
            userImage = [self scaleToSize:userImage size:size];
        }
        
        NSData *data;
        if (UIImagePNGRepresentation(userImage) == nil)
        {
            data = UIImageJPEGRepresentation(userImage, 0.6);
        }
        else
        {
            data = UIImagePNGRepresentation(userImage);
        }
        
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        [self dismissViewControllerAnimated:YES completion:^{
            if (imageTag == 0) {
                [postDic setValue:imageStr forKey:@"NurseHeader"];
                headImageView.image = userImage;
                [postDic setObject:userImage forKey:@"NurseHeaderImage"];
            }else if(imageTag == 1){
                [postDic setValue:imageStr forKey:@"NurseTruePic"];
                userImageView.image = userImage;
                [postDic setObject:userImage forKey:@"NurseTruePicImage"];
            }else if(imageTag == 2){
                [postDic setValue:imageStr forKey:@"NurseCardpic1"];
                idCardImageView.image = userImage;
                [postDic setObject:userImage forKey:@"NurseCardpicImage1"];
            }else if(imageTag == 3){
                [postDic setValue:imageStr forKey:@"NurseCardpic2"];
                idCardFrontImageView.image = userImage;
                [postDic setObject:userImage forKey:@"NurseCardpicImage2"];
            }else if(imageTag == 4){
                [postDic setValue:imageStr forKey:@"NurseCardpic3"];
                idCardDownImageView.image = userImage;
                [postDic setObject:userImage forKey:@"NurseCardpicImage3"];
            }
        }];
    }
}

-(float)getSize:(CGSize)size
{
    float a = size.width / 480.0;
    if (a > 1) {
        return a;
    }
    else
        return -1;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


//相应取消动作
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSexChoose:(UIButton *)sender
{
    if (sender.selected == YES) {
        return;
    }
    manSelectBt.selected = !manSelectBt.isSelected;
    womanSelectBt.selected = !womanSelectBt.isSelected;
    if (manSelectBt.selected) {
        NSLog(@"男");
        [postDic setValue:@"1" forKey:@"NurseSex"];
    }else{
        [postDic setValue:@"2" forKey:@"NurseSex"];
        NSLog(@"女");
    }
}

- (void)goToProfessionInfoVC{
    
    if ([[postDic valueForKey:@"nurseTruename"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseCard"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseHeader"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseTruePic"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseCardpic1"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseCardpic2"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseCardpic3"] isEqualToString:@""]) {
        
        [self showAlertView];
        return;
    }
    if (![[postDic valueForKey:@"NurseCard"] isEqualToString:@""]) {
        if (![Tool IsIdentityCard:[postDic valueForKey:@"NurseCard"]]) {
            [self showHint:@"请输入正确的身份证号"];
            return;
        }
    }
    


    ProfessionInfoVC *professionInfoVC = [[ProfessionInfoVC alloc] init];
    professionInfoVC.hidesBottomBarWhenPushed = YES;
    professionInfoVC.basicInfo = postDic;
    [self.navigationController pushViewController:professionInfoVC animated:YES];
}

- (void)showAlertView{
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 130;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    UILabel *infoTip= [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    infoTip.font = [UIFont systemFontOfSize:12.0];
    infoTip.numberOfLines = 0;
    infoTip.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:infoTip];
    
    titleL.text = @"提示";
    infoTip.text = @"信息填写完整才能进行下一步操作";
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = CGRectGetMaxY(infoTip.frame);
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
//    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
//    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
//    cancleBt.backgroundColor = [UIColor clearColor];
//    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    cancleBt.tag = 0;
//    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
//    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确认" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 0;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFocused]) {
        [textField resignFirstResponder];
    }
    [self updateWithTextField:textField];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.text:%@",textField.text);
    [self updateWithTextField:textField];
}

- (void)updateWithTextField:(UITextField *)textField
{
    NSString *temp = textField.text;
    switch (textField.tag) {
        case 100:
            [postDic setObject:temp forKey:@"nurseTruename"];
            break;
        case 101:
            [postDic setObject:temp forKey:@"NurseCard"];
            break;
            
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
