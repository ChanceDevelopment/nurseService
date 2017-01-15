//
//  MainInfoViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/20.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MainInfoViewController.h"
#import "MyInfoTableViewCell.h"
@interface MainInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *encodedImageStr;
    NSArray *dataArr;
    NSMutableDictionary *dataSourceDic;
    UIView *windowView;
    UILabel *wordNumL;
    UITextField *addTextField;
    NSInteger currentRow;
    UIButton *girlBt;
    UIButton *boyBt;
}
@property(strong,nonatomic)UIImage *userImage;

@end

@implementation MainInfoViewController
@synthesize myTableView;
@synthesize userImage;
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
        label.text = @"个人资料";
        [label sizeToFit];
        self.title = @"个人资料";
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
    dataArr = @[@"头像",@"昵称",@"手机号",@"身份证号",@"性别",@"我的优势",@"医护信息",@"常用地址",@"可提供服务"];
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNTKEY]];
//    NSString* temp = [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseGoodservice"]];
//    NSArray *arr = [temp componentsSeparatedByString:@","];
//    NSString *t = [Tool convertHexStrToString:arr[0]];
    
    [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseGoodservice"]];
    dataSourceDic = [NSMutableDictionary dictionaryWithCapacity:8];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseHeader"]] forKey:@"nurseHeader"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseNick"]] forKey:@"nurseNick"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nursePhone"]] forKey:@"nursePhone"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseCard"]] forKey:@"nurseCard"];
    NSString *sex = [[userInfoDic valueForKey:@"nurseSex"] integerValue]==1 ? @"男" : @"女";
    [dataSourceDic setValue:sex forKey:@"nurseSex"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseNote"]] forKey:@"nurseNote"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseGoodservice"]] forKey:@"nurseGoodservice"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseAddress"]] forKey:@"nurseAddress"];
    [dataSourceDic setValue:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseJob"]] forKey:@"nurseJob"];
    

    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


}

//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}
- (IBAction)saveAction:(UIButton *)sender {
    [self sendDataToServe];
}

- (void)sendDataToServe{
    NSString *headerStr = @"";
    NSString *sexStr = @"1";
    if (encodedImageStr) {
        headerStr = encodedImageStr;
    }else{
        headerStr = [dataSourceDic valueForKey:@"nurseHeader"];
    }
    if ([[dataSourceDic valueForKey:@"nurseSex"] isEqualToString:@"女"]) {
        sexStr = @"2";
    }
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"nurseId" : [NSString stringWithFormat:@"%@",userAccount],
                               @"nurseheader" : headerStr,
                               @"nurseNick" : [dataSourceDic valueForKey:@"nurseNick"],
                               @"nursePhone" : [dataSourceDic valueForKey:@"nursePhone"],
                               @"nurseSex" : sexStr,
                               @"nurseNote" : [dataSourceDic valueForKey:@"nurseNote"],
                               @"nurseAddress" : [dataSourceDic valueForKey:@"nurseAddress"],
                               @"cardCd" : [dataSourceDic valueForKey:@"nurseCard"],
                               @"nurseInfo" : [dataSourceDic valueForKey:@"nurseJob"],
                               @"goosServices" : [dataSourceDic valueForKey:@"nurseGoodservice"]};

    NSLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:UPDATENURSEINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_NURSEINFOCHANGE object:nil];
            [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.2f];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)backToRootView{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *cellIndentifier = @"MyInfoTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    
    MyInfoTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.name.text = dataArr[row];
    if (row == 0) {
        cell.nameText.hidden = YES;
        cell.headImageView.hidden = NO;
        if (userImage) {
            cell.headImageView.image = userImage;
        }else{
            NSString *userHeader = [NSString stringWithFormat:@"%@%@",PIC_URL,[dataSourceDic valueForKey:@"nurseHeader"]];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"defalut_icon"]];            
        }
    }else{
        NSString *nameStr = @"";
        if (row == 1) {
            nameStr=[dataSourceDic valueForKey:@"nurseNick"];
        }else if (row == 2){
            nameStr=[dataSourceDic valueForKey:@"nursePhone"];
        }else if (row == 3){
            nameStr=[dataSourceDic valueForKey:@"nurseCard"];
        }else if (row == 4){
            nameStr=[dataSourceDic valueForKey:@"nurseSex"];
        }else if (row == 5){
            nameStr=[dataSourceDic valueForKey:@"nurseNote"];
        }else if (row == 7){
            nameStr=[dataSourceDic valueForKey:@"nurseAddress"];
        }
        cell.nameText.text = nameStr;
        cell.nameText.hidden = NO;
        cell.headImageView.hidden = YES;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    return 48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    currentRow = row;
    switch (row) {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
            sheet.tag = 2;
            [sheet showInView:self.view];
        }
            break;
        case 1:
        {
            [self showAddView];
            
        }
            break;
        case 2:
        {
            [self showAddView];
            
        }
            break;
        case 3:
        {
            [self showAddView];

        }
//            NSLog(@"%ld",row);
            break;
        case 4:
        {
            [self showChooseSexView];
        }
            break;
        case 5:
        {
            [self showAddView];
        }
            break;
        case 6:
            NSLog(@"%ld",row);
            break;
        case 7:
        {
            [self showAddView];
        }
            break;
        case 8:
            NSLog(@"%ld",row);
            break;
        default:
            break;
    }
}

