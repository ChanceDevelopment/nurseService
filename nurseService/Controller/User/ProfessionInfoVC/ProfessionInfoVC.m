//
//  ProfessionInfoVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ProfessionInfoVC.h"
#import "HeBaseTableViewCell.h"
#import "ServiceListVC.h"

@interface ProfessionInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *statusArray;
    BOOL isShowLanguage;
    UIButton *intoImageBt;
    UIImage *photoImage;
    NSString *photoImageStr;
    UIImageView *photoImageView;
    UIImageView *idCardFrontImageView;
    UIImageView *idCardDownImageView;
    NSMutableDictionary *postDic;
    UIView *windowView;
    UIView *addBgView;
    
    NSMutableArray *workUnitArr;
    NSMutableArray *nurseOfficeArr;
    NSMutableDictionary *nurseOfficeDic;
    NSMutableDictionary *languageDic;
    NSMutableArray *serviceArr;
    NSMutableDictionary *serviceIdDic;
    NSMutableArray *serviceSelectArr;
    
    
    UITextField *nurseNumberField;
    UILabel *professionNameLable;
    UILabel *professionYearsL;
    UILabel *officeLable;
    UILabel *workPlaceLable;
    
    UITextView *nurseNoteText;
    
    NSInteger imageTag;
    NSArray *nurseInfoArr;      //职业年限集合
    NSArray *nursejobArr;       //职称集合

}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)IBOutlet UIView *statusView;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ProfessionInfoVC
@synthesize myTableView;
@synthesize statusView;
@synthesize basicInfo;

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
        label.text = @"专业信息";
        [label sizeToFit];
        self.title = @"专业信息";
        self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *saveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [saveBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [saveBt setTitle:@"服务介绍" forState:UIControlStateNormal];
        saveBt.titleLabel.adjustsFontSizeToFitWidth = YES;
//        saveBt.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
//        saveBt.layer.borderWidth = 1.0f;
        saveBt.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        saveBt.layer.borderColor = [[UIColor colorWithRed:152.0 / 255.0 green:67.0 / 255.0 blue:141.0 / 255.0 alpha:1.0] CGColor];
        [saveBt addTarget:self action:@selector(serviceIntroductionAction) forControlEvents:UIControlEventTouchUpInside];
        saveBt.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
        [buttons addObject:searchItem];
        self.navigationItem.rightBarButtonItems = buttons;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
    [self getAllServiceInfo];
    [self getAllHospitalAndMajorData];
}

- (void)initializaiton
{
    [super initializaiton];
    imageTag = 0;
    statusArray = @[@"基本信息",@"专业信息",@"等待审核"];
    nurseInfoArr = @[@"1年内",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
    nursejobArr = @[@"初级护士",@"初级护师",@"中级主管护师",@"副主任护师",@"主任护师"];
    isShowLanguage = NO;
    postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"NurseLanguage",@"",@"NurseGoodservice",@"",@"NurseNote",@"",@"NurseworkuUnit", nil];
    languageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    workUnitArr = [[NSMutableArray alloc] initWithCapacity:0];  //所有医院
    nurseOfficeArr = [[NSMutableArray alloc] initWithCapacity:0];
    nurseOfficeDic = [[NSMutableDictionary alloc] initWithCapacity:0];

    serviceIdDic = [[NSMutableDictionary alloc] initWithCapacity:0];  //可提供服务
    serviceArr = [[NSMutableArray alloc] initWithCapacity:0];  //可提供服务
    serviceSelectArr = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initView
{
    [super initView];
    //    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addStatueViewWithStatus:1];
}

//服务介绍
- (void)serviceIntroductionAction{
    ServiceListVC *serviceListVC = [[ServiceListVC alloc] init];
    serviceListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:serviceListVC animated:YES];
}
- (void)saveAction{
    NSLog(@"saveAction");
//    [self getAllServiceInfo];
    [self postProfessionInfo];
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
    if (tableView.tag == 500) {
        return serviceArr.count;
    }else if (tableView.tag == 501){
        return workUnitArr.count;
    }else if (tableView.tag == 502){
        return nurseOfficeArr.count;
    }else if (tableView.tag == 503){
        return nurseInfoArr.count;
    }else if (tableView.tag == 504){
        return nursejobArr.count;
    }
    return 9;

//    if (isShowLanguage){
//        return 9;
//    }else{
//        return 8;
//    }
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
    //    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:infoDic];
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView.tag == 500) {
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = serviceArr[row];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        
        CGFloat imageW = 20;
        CGFloat imageX = SCREENWIDTH-100;
        
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 12, imageW, imageW)];
        [cell addSubview:selectImage];
        selectImage.backgroundColor = [UIColor clearColor];
        selectImage.userInteractionEnabled = YES;
        selectImage.tag = row +50;
        
        for (NSString *serviceStr in serviceSelectArr) {
            
            if ([serviceStr isEqualToString:serviceArr[row]]) {
                selectImage.image = [UIImage imageNamed:@"icon_hook"];
            }
        }

        return cell;
    }else if (tableView.tag == 501){
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = workUnitArr[row];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        return cell;
    }else if (tableView.tag == 502){
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = nurseOfficeArr[row];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        return cell;
    }else if(tableView.tag == 503){
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREENWIDTH-120, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = nurseInfoArr[row];
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        
        CGFloat imageW = 25;
        CGFloat imageX = 15;
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 9, imageW, imageW)];
        [cell addSubview:selectImage];
        selectImage.backgroundColor = [UIColor clearColor];
        selectImage.userInteractionEnabled = YES;
        selectImage.tag = row +50;
        
        selectImage.image = [UIImage imageNamed:@"abc_btn_radio"];
        if ([nurseInfoArr[row] isEqualToString:[postDic valueForKey:@"nurseYearsofservice"]]) {
            selectImage.image = [UIImage imageNamed:@"abc_btn_radio_on"];
        }
        
        return cell;
    }else if(tableView.tag == 504){
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREENWIDTH-120, cellSize.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = nursejobArr[row];
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor grayColor];
        [cell addSubview:tipLabel];
        
        CGFloat imageW = 25;
        CGFloat imageX = 15;
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 9, imageW, imageW)];
        [cell addSubview:selectImage];
        selectImage.backgroundColor = [UIColor clearColor];
        selectImage.userInteractionEnabled = YES;
        selectImage.tag = row +50;
        
        selectImage.image = [UIImage imageNamed:@"abc_btn_radio"];
        if ([nursejobArr[row] isEqualToString:[postDic valueForKey:@"Nursejob"]]) {
            selectImage.image = [UIImage imageNamed:@"abc_btn_radio_on"];
        }
        
        return cell;
    }

    
    switch (row) {
//        case 0:
//        {
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"擅长语言";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor grayColor];
//            [cell addSubview:tipLabel];
//            
//            CGFloat btX = SCREENWIDTH-30;
//            CGFloat btW = 20;
//            
//            intoImageBt = [[UIButton alloc] initWithFrame:CGRectMake(btX, 11, btW, btW)];
//            [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_right"] forState:UIControlStateNormal];
//            [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_down"] forState:UIControlStateSelected];
//            [cell addSubview:intoImageBt];
//            [intoImageBt addTarget:self action:@selector(showLanguageView:) forControlEvents:UIControlEventTouchUpInside];
//            break;
//        }
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"工作单位";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-230;
            CGFloat fieldW = 200;
            
            workPlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            workPlaceLable.font = [UIFont systemFontOfSize:15.0];
            workPlaceLable.textAlignment = NSTextAlignmentRight;
            workPlaceLable.textColor = [UIColor blackColor];
            workPlaceLable.backgroundColor = [UIColor clearColor];
