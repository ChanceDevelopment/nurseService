//
//  HeEnrollVC.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "HeEnrollVC.h"
#import "UIButton+countDown.h"
#import <SMS_SDK/SMSSDK.h>
#import "BrowserView.h"

@interface HeEnrollVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(strong,nonatomic)IBOutlet UITextField *accountField;
@property(strong,nonatomic)IBOutlet UITextField *codeField;
@property(strong,nonatomic)IBOutlet UITextField *passwordField;
@property(strong,nonatomic)IBOutlet UITextField *nickField;
@property(strong,nonatomic)IBOutlet UITextField *inviteCodeField;
@property(strong,nonatomic)IBOutlet UIButton *getCodeButton;
@property(strong,nonatomic)IBOutlet UIButton *securityButton;
@property(strong,nonatomic)IBOutlet UIButton *uploadButton;
@property(strong,nonatomic)IBOutlet UIButton *agreeButton;
@property(strong,nonatomic)IBOutlet UIButton *finishButton;
@property(strong,nonatomic)UIImage *userImage;

@end

@implementation HeEnrollVC
@synthesize accountField;
@synthesize codeField;
@synthesize passwordField;
@synthesize nickField;
@synthesize inviteCodeField;
@synthesize getCodeButton;
@synthesize securityButton;
@synthesize uploadButton;
@synthesize agreeButton;
@synthesize finishButton;
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
        label.text = @"注册账号";
        [label sizeToFit];
        self.title = @"注册账号";
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
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    getCodeButton.layer.borderWidth = 1.0;
    getCodeButton.layer.cornerRadius = 5.0;
    getCodeButton.layer.backgroundColor = APPDEFAULTORANGE.CGColor;
    getCodeButton.layer.masksToBounds = YES;
    
}

//获取验证码
- (IBAction)getCodeButtonClick:(UIButton *)sender
{
    [self cancelInputTap:nil];
    NSString *userPhone = accountField.text;
    if ((userPhone == nil || [userPhone isEqualToString:@""])) {
        [self showHint:@"请输入手机号"];
        return;
    }
    if (![Tool isMobileNumber:userPhone]) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    
    [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:APPDEFAULTORANGE countColor:[UIColor lightGrayColor]];
    //获取注册手机号的验证码
    NSString *zone = @"86"; //区域号
    NSString *phoneNumber = accountField.text;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber
                                   zone:zone
                       customIdentifier:nil
                                 result:^(NSError *error)
     {
         [self hideHud];
         if (!error)
         {
             [self showHint:@"验证码已发送，请注意查收!"];
         }
         else
         {
             NSString *errorString = [NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]];
             [self showHint:errorString];
         }
     }];
}

//同意协议按钮
- (IBAction)agreeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

//完成
- (IBAction)finishButtonClick:(id)sender
{
    NSDictionary * params  = @{@"NurseName": @"15098013781",@"NursePwd" : @"123456",@"NurseNick" : @"123456",@"NurseHeader" : @"123456"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:REGISTERURL params:params success:^(AFHTTPRequestOperation* operation,id response){
        BOOL isJson =  [NSJSONSerialization isValidJSONObject:response];
        if (isJson) {
            NSString *respondStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
            
        }
        
        
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
    }];

}

//选择上传头像
- (IBAction)uploadButtonClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
    sheet.tag = 2;
    [sheet showInView:sender];
}

- (IBAction)scanNurseProtocol:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userProtocol" ofType:@"html"];
    BrowserView *browserView = [[BrowserView alloc] initWithURL:path];
    browserView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browserView animated:YES];
}
- (IBAction)securityButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    passwordField.secureTextEntry = sender.selected;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

//取消输入
- (void)cancelInputTap:(UIButton *)sender
{
    if ([accountField isFirstResponder]) {
        [accountField resignFirstResponder];
    }
    if ([codeField isFirstResponder]) {
        [codeField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
    if ([nickField isFirstResponder]) {
        [nickField resignFirstResponder];
    }
    if ([inviteCodeField isFirstResponder]) {
        [inviteCodeField resignFirstResponder];
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
    userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize sizeImage = userImage.size;
    float a = [self getSize:sizeImage];
    if (a > 0) {
        CGSize size = CGSizeMake(sizeImage.width/a, sizeImage.height/a);
        userImage = [self scaleToSize:userImage size:size];
    }
    
    UIImageJPEGRepresentation(userImage, 0.6);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [uploadButton setBackgroundImage:userImage forState:UIControlStateNormal];
        [uploadButton setBackgroundImage:userImage forState:UIControlStateHighlighted];
    }];
    
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