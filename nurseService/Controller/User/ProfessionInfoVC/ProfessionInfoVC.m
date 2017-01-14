//
//  ProfessionInfoVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ProfessionInfoVC.h"
#import "HeBaseTableViewCell.h"

@interface ProfessionInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *statusArray;
    BOOL isShowLanguage;
    UIButton *intoImageBt;
    UIImage *photoImage;
    NSString *photoImageStr;
    UIImageView *photoImageView;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)IBOutlet UIView *statusView;
@end

@implementation ProfessionInfoVC
@synthesize myTableView;
@synthesize statusView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *saveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        [saveBt setTitleColor:APPDEFAULTTITLECOLOR forState:UIControlStateNormal];
        [saveBt setTitle:@"保存" forState:UIControlStateNormal];
        saveBt.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
        saveBt.layer.borderWidth = 1.0f;
        saveBt.layer.borderColor = [[UIColor colorWithRed:152.0 / 255.0 green:67.0 / 255.0 blue:141.0 / 255.0 alpha:1.0] CGColor];
        [saveBt addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        saveBt.backgroundColor = [UIColor blackColor];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
        [buttons addObject:searchItem];
        self.navigationItem.rightBarButtonItems = buttons;

        self.title = @"基本信息";
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
    isShowLanguage = NO;
    
}

- (void)initView
{
    [super initView];
    //    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    footerView.backgroundColor = APPDEFAULTORANGE;
    myTableView.tableFooterView = footerView;
    
    UIButton *nextStepBt = [[UIButton alloc] initWithFrame:footerView.frame];
    nextStepBt.backgroundColor = [UIColor clearColor];
    [nextStepBt setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBt addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextStepBt];
    
    
    [self addStatueViewWithStatus:0];
}

- (void)saveAction{
    NSLog(@"saveAction");
}

- (void)nextStepAction{
    
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
    if (isShowLanguage){
        return 9;
    }else{
        return 8;
    }
    
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
    
    if (isShowLanguage) {
        
    }else{
        if (row == 1) {
            row = row + 1;
        }
    }
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
            CGFloat buttonW = 50;
            CGFloat buttonH = 20;
            CGFloat buttonX = (SCREENWIDTH/5.0-buttonW)/2.0;
            CGFloat buttonY = 12;
            NSArray *itemsArr = @[@"汉语",@"英语",@"日语",@"韩语",@"法语"];
            for (int i = 0; i<5; i++) {
                int j = 3;
                if (i<j) {

                    UIButton *languageBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX+(SCREENWIDTH/5.0)*i, buttonY, buttonW, buttonH)];
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
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"工作单位";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-210;
            CGFloat fieldW = 200;
            
            UITextField *workPlaceTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            workPlaceTextField.font = [UIFont systemFontOfSize:15.0];
            workPlaceTextField.textAlignment = NSTextAlignmentRight;
            workPlaceTextField.textColor = [UIColor blackColor];
            workPlaceTextField.backgroundColor = [UIColor clearColor];
            workPlaceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            workPlaceTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            workPlaceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            workPlaceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:workPlaceTextField];
            break;
        }
        case 3:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"科室";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
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

            break;
        }
        case 5:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"可以供服务";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-210;
            CGFloat fieldW = 200;
            
            UITextField *serviceTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            serviceTextField.font = [UIFont systemFontOfSize:15.0];
            serviceTextField.textAlignment = NSTextAlignmentRight;
            serviceTextField.textColor = [UIColor blackColor];
            serviceTextField.backgroundColor = [UIColor clearColor];
            serviceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            serviceTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            serviceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            serviceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:serviceTextField];
            break;
        }
        case 6:
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, cellSize.height)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.text = @"个人优势";
            tipLabel.font = [UIFont systemFontOfSize:15.0];
            tipLabel.textColor = [UIColor grayColor];
            [cell addSubview:tipLabel];
            
            CGFloat fieldX = SCREENWIDTH-210;
            CGFloat fieldW = 200;
            
            UITextField *advTextField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, 0, fieldW, cellSize.height)];
            advTextField.font = [UIFont systemFontOfSize:15.0];
            advTextField.textAlignment = NSTextAlignmentRight;
            advTextField.textColor = [UIColor blackColor];
            advTextField.backgroundColor = [UIColor clearColor];
            advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            advTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            advTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            advTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:advTextField];
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
            break;
        case 7:
            return 110;
        case 8:
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
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
    if (row == 8) {
        [self postProfessionInfo];
    }
    
}

- (void)postProfessionInfo{
        /*
    NSString *nurseTruename = nameTextField.text;
    NSString *nurseCard = idCardTextField.text;
    NSString *nursePhone = phoneTextField.text;
    NSString *NurseAddress = addressTextField.text;
    NSString *NurseEmail = mailTextField.text;
    
    
    NSString *nurseLicensepic = photoImageStr ? photoImageStr : @"";
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"NurseId" : userAccount,
                               @"NurseLanguage" : [postDic valueForKey:@"NurseTruePic"],
                               @"NurseworkuUnit" : nurseTruename,
                               @"NurseOffice" : [postDic valueForKey:@"NurseSex"],
                               @"NurseNumber" : nurseCard,
                               @"NurseNote" : nursePhone,
                               @"NurseNurseLicensepic" : nurseLicensepic};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:NURSEBASICSINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            
            NSLog(@"success");
            
            
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        [self performSelector:@selector(goToProfessionInfoVC) withObject:nil afterDelay:1.2];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];*/
}

- (void)showLanguageView:(UIButton *)sender{
//    sender.selected = !sender.selected;
    isShowLanguage = !isShowLanguage;
    intoImageBt.selected = !sender.selected;
    [myTableView reloadData];
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
            photoImageView.image = photoImage;
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
    NSLog(@"%ld",sender.tag);
    if (!sender.isSelected) {
        sender.layer.borderColor = [APPDEFAULTTITLECOLOR CGColor];
    }else{
        sender.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    sender.selected = !sender.selected;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