//            workPlaceLable.text = @"该护士未选定医院";
            [cell addSubview:workPlaceLable];
            break;
        }
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"科室";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-230;
            CGFloat fieldW = 200;
            
            officeLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            officeLable.font = [UIFont systemFontOfSize:15.0];
            officeLable.textAlignment = NSTextAlignmentRight;
            officeLable.textColor = [UIColor blackColor];
            officeLable.backgroundColor = [UIColor clearColor];
//            officeLable.text = @"该护士未选定专业";
            [cell addSubview:officeLable];
            break;
        }
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"职称";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-230;
            CGFloat fieldW = 200;
            
            professionNameLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            professionNameLable.font = [UIFont systemFontOfSize:15.0];
            professionNameLable.textAlignment = NSTextAlignmentRight;
            professionNameLable.textColor = [UIColor blackColor];
            professionNameLable.backgroundColor = [UIColor clearColor];
            [cell addSubview:professionNameLable];
            break;
        }
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"职业年限";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-230;
            CGFloat fieldW = 200;
            
            professionYearsL = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            professionYearsL.font = [UIFont systemFontOfSize:15.0];
            professionYearsL.textAlignment = NSTextAlignmentRight;
            professionYearsL.textColor = [UIColor blackColor];
            professionYearsL.backgroundColor = [UIColor clearColor];
            [cell addSubview:professionYearsL];
            break;
        }
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"可提供服务";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            
            //                CGFloat fieldX = SCREENWIDTH-230;
            //                CGFloat fieldW = 200;
            //
            //                UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            //                serviceLable.font = [UIFont systemFontOfSize:15.0];
            //                serviceLable.textAlignment = NSTextAlignmentRight;
            //                serviceLable.textColor = [UIColor blackColor];
            //                serviceLable.backgroundColor = [UIColor clearColor];
            //                serviceLable.text = @"1111";
            //                [cell addSubview:serviceLable];
            
            break;
        }
        case 5:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"个人优势";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            //                CGFloat fieldX = SCREENWIDTH-210;
            //                CGFloat fieldW = 200;
            //
            //                UITextField *advTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            //                advTextField.font = [UIFont systemFontOfSize:15.0];
            //                advTextField.textAlignment = NSTextAlignmentRight;
            //                advTextField.textColor = [UIColor blackColor];
            //                advTextField.backgroundColor = [UIColor clearColor];
            //                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //                advTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            //                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //                advTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            //                [cell addSubview:advTextField];
            break;
        }
        case 6:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"护士注册号";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-210;
            CGFloat fieldW = 200;
            
            nurseNumberField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            nurseNumberField.font = [UIFont systemFontOfSize:15.0];
            nurseNumberField.textAlignment = NSTextAlignmentRight;
            nurseNumberField.textColor = [UIColor blackColor];
            nurseNumberField.backgroundColor = [UIColor clearColor];
            nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            nurseNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            nurseNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:nurseNumberField];
            
            break;
        }
        case 7:
        {
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
//            [cell addSubview:bgView];
//            bgView.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
            
            UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDTH-20, 20)];
            [cell addSubview:tipL];
            tipL.backgroundColor = [UIColor clearColor];
            tipL.text = @"请上传相关证书";//@"我们将为您保密，审核通过后可使用完整功能";
            tipL.font = [UIFont systemFontOfSize:15.0];
            tipL.textColor = [UIColor grayColor];
            
            CGFloat headImageW = 130;
            CGFloat imageY = 40;
            
            photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:photoImageView];
            photoImageView.userInteractionEnabled = YES;
            photoImageView.backgroundColor = [UIColor clearColor];
            photoImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
            
            UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadProfessionPhotoAction)];
            [photoImageView addGestureRecognizer:clickTap];
            
            CGFloat tipLabelX = CGRectGetMaxX(photoImageView.frame)+10;
            CGFloat tipLabelY = CGRectGetMaxY(photoImageView.frame)-60;
            CGFloat tipLabelW = SCREENWIDTH-CGRectGetMaxX(photoImageView.frame)-20;
            
            UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel1.adjustsFontSizeToFitWidth = YES;
            tipLabel1.backgroundColor = [UIColor clearColor];
            tipLabel1.text = @"上传职业证书正面照";
            tipLabel1.font = [UIFont systemFontOfSize:15.0];
            tipLabel1.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel1];
            
            
            imageY = CGRectGetMaxY(photoImageView.frame)+20;
            idCardFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:idCardFrontImageView];
            idCardFrontImageView.userInteractionEnabled = YES;
            idCardFrontImageView.backgroundColor = [UIColor clearColor];
            idCardFrontImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
            
            UITapGestureRecognizer *clickTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPowerPhotoAction)];
            [idCardFrontImageView addGestureRecognizer:clickTap1];
            
            tipLabelX = CGRectGetMaxX(idCardFrontImageView.frame)+10;
            tipLabelY = CGRectGetMaxY(idCardFrontImageView.frame)-60;
            UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel2.adjustsFontSizeToFitWidth = YES;
            tipLabel2.backgroundColor = [UIColor clearColor];
            tipLabel2.text = @"上传资格证书正面照";
            tipLabel2.font = [UIFont systemFontOfSize:15.0];
            tipLabel2.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel2];
            
            imageY = CGRectGetMaxY(idCardFrontImageView.frame)+20;
            idCardDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageY, headImageW, 80)];
            [cell addSubview:idCardDownImageView];
            idCardDownImageView.userInteractionEnabled = YES;
            idCardDownImageView.backgroundColor = [UIColor clearColor];
            idCardDownImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
            
            UITapGestureRecognizer *clickTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadProfeesionNamePhotoAction)];
            [idCardDownImageView addGestureRecognizer:clickTap2];
            
            tipLabelX = CGRectGetMaxX(idCardDownImageView.frame)+10;
            tipLabelY = CGRectGetMaxY(idCardDownImageView.frame)-60;
            UILabel *tipLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, tipLabelW, 44)];
            tipLabel3.adjustsFontSizeToFitWidth = YES;
            tipLabel3.backgroundColor = [UIColor clearColor];
            tipLabel3.text = @"上传职称证书正面照";
            tipLabel3.font = [UIFont systemFontOfSize:15.0];
            tipLabel3.textColor = [UIColor blackColor];
            [cell addSubview:tipLabel3];
            
            