- (void)showChooseSexView{
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    windowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];;
    [[[UIApplication sharedApplication] keyWindow] addSubview:windowView];
    
    NSInteger addBgView_W = SCREENWIDTH -20;
    NSInteger addBgView_H = 170;
    NSInteger addBgView_Y = SCREENHEIGH/2.0-addBgView_H/2.0-40;
    UIView *addBgView = [[UIView alloc] initWithFrame:CGRectMake(10, addBgView_Y, addBgView_W, addBgView_H)];
    addBgView.backgroundColor = [UIColor whiteColor];
    [addBgView.layer setMasksToBounds:YES];
    [addBgView.layer setCornerRadius:4];
    addBgView.alpha = 1.0;
    [windowView addSubview:addBgView];

    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    titleL.text = @"请选择性别";
    
    NSInteger boyBt_W = 25;
    NSInteger boyBt_Y = 50;
    boyBt = [[UIButton alloc] init];
    [boyBt setFrame:CGRectMake(10, boyBt_Y, boyBt_W, boyBt_W)];
    [boyBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio_on"] forState:UIControlStateNormal];
    boyBt.tag = 1;
    boyBt.enabled = NO;
    [boyBt addTarget:self action:@selector(chooseSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:boyBt];
    
    UILabel *boyL = [[UILabel alloc] initWithFrame:CGRectMake(10+35, boyBt_Y-8, 100, 40)];
    boyL.textColor = [UIColor blackColor];
    boyL.font = [UIFont systemFontOfSize:15.0];
    boyL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:boyL];
    boyL.text = @"男";

    girlBt = [[UIButton alloc] init];
    [girlBt setFrame:CGRectMake(10, boyBt_Y+30, boyBt_W, boyBt_W)];
    [girlBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio"] forState:UIControlStateNormal];
    girlBt.tag = 2;
    [girlBt addTarget:self action:@selector(chooseSexAction:) forControlEvents:UIControlEventTouchUpInside];
    girlBt.enabled = YES;
    [addBgView addSubview:girlBt];
    
    UILabel *girlL = [[UILabel alloc] initWithFrame:CGRectMake(10+35, boyBt_Y+30-8, 100, 40)];
    girlL.textColor = [UIColor blackColor];
    girlL.font = [UIFont systemFontOfSize:15.0];
    girlL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:girlL];
    girlL.text = @"女";
    
    NSInteger cancleBt_X = SCREENWIDTH-20-10-90;
    NSInteger cancleBt_Y = addBgView_Y - 30;
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
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
}

