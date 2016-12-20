//
//  MineViewController.m
//  nurseService
//
//  Created by Tony on 2016/12/14.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MineViewController.h"
#import "Tool.h"
#import "SettingViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSArray *iconArr;
    NSArray *tableItemArr;
    UIImageView *portrait;        //头像
    UILabel *userNameL;       //用户名
}

@property(strong,nonatomic)IBOutlet UITableView *myTableView;

@end

@implementation MineViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = APPDEFAULTTITLETEXTFONT;
//        label.textColor = APPDEFAULTTITLECOLOR;
//        label.textAlignment = NSTextAlignmentCenter;
//        self.navigationItem.titleView = label;
//        label.text = @"我的";
//        [label sizeToFit];
//        self.title = @"我的";
//        self.navigationItem.titleView.hidden = YES;
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
    iconArr = @[@[@"icon_mycollection",@"icon_publish",@"icon_mycomment"],@[@"icon_patient",@"icon_follow",@"icon_fans"],@[@"icon_schedule",@"icon_service",@"icon_myadd"],@[@"icon_invite",@"icon_set",@"icon_set"]];
    tableItemArr = @[@[@"        我的收藏",@"        我的发表",@"        我的评论"],@[@"        我的患者",@"        我的关注",@"        我的粉丝"],@[@"        我的排班表",@"        我的服务",@"        我的常用地址"],@[@"        邀请好友",@"        我的二维码",@"        设置"]];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH-50);
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor clearColor];
    [Tool setExtraCellLineHidden:myTableView];

    CGFloat viewHeight = 200;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, viewHeight);
    headerView.backgroundColor = [UIColor purpleColor];
    
    //头像
    CGFloat imageDia = 70;              //直径
    CGFloat imageX = (SCREENWIDTH-imageDia)/2.0;
    CGFloat imageY = 40;
    portrait = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageDia, imageDia)];
    portrait.userInteractionEnabled = YES;
    portrait.layer.masksToBounds = YES;
    portrait.contentMode = UIViewContentModeScaleAspectFill;
    portrait.image = [UIImage imageNamed:@"index1"];
    portrait.layer.borderWidth = 0.0;
    portrait.layer.cornerRadius = imageDia / 2.0;
    portrait.layer.masksToBounds = YES;
    [headerView addSubview:portrait];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMineInfoView)];
    [portrait addGestureRecognizer:tap];
    
    //    [self setPortaitImg:nil];
    myTableView.tableHeaderView = headerView;
    
    //登录按钮
    //    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageY + imageW + 10, 37, 80, 30)];
    //    loginBtn.center = profileBg.center;
    //    CGRect loginFrame = loginBtn.frame;
    //    loginFrame.origin.x = imageY + imageW + 10;
    //    loginBtn.frame = loginFrame;
    //
    //    [profileBg addSubview:loginBtn];
    //    [loginBtn.layer setMasksToBounds:YES];
    //    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    //    loginBtn.backgroundColor = [UIColor whiteColor];
    //    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    //    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    //    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    [loginBtn addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //用户名
    CGFloat labelX = imageX;
    CGFloat labelY = imageY+imageDia;
    CGFloat labelH = 25;
    CGFloat labelW = imageDia;
    
    userNameL = [[UILabel alloc] init];
    userNameL.textAlignment = NSTextAlignmentCenter;
    userNameL.backgroundColor = [UIColor clearColor];
    userNameL.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    userNameL.textColor = [UIColor whiteColor];
    userNameL.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [headerView addSubview:userNameL];
    userNameL.text = @"Amy";
    //积分
    
    //签到按钮
    CGFloat buttonW = 50;
    CGFloat buttonH = 20;
    CGFloat buttonX = imageX+imageDia+30;
    CGFloat buttonY = imageY+imageDia/2.0-10;
    UIButton *signBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    signBtn.backgroundColor = [UIColor clearColor];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    signBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
    signBtn.layer.borderWidth = 1.0f;//设置边框颜色
    signBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:signBtn];
    
}

- (void)toSignInView{
    NSLog(@"toSignInView");
}

#pragma mark UITableViewdDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return iconArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [iconArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!userCell) {
        userCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat iconY = 10;
    CGFloat iconH = cellSize.height - 2 * iconY;
    CGFloat iconX = 10;
    CGFloat iconW = iconH;
    switch (section) {
        case 0:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr[section] objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr[section] objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 2:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr[section] objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr[section] objectAtIndex:row]]];
            icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [userCell addSubview:icon];
            userCell.textLabel.text = [tableItemArr[section] objectAtIndex:row];
            userCell.textLabel.textColor = [UIColor grayColor];
            userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return userCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];

    NSInteger index = indexPath.row;
    NSInteger sectionNum = indexPath.section;
    NSLog(@"section:%ld,index:%ld",sectionNum,index);
    switch (sectionNum) {
        case 0:
        {
            switch (index) {
                case 0:
                {//我的收藏
                }
                    break;
                case 1:
                {//我的发表
                }
                    break;
                case 2:
                {//我的评论
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (index) {
                case 0:
                {//我的患者
                }
                    break;
                case 1:
                {//我的关注
                }
                    break;
                case 2:
                {//我的粉丝
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (index) {
                case 0:
                {//我的排班表
                }
                    break;
                case 1:
                {//我的服务
                }
                    break;
                case 2:
                {//我的常用地址
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (index) {
                case 0:
                {//邀请好友
                }
                    break;
                case 1:
                {//我的二维码
                }
                    break;
                case 2:
                {//设置
                    SettingViewController *settingViewController = [[SettingViewController alloc] init];
                    settingViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingViewController animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}


- (void)goToMineInfoView{
    
}





#pragma  mark camera
//打开相机,获取照片
-(void)openCamera
{
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
        }];
        
        UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self LocalPhoto];
        }];
        
        // Add the actions.
        [alertController addAction:cameraAction];
        [alertController addAction:libAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
        portrait.image = image;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
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