//            CGFloat photoW = 60;
//            photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, photoW, photoW)];
//            [cell addSubview:photoImageView];
//            photoImageView.userInteractionEnabled = YES;
//            photoImageView.backgroundColor = [UIColor grayColor];
//            photoImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
//            
//            UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoImageAction)];
//            [photoImageView addGestureRecognizer:clickTap];
//            
//            CGFloat tipLabelX = 20+photoW;
//            CGFloat tipLabelY = 10+photoW/2.0-22;
//            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, 150, 44)];
//            tipLabel.backgroundColor = [UIColor clearColor];
//            tipLabel.text = @"请上传相关照片";
//            tipLabel.font = [UIFont systemFontOfSize:15.0];
//            tipLabel.textColor = [UIColor blackColor];
//            [cell addSubview:tipLabel];
            
            break;
        }
        case 8:
        {
            UILabel *nextStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, cellSize.height)];
            nextStepLabel.backgroundColor = APPDEFAULTTITLECOLOR;
            nextStepLabel.text = @"提交审核";
            nextStepLabel.textAlignment = NSTextAlignmentCenter;
            nextStepLabel.font = [UIFont systemFontOfSize:15.0];
            nextStepLabel.textColor = [UIColor whiteColor];
            [cell addSubview:nextStepLabel];
            break;
        }
            
        default:
            break;
    }
    
    
    
    
    
    
    
    /*
    if (isShowLanguage) {
        switch (row) {
            case 0:
            {
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"擅长语言";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat btX = SCREENWIDTH-30;
                CGFloat btW = 20;
                
                intoImageBt = [[UIButton alloc] initWithFrame:CGRectMake(btX, 11, btW, btW)];
                [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_down"] forState:UIControlStateNormal];
//                [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_right"] forState:UIControlStateSelected];
                [cell addSubview:intoImageBt];
                [intoImageBt addTarget:self action:@selector(showLanguageView:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 1:
            {
                
                CGFloat buttonW = 50;
                CGFloat buttonH = 20;
                CGFloat buttonX = 5;//(SCREENWIDTH/5.0-buttonW)/2.0;
                CGFloat buttonY = 12;
                NSArray *itemsArr = @[@"汉语",@"英语",@"日语",@"韩语",@"法语"];
                for (int i = 0; i<itemsArr.count; i++) {
                    int j = 5;  //每行个数
                    if (i<j) {
                        
                        UIButton *languageBtn = [[UIButton alloc] initWithFrame:CGRectMake(5+60*i, buttonY, buttonW, buttonH)];
                        languageBtn.backgroundColor = [UIColor clearColor];
                        [languageBtn setTitleColor:APPDEFAULTTITLECOLOR forState:UIControlStateSelected];
                        [languageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        languageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                        languageBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
                        languageBtn.layer.borderWidth = 1.0f;//设置边框颜色
                        
                        languageBtn.layer.borderColor = [[UIColor grayColor] CGColor];
                        
                        [languageBtn setTitle:itemsArr[i] forState:UIControlStateNormal];
                        languageBtn.tag = 100 + i;
                        [languageBtn addTarget:self action:@selector(changeLanguageBtnCorlor:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:languageBtn];
                    }
                }
                break;
            }
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"工作单位";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-230;
                CGFloat fieldW = 200;
                
                workPlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                workPlaceLable.font = [UIFont systemFontOfSize:15.0];
                workPlaceLable.textAlignment = NSTextAlignmentRight;
                workPlaceLable.textColor = [UIColor blackColor];
                workPlaceLable.backgroundColor = [UIColor clearColor];
                workPlaceLable.text = @"该护士未选定医院";
                [cell addSubview:workPlaceLable];
                break;
            }
            case 3:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"科室";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-230;
                CGFloat fieldW = 200;
                
                officeLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                officeLable.font = [UIFont systemFontOfSize:15.0];
                officeLable.textAlignment = NSTextAlignmentRight;
                officeLable.textColor = [UIColor blackColor];
                officeLable.backgroundColor = [UIColor clearColor];
                officeLable.text = @"该护士未选定专业";
                [cell addSubview:officeLable];
                break;
            }
            case 4:
            {
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"护士注册号";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-210;
                CGFloat fieldW = 200;
                
                nurseNumberField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                nurseNumberField.font = [UIFont systemFontOfSize:15.0];
                nurseNumberField.textAlignment = NSTextAlignmentRight;
                nurseNumberField.textColor = [UIColor blackColor];
                nurseNumberField.backgroundColor = [UIColor clearColor];
                nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                nurseNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                nurseNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:nurseNumberField];
                
                break;
            }
            case 5:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"可提供服务";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                
//                CGFloat fieldX = SCREENWIDTH-230;
//                CGFloat fieldW = 200;
//                
//                UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
//                serviceLable.font = [UIFont systemFontOfSize:15.0];
//                serviceLable.textAlignment = NSTextAlignmentRight;
//                serviceLable.textColor = [UIColor blackColor];
//                serviceLable.backgroundColor = [UIColor clearColor];
//                serviceLable.text = @"1111";
//                [cell addSubview:serviceLable];
                
                break;
            }
            case 6:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"个人优势";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
//                CGFloat fieldX = SCREENWIDTH-210;
//                CGFloat fieldW = 200;
//                
//                UITextField *advTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
//                advTextField.font = [UIFont systemFontOfSize:15.0];
//                advTextField.textAlignment = NSTextAlignmentRight;
//                advTextField.textColor = [UIColor blackColor];
//                advTextField.backgroundColor = [UIColor clearColor];
//                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                advTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                advTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//                [cell addSubview:advTextField];
                break;
            }
            case 7:
            {
                CGFloat photoW = 60;
                photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, photoW, photoW)];
                [cell addSubview:photoImageView];
                photoImageView.userInteractionEnabled = YES;
                photoImageView.backgroundColor = [UIColor grayColor];
                photoImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
                
                UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoImageAction)];
                [photoImageView addGestureRecognizer:clickTap];
                
                CGFloat tipLabelX = 20+photoW;
                CGFloat tipLabelY = 10+photoW/2.0-22;
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, 150, 44)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"请上传相关照片";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor blackColor];
                [cell addSubview:tipLabel];
                
                break;
            }
            case 8:
            {
                UILabel *nextStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, cellSize.height)];
                nextStepLabel.backgroundColor = APPDEFAULTTITLECOLOR;
                nextStepLabel.text = @"完成";
                nextStepLabel.textAlignment = NSTextAlignmentCenter;
                nextStepLabel.font = [UIFont systemFontOfSize:15.0];
                nextStepLabel.textColor = [UIColor whiteColor];
                [cell addSubview:nextStepLabel];
                break;
            }
                
            default:
                break;
        }
    }else{
        switch (row) {
            case 0:
            {
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"擅长语言";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat btX = SCREENWIDTH-30;
                CGFloat btW = 20;
                
                intoImageBt = [[UIButton alloc] initWithFrame:CGRectMake(btX, 11, btW, btW)];
                [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_right"] forState:UIControlStateNormal];
                [intoImageBt setBackgroundImage:[UIImage imageNamed:@"icon_into_down"] forState:UIControlStateSelected];
                [cell addSubview:intoImageBt];
                [intoImageBt addTarget:self action:@selector(showLanguageView:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"工作单位";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-230;
                CGFloat fieldW = 200;
                
                workPlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                workPlaceLable.font = [UIFont systemFontOfSize:15.0];
                workPlaceLable.textAlignment = NSTextAlignmentRight;
                workPlaceLable.textColor = [UIColor blackColor];
                workPlaceLable.backgroundColor = [UIColor clearColor];
                workPlaceLable.text = @"该护士未选定医院";
                [cell addSubview:workPlaceLable];
                break;
            }
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"科室";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-230;
                CGFloat fieldW = 200;
                
                officeLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                officeLable.font = [UIFont systemFontOfSize:15.0];
                officeLable.textAlignment = NSTextAlignmentRight;
                officeLable.textColor = [UIColor blackColor];
                officeLable.backgroundColor = [UIColor clearColor];
                officeLable.text = @"该护士未选定专业";
                [cell addSubview:officeLable];
                break;
            }
            case 3:
            {
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"护士注册号";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                CGFloat fieldX = SCREENWIDTH-210;
                CGFloat fieldW = 200;
                
                nurseNumberField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                nurseNumberField.font = [UIFont systemFontOfSize:15.0];
                nurseNumberField.textAlignment = NSTextAlignmentRight;
                nurseNumberField.textColor = [UIColor blackColor];
                nurseNumberField.backgroundColor = [UIColor clearColor];
                nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                nurseNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                nurseNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                nurseNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:nurseNumberField];
                
                break;
            }
            case 4:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"可提供服务";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                
                //                CGFloat fieldX = SCREENWIDTH-230;
                //                CGFloat fieldW = 200;
                //
                //                UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                //                serviceLable.font = [UIFont systemFontOfSize:15.0];
                //                serviceLable.textAlignment = NSTextAlignmentRight;
                //                serviceLable.textColor = [UIColor blackColor];
                //                serviceLable.backgroundColor = [UIColor clearColor];
                //                serviceLable.text = @"1111";
                //                [cell addSubview:serviceLable];
                
                break;
            }
            case 5:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"个人优势";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor grayColor];
                [cell addSubview:tipLabel];
                
                //                CGFloat fieldX = SCREENWIDTH-210;
                //                CGFloat fieldW = 200;
                //
                //                UITextField *advTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
                //                advTextField.font = [UIFont systemFontOfSize:15.0];
                //                advTextField.textAlignment = NSTextAlignmentRight;
                //                advTextField.textColor = [UIColor blackColor];
                //                advTextField.backgroundColor = [UIColor clearColor];
                //                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                //                advTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                //                advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                //                advTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                //                [cell addSubview:advTextField];
                break;
            }
            case 6:
            {
                CGFloat photoW = 60;
                photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, photoW, photoW)];
                [cell addSubview:photoImageView];
                photoImageView.userInteractionEnabled = YES;
                photoImageView.backgroundColor = [UIColor grayColor];
                photoImageView.image = [UIImage imageNamed:@"icon_add_photo_violet"];
                
                UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoImageAction)];
                [photoImageView addGestureRecognizer:clickTap];
                
                CGFloat tipLabelX = 20+photoW;
                CGFloat tipLabelY = 10+photoW/2.0-22;
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelX, tipLabelY, 150, 44)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = @"请上传相关照片";
                tipLabel.font = [UIFont systemFontOfSize:15.0];
                tipLabel.textColor = [UIColor blackColor];
                [cell addSubview:tipLabel];
                
                break;
            }
            case 7:
            {
                UILabel *nextStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, cellSize.height)];
                nextStepLabel.backgroundColor = APPDEFAULTTITLECOLOR;
                nextStepLabel.text = @"完成";
                nextStepLabel.textAlignment = NSTextAlignmentCenter;
                nextStepLabel.font = [UIFont systemFontOfSize:15.0];
                nextStepLabel.textColor = [UIColor whiteColor];
                [cell addSubview:nextStepLabel];
                break;
            }
                
            default:
                break;
        }
    }
    */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
   
    if (tableView.tag == 500 || tableView.tag == 501 || tableView.tag == 502) {
        return 50;
    }
    switch (row) {
        case 0:
            return 44;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 44;
            break;
        case 3:
            return 44;
            break;
        case 4:
            return 44;
            break;
        case 5:
            return 44;
            break;
        case 6:
            return 44;

//            if (isShowLanguage) {
//                return 40;
//            }else{
//                return 140;
//            }
            break;
        case 7:
            return 110*3+10;
            break;
//            if (isShowLanguage) {
//                return 140;
//            }else{
//                return 40;
//            }
        case 8:
//            if (isShowLanguage) {
//                return 40;
//            }
            return 44;
            break;
        default:
            break;
    }
    
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 500 || tableView.tag == 501 || tableView.tag == 502) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSLog(@"tag:%ld,%ld",tableView.tag,row);
    if (tableView.tag == 500) {
        NSLog(@"!!!!!!!!!!!!!!!!!");
        NSLog(@"%@",serviceArr[row]);
        
        for (int i = 0; i < serviceSelectArr.count; i++) {
            if ([serviceSelectArr[i] isEqualToString:serviceArr[row]]) {
                //移除
                [serviceSelectArr removeObjectAtIndex:i];
                
                [tableView reloadData];
                return;
            }
        }
        [serviceSelectArr addObject:serviceArr[row]];
        [tableView reloadData];
        return;
    }else if (tableView.tag == 501){
        [postDic setObject:workUnitArr[row] forKey:@"NurseworkuUnit"];
        if (nurseOfficeArr.count>0) {
            [nurseOfficeArr removeAllObjects];
        }
        [nurseOfficeArr addObjectsFromArray:[nurseOfficeDic objectForKey:workUnitArr[row]]];
        
        [self closeWindowView];
        [workPlaceLable setText:workUnitArr[row]];
        return;
    }else if (tableView.tag == 502){
        
        [postDic setObject:nurseOfficeArr[row] forKey:@"NurseOffice"];
        
        [self closeWindowView];
        [officeLable setText:nurseOfficeArr[row]];
        return;
    }else if (tableView.tag == 503){
        
        [postDic setValue:nurseInfoArr[row] forKey:@"nurseYearsofservice"];
        [tableView reloadData];
        [professionYearsL setText:nurseInfoArr[row]];
        return;
    }else if (tableView.tag == 504){
        
        [postDic setValue:nursejobArr[row] forKey:@"Nursejob"];
        [tableView reloadData];
        [professionNameLable setText:nursejobArr[row]];
        return;
    }
    NSLog(@"row = %ld, section = %ld",row,section);
    switch (row) {
        case 0:
        {
            [self showWorkAlertView];
        }
            break;
        case 1:
        {
            if (![[NSString stringWithFormat:@"%@",[postDic objectForKey:@"NurseworkuUnit"]] isEqualToString:@""]) {
                [self showOfficeAlertView];
            }else{
                [self.view makeToast:@"请先选择工作单位" duration:1.2 position:@"center"];
            }
        }
            break;
        case 2:
        {
            [self ShowNurserJobAlertView];
        }
            break;
        case 3:
        {
            [self ShowNurserInfo];
        }
            break;
        case 4:
        {
            [self showServiceAlertView];
        }
            break;
        case 5:
        {
            [self showNurseNoteAlertView];
        }
            break;
        case 6:
        {
//            [self showNurseNoteAlertView];
        }
            break;
        case 7:
        {
        }
            break;
        case 8:
        {
            [self postProfessionInfo];
            
        }
            break;
            
        default:
            break;
    }
    