- (void )chooseSexAction:(UIButton *)sender{
    if (sender.tag == 1) {
        if ([boyBt isEnabled]) {
            [boyBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio_on"] forState:UIControlStateNormal];
            [girlBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio"] forState:UIControlStateNormal];
            boyBt.enabled = NO;
            girlBt.enabled = YES;
            
        }
    }else if (sender.tag == 2){
        if ([girlBt isEnabled]) {
            [girlBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio_on"] forState:UIControlStateNormal];
            [boyBt setBackgroundImage:[UIImage imageNamed:@"abc_btn_radio"] forState:UIControlStateNormal];
            girlBt.enabled = NO;
            boyBt.enabled = YES;
            
        }
    }
    
}

- (void)showAddView{
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

    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:18.0];
    titleL.backgroundColor = [UIColor clearColor];
    [addBgView addSubview:titleL];
    
    NSInteger addTextField_H = 44;
    NSInteger addTextField_Y = 50;
    NSInteger addTextField_W =SCREENWIDTH-40;

    addTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, addTextField_Y, addTextField_W, addTextField_H)];//高度--44
    addTextField.delegate = self;
    addTextField.font = [UIFont systemFontOfSize:15.0];
    addTextField.backgroundColor = [UIColor clearColor];
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    addTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    addTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [addBgView addSubview:addTextField];
    
    if (currentRow == 1) {
        titleL.text = @"昵称";
        addTextField.text = [dataSourceDic valueForKey: @"nurseNick"];
    }else if(currentRow == 2){
        titleL.text = @"手机号";
        addTextField.text = [dataSourceDic valueForKey: @"nursePhone"];
    }else if(currentRow == 3){
        titleL.text = @"身份证号";
        addTextField.text = [dataSourceDic valueForKey: @"nurseCard"];
    }else if(currentRow == 5){
        titleL.text = @"我的优势";
        addTextField.text = [dataSourceDic valueForKey: @"nurseNote"];
    }else if(currentRow == 7){
        titleL.text = @"常用地址";
        addTextField.text = [dataSourceDic valueForKey: @"nurseAddress"];
    }
    //边线
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(10, addTextField_Y+44, addTextField_W, 0.5)];
    [addBgView addSubview:borderLine];
    borderLine.backgroundColor = [UIColor blueColor];
    
    NSInteger wordNum_Y = addTextField_Y+44;
    if (currentRow == 1) {
        wordNumL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-130, wordNum_Y, 100, 20)];
        wordNumL.textColor = [UIColor grayColor];
        wordNumL.textAlignment = NSTextAlignmentRight;
        wordNumL.font = [UIFont systemFontOfSize:10.0];
        wordNumL.backgroundColor = [UIColor clearColor];
        wordNumL.text = [NSString stringWithFormat:@"%ld/16",[[dataSourceDic valueForKey: @"nurseNick"] length]];
        [addBgView addSubview:wordNumL];
    }

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
    [okBt setTitle:@"确定" forState:UIControlStateNormal];
    okBt.backgroundColor = [UIColor clearColor];
        okBt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [okBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    okBt.tag = 1;
    [okBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBgView addSubview:okBt];
    
    
}

- (void)clickBtAction:(UIButton *)sender{
    if (currentRow == 1 && sender.tag == 1) {
        if (addTextField && addTextField.text.length>16) {
            return;
        }
    }
    if (sender.tag == 1) {
        if (currentRow == 1) {
            [dataSourceDic setValue:addTextField.text forKey:@"nurseNick"];
        }else if(currentRow == 2){
            [dataSourceDic setValue:addTextField.text forKey:@"nursePhone"];
        }else if(currentRow == 3){
            [dataSourceDic setValue:addTextField.text forKey:@"nurseCard"];;
        }else if(currentRow == 5){
            [dataSourceDic setValue:addTextField.text forKey:@"nurseNote"];;
        }else if(currentRow == 7){
            [dataSourceDic setValue:addTextField.text forKey:@"nurseAddress"];;
        }else if (currentRow == 4){
            NSString *sex = [girlBt isEnabled] ? @"男" : @"女";
            [dataSourceDic setValue:sex forKey:@"nurseSex"];
        }
        [myTableView reloadData];
    }
    if (windowView) {
        [windowView removeFromSuperview];
    }
    NSLog(@"tag:%ld",sender.tag);
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (currentRow == 1) {
        if (wordNumL) {
            wordNumL.text = [NSString stringWithFormat:@"%ld/16",textField.text.length];
        }
    }
        NSLog(@"textFieldDidEndEditing:%@",textField.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
        
        encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self dismissViewControllerAnimated:YES completion:^{
            [myTableView reloadData];
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
