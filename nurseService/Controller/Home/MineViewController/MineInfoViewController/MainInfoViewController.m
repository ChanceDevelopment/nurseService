//
//  MainInfoViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/20.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "MainInfoViewController.h"
#import "MyInfoTableViewCell.h"
@interface MainInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *encodedImageStr;
    NSArray *dataArr;
    NSMutableArray *dataSourceArr;
}
@end

@implementation MainInfoViewController
@synthesize myTableView;
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
    
    NSLog(@"userInfoDic:%@",userInfoDic);
    dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@%@",PIC_URL,[userInfoDic valueForKey:@"nurseHeader"]]];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseNick"]]];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nursePhone"]]];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseCard"]]];
    NSString *sex = [[userInfoDic valueForKey:@"nurseSex"] integerValue]==1 ? @"男" : @"女";
    [dataSourceArr addObject:sex];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseNote"]]];
    
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseJob"]]];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseAddress"]]];
    [dataSourceArr addObject:[NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"nurseGoodservice"]]];
    
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


}

- (void)sendDataToServe{
    NSString *headerStr = @"";
    NSString *sexStr = @"1";
    if (encodedImageStr) {
        headerStr = encodedImageStr;
    }
    if ([dataSourceArr[4] isEqualToString:@"女"]) {
        sexStr = @"2";
    }
    NSDictionary * params  = @{@"NurseId": [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]],
                               @"Nurseheader" : headerStr,
                               @"nurseTruename" : dataSourceArr[1],
                               @"NurseSex" : dataSourceArr[4],
                               @"NurseCard" : dataSourceArr[3],
                               @"NursePhone" : dataSourceArr[2],
                               @"NurseAddress" : dataSourceArr[7],
                               @"NurseLanguage" : dataSourceArr[5],
                               @"NurseEmail" : @"",
                               @"NurseCardpic" : @""};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:MODIFYUSERINFO params:params success:^(AFHTTPRequestOperation* operation,id response){
        
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
            [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
        }
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
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
//    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
    
    MyInfoTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.name.text = dataArr[row];
    if (row == 0) {
        cell.nameText.hidden = YES;
        cell.headImageView.hidden = NO;
        cell.headImageView.imageURL = dataSourceArr[row];
    }else{
        cell.nameText.text = dataSourceArr[row];
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
    NSInteger section = indexPath.section;
    
    switch (row) {
        case 0:
            NSLog(@"%ld",row);
            break;
        case 1:
            NSLog(@"%ld",row);
            break;
        case 2:
            NSLog(@"%ld",row);
            break;
        case 3:
            NSLog(@"%ld",row);
            break;
        case 4:
            NSLog(@"%ld",row);
            break;
        case 5:
            NSLog(@"%ld",row);
            break;
        case 6:
            NSLog(@"%ld",row);
            
            break;
        case 7:
            NSLog(@"%ld",row);
            break;
        case 8:
            NSLog(@"%ld",row);
            break;
        default:
            break;
    }
    
    
}


- (IBAction)clickHeadImageAction:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
    sheet.tag = 2;
    [sheet showInView:sender];
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
        UIImage *userImage = [info objectForKey:UIImagePickerControllerEditedImage];
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
//            [headImage setImage:userImage];
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