//    if (isShowLanguage) {
//        switch (row) {
//            case 0:
//            {
//                [self showWorkAlertView];
//            }
//                break;
//            case 1:
//            {
//                if (![[NSString stringWithFormat:@"%@",[postDic objectForKey:@"NurseworkuUnit"]] isEqualToString:@""]) {
//                    [self showOfficeAlertView];
//                }else{
//                    [self.view makeToast:@"请先选择工作单位" duration:1.2 position:@"center"];
//                }
//            }
//                break;
//            case 2:
//            {
//            }
//                break;
//            case 3:
//            {
//                
//            }
//                break;
//            case 4:
//            {
//            }
//                break;
//            case 5:
//            {
//                [self showServiceAlertView];
//            }
//                break;
//            case 6:
//            {
//                [self showNurseNoteAlertView];
//            }
//                break;
//            case 7:
//            {
//            }
//                break;
//            case 8:
//            {
//                [self postProfessionInfo];
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }else{
    
//        switch (row) {
//            case 0:
//            {
//            }
//                break;
//            case 1:
//            {
//                [self showWorkAlertView];
//            }
//                break;
//            case 2:
//            {
//                if (![[NSString stringWithFormat:@"%@",[postDic objectForKey:@"NurseworkuUnit"]] isEqualToString:@""]) {
//                    [self showOfficeAlertView];
//                }else{
//                    [self.view makeToast:@"请先选择工作单位" duration:1.2 position:@"center"];
//                }
//            }
//                break;
//            case 3:
//            {
//            }
//                break;
//            case 4:
//            {
//                [self showServiceAlertView];
//            }
//                break;
//            case 5:
//            {
//                [self showNurseNoteAlertView];
//            }
//                break;
//            case 6:
//            {
//            }
//                break;
//            case 7:
//            {
//                [self postProfessionInfo];
//            }
//                break;
//            case 8:
//            {
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
}

- (void)postProfessionInfo{
    
    if ([[postDic valueForKey:@"NurseNurseLicensepic"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseNurseLicensepic1"] isEqualToString:@""] ||
        [[postDic valueForKey:@"NurseNurseLicensepic2"] isEqualToString:@""]) {
        
        [self showAlertView];
        return;
    }
    
    NSString *nurseLicensepic = [NSString stringWithFormat:@"%@,%@,%@",[postDic valueForKey:@"NurseNurseLicensepic"],[postDic valueForKey:@"NurseNurseLicensepic1"],[postDic valueForKey:@"NurseNurseLicensepic2"]];
    
    NSString *NurseworkuUnit = [postDic objectForKey:@"NurseworkuUnit"];
    if (!NurseworkuUnit || [NurseworkuUnit isEqualToString:@""]) {
        NurseworkuUnit = @"";
        [self showAlertView];
        return;
    }
    NSString *NurseOffice = [postDic objectForKey:@"NurseOffice"];
    if (!NurseOffice || [NurseOffice isEqualToString:@""]) {
        NurseOffice = @"";
        [self showAlertView];
        return;
    }
    NSString *Nursejob = [postDic objectForKey:@"Nursejob"];
    if (!Nursejob || [Nursejob isEqualToString:@""]) {
        Nursejob = @"";
        [self showAlertView];
        return;
    }
    NSString *nurseYearsofservice = [postDic objectForKey:@"nurseYearsofservice"];
    if (!nurseYearsofservice || [nurseYearsofservice isEqualToString:@""]) {
        nurseYearsofservice = @"";
        [self showAlertView];
        return;
    }
    NSString *NurseGoodservice = [postDic objectForKey:@"NurseGoodservice"];
    if (!NurseGoodservice || [NurseGoodservice isEqualToString:@""]) {
        NurseGoodservice = @"";
        [self showAlertView];
        return;
    }

    NSString *NurseNote = [postDic objectForKey:@"NurseNote"];
    if (!NurseNote || [NurseNote isEqualToString:@""]) {
        NurseNote = @"";
        [self showAlertView];
        return;
    }

    NSString *nurseNumber = nurseNumberField.text;
    if (!nurseNumber || [nurseNumber isEqualToString:@""]) {
        nurseNumber = @"";
        [self showAlertView];
        return;
    }
//        NSString *NurseLanguage = [postDic objectForKey:@"NurseLanguage"];
//        if (!NurseLanguage) {
//            NurseLanguage = @"";
//        }

    
    
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"NurseId" : userAccount,
                               @"NurseHeader" : [basicInfo valueForKey:@"NurseHeader"],
                               @"NurseTruePic" : [basicInfo valueForKey:@"NurseTruePic"],
                               @"nurseTruename" : [basicInfo valueForKey:@"nurseTruename"],
                               @"NurseSex" : @"",
                               @"NurseAge" : @"",
                               @"NurseCard" : [basicInfo valueForKey:@"NurseCard"],
                               @"NurseCardpic" : [NSString stringWithFormat:@"%@,%@,%@",[basicInfo valueForKey:@"NurseCardpic1"],[basicInfo valueForKey:@"NurseCardpic2"],[basicInfo valueForKey:@"NurseCardpic3"]],
                               
                               @"NurseworkuUnit" : NurseworkuUnit,
                               @"NurseOffice" : NurseOffice,
                               @"Nursejob" : Nursejob,  //职称
                               @"NurseNumber" : nurseNumber,
                               @"Nurseyearsofservice" : nurseYearsofservice,  //职业年限
                               @"NurseGoodservice" : NurseGoodservice,
                               @"NurseNote" : NurseNote,
                               @"NurseNurseLicensepic" : nurseLicensepic
//                               @"NurseLanguage" : NurseLanguage,
//
                               };
    [self showHudInView:self.view hint:@"提交中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSEINFOIDENTIFY params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];

        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        [self performSelector:@selector(goToHomeView) withObject:nil afterDelay:1.2];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self hideHud];

        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)goToHomeView{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_JUSTTOROOTVIEW object:nil];
}

- (void)showLanguageView:(UIButton *)sender{
    
    intoImageBt.selected = !sender.selected;
//    sender.selected = !sender.selected;
    isShowLanguage = !isShowLanguage;
    [myTableView reloadData];
}

//职业证书
- (void)loadProfessionPhotoAction{
    imageTag = 0;
    [self showActionSheet];

}
//资格证书
- (void)loadPowerPhotoAction{
    imageTag = 1;
    [self showActionSheet];

}
//职称证书
- (void)loadProfeesionNamePhotoAction{
    imageTag = 2;
    [self showActionSheet];

}

- (void)clickPhotoImageAction{
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
        photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        CGSize sizeImage = photoImage.size;
        float a = [self getSize:sizeImage];
        if (a > 0) {
            CGSize size = CGSizeMake(sizeImage.width/a, sizeImage.height/a);
            photoImage = [self scaleToSize:photoImage size:size];
        }
        
        NSData *data;
        if (UIImagePNGRepresentation(photoImage) == nil)
        {
            data = UIImageJPEGRepresentation(photoImage, 0.6);
        }
        else
        {
            data = UIImagePNGRepresentation(photoImage);
        }
        
        photoImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (imageTag == 0) {
                photoImageView.image = photoImage;
                [postDic setValue:photoImageStr forKey:@"NurseNurseLicensepic"];
            }else if(imageTag == 1){
                [postDic setValue:photoImageStr forKey:@"NurseNurseLicensepic1"];
                idCardFrontImageView.image = photoImage;
            }else if(imageTag == 2){
                [postDic setValue:photoImageStr forKey:@"NurseNurseLicensepic2"];
                idCardDownImageView.image = photoImage;
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

- (void)changeLanguageBtnCorlor:(UIButton *)sender{
    if (!sender.isSelected) {
        sender.layer.borderColor = [APPDEFAULTTITLECOLOR CGColor];
    }else{
        sender.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    sender.selected = !sender.selected;
    
    NSLog(@"%ld",sender.tag);
    NSString *keyValue = [NSString stringWithFormat:@"langeage_%ld",sender.tag];
    NSArray *itemsArr = @[@"汉语",@"英语",@"日语",@"韩语",@"法语"];
    if (sender.selected) {
        [languageDic setObject:itemsArr[sender.tag-100] forKey:keyValue];
    }else{
        [languageDic removeObjectForKey:keyValue];
    }
    NSString *languageStr = @"";
    for (NSString *value in [languageDic allValues]) {
        languageStr = [languageStr stringByAppendingFormat:@",%@",value];;
    }
    
    if (languageStr.length > 0) {
        languageStr = [languageStr substringFromIndex:1];
    }
    [postDic setObject:languageStr forKey:@"NurseLanguage"];

}

- (void)showNurseNoteAlertView{
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 150;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger addTextField_H = 110;
    NSInteger addTextField_Y = 10;
    NSInteger addTextField_W =SCREENWIDTH-40;
    
    nurseNoteText = [[UITextView alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];
    [nurseNoteText setBackgroundColor:[UIColor clearColor]];
    [addBgView addSubview:nurseNoteText];
    nurseNoteText.text = @"个人优势";
    nurseNoteText.font = [UIFont systemFontOfSize:12.0];
    nurseNoteText.textColor = [UIColor blackColor];
    
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = CGRectGetMaxY(nurseNoteText.frame)+5;
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
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 101;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)showServiceAlertView{
    
    //serviceArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 44*serviceArr.count;
    NSInteger addBgView_Y = (SCREENHEIGH-addBgView_H)/2.0;//SCREENHEIGH/2.0-addBgView_H/2.0-40;
    addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, addBgView_W, addBgView_H-50) style:UITableViewStylePlain];
    tableview.tag = 500;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSInteger cancleBt_X = SCREENWIDTH-50-90;
    NSInteger cancleBt_Y = CGRectGetMaxY(tableview.frame)+10;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X+50, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 100;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

- (void)showOfficeAlertView{
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    windowView.userInteractionEnabled = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 150;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, addBgView_W, addBgView_H) style:UITableViewStylePlain];
    tableview.tag = 502;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    //    tableview.scrollEnabled = NO;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *deletView = [[UIImageView alloc] initWithFrame:CGRectMake(addBgView_W-20, 0, 20, 20)];
    deletView.backgroundColor =[UIColor clearColor];
    [addBgView addSubview:deletView];
    deletView.userInteractionEnabled = YES;
    deletView.image = [UIImage imageNamed:@"delete"];
    
    UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindowView)];
    [deletView addGestureRecognizer:clickTap];
}

- (void)showWorkAlertView{
//    nurseOfficeArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    windowView.userInteractionEnabled = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 250;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, addBgView_W, addBgView_H) style:UITableViewStylePlain];
    tableview.tag = 501;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    //    tableview.scrollEnabled = NO;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIImageView *deletView = [[UIImageView alloc] initWithFrame:CGRectMake(addBgView_W-20, 0, 20, 20)];
    deletView.backgroundColor =[UIColor clearColor];
    [addBgView addSubview:deletView];
    deletView.userInteractionEnabled = YES;
    deletView.image = [UIImage imageNamed:@"delete"];
    
    UITapGestureRecognizer *clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindowView)];
    [deletView addGestureRecognizer:clickTap];
}

- (void)closeWindowView{
    if (addBgView) {
        [addBgView removeFromSuperview];
        addBgView = nil;
    }
    if (windowView) {
        [windowView removeFromSuperview];
        windowView= nil;
    }
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isDescendantOfView:addBgView]) //forgotPasswordView等为不想响应手势的subview
//        return NO;
//    else
//        return YES;
//}
- (void)clickBtAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    if (sender.tag == 100) {
//        serviceSelectArr
        NSString *serviceStr = @"";
        for (NSString *value in serviceSelectArr) {
            NSString *serviceItem = [NSString stringWithFormat:@"%@",[serviceIdDic objectForKey:value]];
            
            serviceStr = [serviceStr stringByAppendingFormat:@",%@",serviceItem];;
        }
        
        if (serviceStr.length > 0) {
            serviceStr = [serviceStr substringFromIndex:1];
        }
        [postDic setObject:serviceStr forKey:@"NurseGoodservice"];
        
    }else if (sender.tag == 101){
        NSLog(@"nurseNoteText:%@",nurseNoteText.text);
        
        [postDic setObject:nurseNoteText.text forKey:@"NurseNote"];
    }
    
    if (addBgView) {
        [addBgView removeFromSuperview];
        addBgView = nil;
    }
    if (windowView) {
        [windowView removeFromSuperview];
        windowView= nil;
    }
}

//获取所有的服务
- (void)getAllServiceInfo{
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"content/SelectContentAllinfo.action" params:nil success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSArray *temp = [NSArray arrayWithArray:[respondDict objectForKey:@"json"]];
            for (int i = 0; i<temp.count; i++) {
                NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:temp[i]];
                [serviceArr addObject:[tempDic objectForKey:@"manageNursingContentName"]];
                [serviceIdDic setObject:[tempDic objectForKey:@"manageNursingContentId"] forKey:[tempDic objectForKey:@"manageNursingContentName"]];
            }
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
//        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}


//获取所有医院
- (void)getAllHospitalAndMajorData{

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/selecthospitalandmajor.action" params:nil success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        respondString = [Tool deleteErrorStringInString:respondString];
        
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            
            NSArray *temp = [NSArray arrayWithArray:[respondDict objectForKey:@"json"]];
            for (int i = 0; i<temp.count; i++) {
                
                NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:temp[i]];
                NSMutableDictionary *nurseDic = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for (NSString *key in [userInfoDic allKeys]) {
                    
                    if ([[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] isEqualToString:@"<null>"]) {
                        NSLog(@"key:%@",key);
                        [nurseDic setValue:@"" forKey:key];
                    }else{
                        [nurseDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:key]] forKey:key];
                    }
                }
                [workUnitArr addObject:[nurseDic objectForKey:@"hospitalName"]];
                
                NSMutableArray *tempMaj = [NSMutableArray arrayWithArray:[[nurseDic objectForKey:@"maj"] objectFromJSONString]];
                NSMutableArray *hospitalArr = [[NSMutableArray alloc] initWithCapacity:0];
                for (int j = 0; j < tempMaj.count; j++) {
                    [hospitalArr addObject:[tempMaj[j] objectForKey:@"majorName"]];
                }
                [nurseOfficeDic setObject:hospitalArr forKey:[nurseDic objectForKey:@"hospitalName"]];
                
            }
            NSLog(@"success");
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
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


- (void)ShowNurserInfo{
    //serviceArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 44*nurseInfoArr.count+100;
    NSInteger addBgView_Y = (SCREENHEIGH-addBgView_H)/2.0;//SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger titleH = 44;
    NSInteger titleY = 5;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, titleY, 200, titleH)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"请选择医护信息";
    
    titleY = 50;
    titleH = 44*nurseInfoArr.count;
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleY, addBgView_W, titleH) style:UITableViewStylePlain];
    tableview.tag = 503;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSInteger cancleBt_X = addBgView_W-60;
    NSInteger cancleBt_Y = CGRectGetMaxY(tableview.frame)+10;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 0;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

- (void)ShowNurserJobAlertView{
    //serviceArr
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 44*nurseInfoArr.count+100;
    NSInteger addBgView_Y = (SCREENHEIGH-addBgView_H)/2.0;//SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];
    
    NSInteger titleH = 44;
    NSInteger titleY = 5;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, titleY, 200, titleH)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"请选择职称";
    
    titleY = 50;
    titleH = 44*nursejobArr.count;
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleY, addBgView_W, titleH) style:UITableViewStylePlain];
    tableview.tag = 504;
    tableview.delegate = self;
    tableview.dataSource = self;
    [addBgView addSubview:tableview];
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor whiteColor];
    [Tool setExtraCellLineHidden:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSInteger cancleBt_X = addBgView_W-60;
    NSInteger cancleBt_Y = CGRectGetMaxY(tableview.frame)+10;
    NSInteger cancleBt_W = 40;
    NSInteger cancleBt_H = 20;
    
    UIButton *cancleBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X-60, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
    cancleBt.backgroundColor = [UIColor clearColor];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancleBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancleBt.tag = 0;
    [cancleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:cancleBt];
    
    UIButton *okBt = [[UIButton alloc] initWithFrame:CGRectMake(cancleBt_X, cancleBt_Y, cancleBt_W, cancleBt_H)];
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
    okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 0;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
